#!/usr/bin/env bash
# interactive.sh - complete setup tasks that require user input

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

step "complete interactive setup"

# Authenticate the credential helper configured in config/git/.gitconfig
if ! gh auth status --hostname github.com >/dev/null 2>&1; then
  step "log in to github"
  gh auth login --hostname github.com --git-protocol https --web
fi

# Create an Ed25519 SSH key when no suitable key exists
SSH_KEY=""
for PUBLIC_KEY in "$HOME"/.ssh/*.pub; do
  [[ -f "$PUBLIC_KEY" && -f "${PUBLIC_KEY%.pub}" ]] || continue
  [[ "$(cut -d ' ' -f 1 "$PUBLIC_KEY")" == "ssh-ed25519" ]] || continue
  SSH_KEY="${PUBLIC_KEY%.pub}"
  break
done

if [[ -z "$SSH_KEY" ]]; then
  step "create ssh key"
  mkdir -p "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519"
fi

# Authenticate with npm when private packages or publishing is needed
if ! mise exec node@24 -- npm whoami >/dev/null 2>&1; then
  step "log in to npm"
  mise exec node@24 -- npm login
fi

# Install Oh My Zsh without changing shell startup files
if [[ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  if [[ -e "$HOME/.oh-my-zsh" ]]; then
    echo "Refusing to replace incomplete Oh My Zsh directory: $HOME/.oh-my-zsh" >&2
    exit 1
  fi

  step "install oh-my-zsh"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    safe_install https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh sh
fi
