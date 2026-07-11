#!/usr/bin/env bash
# install.sh - install things that can't or shouldn't be managed by homebrew

set -euo pipefail # exit on errors

# This script owns personal-machine extras; work machines use their adapter
if [[ "${DOT_CTX:-}" != "personal" ]]; then
  echo "› skipping personal-only installers for work context"
  exit 0
fi

# Install oh-my-zsh without changing the user's .zshrc
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  echo "› install oh-my-zsh"
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh
fi

# Install full Xcode when missing
if [[ "${DOT_CTX:-}" == "personal" ]] &&
   [[ ! -d /Applications/Xcode.app ]] &&
   ! compgen -G '/Applications/Xcode-[0-9]*.app' >/dev/null; then
  echo "› install xcode"
  xcodes install --latest
fi

# Suppress login messages in terminal
[[ -f "$HOME/.hushlogin" ]] || touch "$HOME/.hushlogin"
