#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/config.zsh"
TARGET_DIR="$HOME/.zshrc.d"
# Headway uses Chezmoi which loads files in az order, so we use 99.headway.zsh to load last
TARGET="$TARGET_DIR/99.headway.zsh"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
elif [[ $# -gt 0 ]]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Headway Zsh extension directory not found: $TARGET_DIR" >&2
  echo "Run Headway's machine bootstrap before this adapter." >&2
  exit 1
fi

if [[ -L "$TARGET" && "$(readlink "$TARGET")" == "$SOURCE" ]]; then
  echo "Headway adapter is already linked: $TARGET"
  exit 0
fi

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  echo "Refusing to replace existing file: $TARGET" >&2
  exit 1
fi

if [[ -e "$TARGET_DIR/90.my-config.zsh" ]]; then
  echo "Warning: $TARGET_DIR/90.my-config.zsh still exists." >&2
  echo "Review it for duplicated personal configuration before using this adapter." >&2
fi

if [[ "$DRY_RUN" == true ]]; then
  echo "Would link: $TARGET -> $SOURCE"
else
  ln -s "$SOURCE" "$TARGET"
  echo "Linked: $TARGET -> $SOURCE"
fi
