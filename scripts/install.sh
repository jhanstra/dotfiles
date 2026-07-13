#!/usr/bin/env bash
# install.sh - install things that can't or shouldn't be managed by homebrew

set -euo pipefail # exit on errors

# Load shared helpers when this script is run directly
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Load the machine context used to select personal or work repositories
if [[ -f "$HOME/.dotfileconfig" ]]; then
  source "$HOME/.dotfileconfig"
fi

# Clone configured repositories in repos.tsv and install their CLI packages
REPOSITORIES_FILE="$SCRIPT_DIR/../config/repos.tsv"
clone_repo() {
  local owner="$1"
  local repo="$2"
  local destination="$3"
  local url="https://github.com/$owner/$repo.git"
  local target="$HOME/$destination"

  if [[ -d "$target/.git" ]]; then
    :
  elif [[ -e "$target" ]]; then
    echo "Refusing to replace non-repository path: $target" >&2
    exit 1
  else
    step "clone $url"
    mkdir -p "$(dirname "$target")"
    git clone "$url" "$target"
  fi

  # Install repository-owned CLI packages that declare executable binaries
  if [[ -f "$target/package.json" ]] &&
     jq -e '.bin | (type == "string" and length > 0) or (type == "object" and length > 0)' \
       "$target/package.json" >/dev/null; then
    step "link command-line package from $target"
    bun link --cwd "$target"
  fi
}

while IFS=$'\t' read -r context repository destination || [[ -n "$context" ]]; do
  [[ -z "$context" || "$context" == \#* ]] && continue
  [[ "$context" == "all" || "$context" == "$DOT_CTX" ]] || continue

  owner="${repository%%/*}"
  repo="${repository#*/}"
  if [[ "$repo" == "*" ]]; then
    while IFS= read -r repo; do
      clone_repo "$owner" "$repo" "$destination/$repo"
    done < <(gh repo list "$owner" --limit 1000 --json name --jq '.[].name')
  else
    clone_repo "$owner" "$repo" "$destination"
  fi
done < "$REPOSITORIES_FILE"

# Install TPM under XDG data home when missing
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
TPM_DIR="$DATA_HOME/tmux/plugins/tpm"

if [[ ! -d "$TPM_DIR/.git" || ! -f "$TPM_DIR/tpm" ]]; then
  if [[ -e "$TPM_DIR" ]]; then
    echo "Refusing to replace incomplete TPM directory: $TPM_DIR" >&2
    exit 1
  fi

  step "install tmux plugin manager"
  mkdir -p "$DATA_HOME/tmux/plugins"
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Install Cursor's Agent CLI for headless AI shell commands
if ! command -v agent >/dev/null 2>&1 && [[ ! -x "$HOME/.local/bin/agent" ]]; then
  step "install cursor agent cli"
  safe_install https://cursor.com/install /bin/bash
fi

# Suppress login messages in terminal
[[ -f "$HOME/.hushlogin" ]] || touch "$HOME/.hushlogin"
