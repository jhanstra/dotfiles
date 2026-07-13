#!/usr/bin/env bash
# utils.sh - shared utility functions

# Small, color-aware output helpers (set NO_COLOR to disable)
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  UI_BOLD=$'\033[1m' UI_CYAN=$'\033[36m' UI_GREEN=$'\033[32m' UI_RESET=$'\033[0m'
else
  UI_BOLD="" UI_CYAN="" UI_GREEN="" UI_RESET=""
fi

banner() { printf '\n%s  %s%s\n\n' "$UI_BOLD" "$*" "$UI_RESET"; }
success() { printf '%s✓%s %s\n' "$UI_GREEN" "$UI_RESET" "$*"; }
step() { printf '%s»»%s %s\n' "$UI_CYAN" "$UI_RESET" "$*"; }

# Run any command with a deadline such as 30s, 15m, or 1h
timed() {
  local timeout="$1"
  local utils_dir
  shift
  utils_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

  /usr/bin/python3 "$utils_dir/run-with-timeout.py" "$timeout" "$@"
}

# Install, select when needed, and initialize the latest full Xcode release
update_xcode() {
  local current_build developer_dir installed_releases latest_build latest_release latest_version

  step "check for xcode updates"
  timed 2m xcodes update

  latest_release="$(
    NO_COLOR=1 xcodes list |
      awk '/^[0-9]/ && !/(Beta|Release Candidate|GM|Seed)/ { release=$0 } END { print release }'
  )"
  latest_version="${latest_release%% (*}"
  latest_build="${latest_release#*(}"
  latest_build="${latest_build%%)*}"
  current_build="$(xcodebuild -version 2>/dev/null | awk '/Build version/ { print $3 }')"

  if [[ -z "$latest_version" || -z "$latest_build" ]]; then
    echo "Unable to determine the latest stable Xcode release" >&2
    return 1
  fi

  if [[ "$current_build" == "$latest_build" ]]; then
    success "xcode $latest_version is already installed and selected"
  else
    installed_releases="$(NO_COLOR=1 xcodes installed)"
    if [[ "$installed_releases" != *"($latest_build)"* ]]; then
      step "install xcode $latest_version"
      timed 3h xcodes install "$latest_version"
    fi

    step "select xcode $latest_version"
    xcodes select "$latest_version"
  fi

  if ! xcodebuild -checkFirstLaunchStatus; then
    step "finish xcode initialization"
    sudo xcodebuild -runFirstLaunch
  fi
}

# Install a Brewfile while skipping casks backed by privileged macOS packages
install_app_bundle() (
  local brewfile="$1"
  local timeout="${2:-1h}"
  local cask metadata outdated_metadata outdated_casks pkg_casks pkg_cask_list
  local -a casks=()

  while IFS= read -r cask; do
    [[ -n "$cask" ]] && casks+=("$cask")
  done < <(brew bundle list --cask --file="$brewfile")

  if ((${#casks[@]} > 0)); then
    metadata="$(brew info --json=v2 --cask "${casks[@]}")" || return
    pkg_casks="$(/usr/bin/python3 -c '
import json
import sys

casks = json.load(sys.stdin)["casks"]
print("\n".join(
    cask["token"]
    for cask in casks
    if any("pkg" in artifact for artifact in cask.get("artifacts", []))
))
' <<< "$metadata")" || return
  fi

  if [[ -n "$pkg_casks" ]]; then
    pkg_cask_list="${pkg_casks//$'\n'/ }"
    step "defer casks that require administrator access: $pkg_cask_list"
    export HOMEBREW_BUNDLE_CASK_SKIP="${HOMEBREW_BUNDLE_CASK_SKIP:+$HOMEBREW_BUNDLE_CASK_SKIP }$pkg_cask_list"

    if [[ -n "${DOTFILES_SUDO_BREWFILE:-}" ]]; then
      outdated_metadata="$(brew outdated --cask --json=v2)" || return
      outdated_casks="$(/usr/bin/python3 -c '
import json
import sys

print("\n".join(cask["name"] for cask in json.load(sys.stdin)["casks"]))
' <<< "$outdated_metadata")" || return

      while IFS= read -r cask; do
        if ! brew list --cask "$cask" >/dev/null 2>&1 ||
           [[ $'\n'"$outdated_casks"$'\n' == *$'\n'"$cask"$'\n'* ]]; then
          printf "cask '%s'\n" "$cask" >> "$DOTFILES_SUDO_BREWFILE"
        fi
      done <<< "$pkg_casks"
    fi
  fi

  timed "$timeout" brew bundle install --file="$brewfile"
)

# Link a file without replacing unknown user or company files
safe_link() {
  local source_path="$1"
  local target_path="$2"

  if [[ ! -e "$source_path" ]]; then
    echo "Refusing to link missing source: $source_path" >&2
    return 1
  fi

  if [[ -L "$target_path" ]]; then
    if [[ "$(readlink "$target_path")" == "$source_path" ]]; then
      return 0
    fi

    echo "Refusing to replace unknown symlink: $target_path" >&2
    echo "Current target: $(readlink "$target_path")" >&2
    return 1
  fi

  # Adopt empty placeholders and identical regular files without losing data.
  if [[ -f "$target_path" ]] &&
     { [[ ! -s "$target_path" ]] || cmp -s "$source_path" "$target_path"; }; then
    rm "$target_path"
  fi

  if [[ -e "$target_path" ]]; then
    echo "Refusing to replace existing file: $target_path" >&2
    return 1
  fi

  ln -s "$source_path" "$target_path"
}

# Link every child in a directory without replacing unknown targets
link_dir() (
  local source_dir="$1"
  local target_dir="$2"
  local source_path

  if [[ ! -d "$source_dir" ]]; then
    echo "Refusing to link missing directory: $source_dir" >&2
    return 1
  fi

  shopt -s nullglob dotglob
  for source_path in "$source_dir"/*; do
    safe_link "$source_path" "$target_dir/${source_path##*/}"
  done
)

# Download a remote installer completely, run it, clean up, and return its exit code
safe_install() (
  set -e

  local installer
  installer="$(mktemp "${TMPDIR:-/tmp}/dotfiles-installer.XXXXXX")"
  trap 'rm -f "$installer"' EXIT

  curl -fsSL "$1" -o "$installer"
  "$2" "$installer"
)
