#!/usr/bin/env bash
# adapt.sh - connect personal dotfiles to Headway's managed shell setup

set -euo pipefail # exit on error

# Headway manages ~/.zshrc with chezmoi. That file automatically sources every
# ~/.zshrc.d/*.zsh file in alphabetical order, while leaving personal files in
# that directory unmanaged. This adapter uses that supported extension point
# instead of changing any company-managed chezmoi files.

# Resolve this adapter's directory so it works from any current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The 99 prefix loads after Headway's numbered managed modules
TARGET="$HOME/.zshrc.d/99.headway.zsh"

# Link Headway's overlay, which sets work context and sources personal config
mkdir -p "$HOME/.zshrc.d" # create if it doesn't exist
ln -sf "$SCRIPT_DIR/config/zsh-config.zsh" "$TARGET" # link our zsh config

# Git config automatically linked by mac.sh - no need to link it here

echo "› overlaid Headway config: $TARGET"
