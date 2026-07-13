#!/usr/bin/env bash
# adapt.sh - connect personal dotfiles to Headway's managed shell setup

set -uo pipefail # don't exit on error

# Headway manages ~/.zshrc with chezmoi. That file automatically sources every
# ~/.zshrc.d/*.zsh file in alphabetical order, while leaving personal files in
# that directory unmanaged. This adapter uses that supported extension point
# instead of changing any company-managed chezmoi files

# Resolve this adapter's directory so it works from any current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# Disable Headway's fancy zsh set-up, use mine
mkdir -p "$HOME/.zshrc.d"
printf '%s\n' 'export NO_FANCY_SHELL=1' > "$HOME/.zshrc.d/00.jth.headway.zsh"

# The 99 file loads the personal shell after required managed modules
ln -sfn "$SCRIPT_DIR/config/zshrc.work.zsh" "$HOME/.zshrc.d/99.jth.headway.zsh"

printf '✓ overlaid Headway config!\n'
