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

  if [[ -e "$target_path" ]]; then
    echo "Refusing to replace existing file: $target_path" >&2
    return 1
  fi

  ln -s "$source_path" "$target_path"
}

# Copy a file without replacing unknown contents
safe_copy() {
  local source_path="$1"
  local target_path="$2"

  if [[ -e "$target_path" || -L "$target_path" ]]; then
    if [[ -f "$target_path" ]] && cmp -s "$source_path" "$target_path"; then
      return 0
    fi

    echo "Refusing to replace existing file: $target_path" >&2
    return 1
  fi

  cp "$source_path" "$target_path"
}

# Download a remote installer completely, run it, clean up, and return its exit code
safe_install() (
  set -e

  local installer
  installer="$(mktemp "${TMPDIR:-/tmp}/dotfiles-installer.XXXXXX")"
  trap 'rm -f "$installer"' EXIT

  curl -fsSL "$1" -o "$installer"
  "$2" "$installer"
)
