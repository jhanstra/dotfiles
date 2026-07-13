#!/usr/bin/env bash
# install.sh - install things that can't or shouldn't be managed by homebrew

set -euo pipefail # exit on errors

# Install TPM under XDG data home when missing
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TPM_DIR="$DATA_HOME/tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR/.git" || ! -f "$TPM_DIR/tpm" ]]; then
  if [[ -e "$TPM_DIR" ]]; then
    echo "Refusing to replace incomplete TPM directory: $TPM_DIR" >&2
    exit 1
  fi

  echo "› install tmux plugin manager"
  mkdir -p "$DATA_HOME/tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Suppress login messages in terminal
[[ -f "$HOME/.hushlogin" ]] || touch "$HOME/.hushlogin"
