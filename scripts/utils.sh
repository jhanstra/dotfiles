#!/usr/bin/env bash
# utils.sh - shared utility functions

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
