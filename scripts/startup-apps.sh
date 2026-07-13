#!/usr/bin/env bash
# startup-apps.sh - open context-appropriate apps after login

set -uo pipefail

if [[ -f "$HOME/.dotfileconfig" ]]; then
  source "$HOME/.dotfileconfig"
fi

: "${DOT_CTX:=personal}"
: "${DOTFILES:=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"

STARTUP_FILE="$DOTFILES/config/startup.tsv"

while IFS=$'\t' read -r context type name target || [[ -n "$context" ]]; do
  [[ -z "$context" || "$context" == \#* ]] && continue
  [[ "$context" == "all" || "$context" == "$DOT_CTX" ]] || continue
  [[ "$type" == "app" ]] || continue

  open_args=(-g -a "$name")
  if [[ -n "$target" ]]; then
    target="${target/#\~/$HOME}"
    open_args+=("$target")
  fi

  if ! /usr/bin/open "${open_args[@]}"; then
    echo "Startup app is unavailable: $name" >&2
  fi
done < "$STARTUP_FILE"
