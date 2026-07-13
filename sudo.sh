#!/usr/bin/env bash
# sudo.sh - finish setup that invokes privileged macOS package installers

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

if ((EUID == 0)); then
  echo "Run this script as your user, not with sudo." >&2
  exit 1
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

SUDO_BREWFILE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/Brewfile.sudo"
if [[ ! -s "$SUDO_BREWFILE" ]]; then
  success "no administrator-required setup remains"
  exit 0
fi

step "install apps that require administrator access"
timed 1h brew bundle install --force --file="$SUDO_BREWFILE"
rm "$SUDO_BREWFILE"
success "administrator-required setup complete"
