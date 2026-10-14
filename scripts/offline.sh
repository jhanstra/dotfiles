#!/usr/bin/env bash
# offline.sh - optionally cache packages and repositories for offline use

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="$SCRIPT_DIR/../config/offline/packages.txt"
REPOSITORIES_FILE="$SCRIPT_DIR/../config/offline/repos.tsv"
DRY_RUN=false

while (($# > 0)); do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    *) echo "usage: ${0##*/} [--dry-run]" >&2; exit 2 ;;
  esac
  shift
done

if [[ -f "$HOME/.dotfileconfig" ]]; then
  source "$HOME/.dotfileconfig"
fi

OFFLINE_ROOT="${DOTFILES_OFFLINE_ROOT:-${CODE:-$HOME/code}/offline}"
BUN_PROJECT="$OFFLINE_ROOT/bun"
REPOSITORIES_DIR="$OFFLINE_ROOT/repositories"
FAILURES=0

if ! $DRY_RUN && ! command -v bun >/dev/null 2>&1; then
  echo "Bun is required to cache packages." >&2
  exit 1
fi

if ! $DRY_RUN && ! command -v git >/dev/null 2>&1; then
  echo "Git is required to cache repositories." >&2
  exit 1
fi

if $DRY_RUN; then
  echo "Would create Bun cache project: $BUN_PROJECT"
else
  mkdir -p "$BUN_PROJECT"
  if [[ ! -f "$BUN_PROJECT/package.json" ]]; then
    printf '{\n  "name": "offline-cache",\n  "private": true\n}\n' > "$BUN_PROJECT/package.json"
  fi
fi

while IFS= read -r package || [[ -n "$package" ]]; do
  [[ -z "$package" || "$package" == \#* ]] && continue

  if $DRY_RUN; then
    echo "Would cache Bun package: $package"
  elif ! (cd "$BUN_PROJECT" && bun add "$package"); then
    echo "Failed to cache Bun package: $package" >&2
    FAILURES=$((FAILURES + 1))
  fi
done < "$PACKAGES_FILE"

while IFS=$'\t' read -r url destination || [[ -n "$url" ]]; do
  [[ -z "$url" || "$url" == \#* ]] && continue

  target="$REPOSITORIES_DIR/$destination"
  if [[ -d "$target/.git" ]]; then
    echo "Skipping existing repository: $target"
  elif $DRY_RUN; then
    echo "Would clone: $url -> $target"
  else
    mkdir -p "$(dirname "$target")"
    if ! git clone "$url" "$target"; then
      echo "Failed to clone repository: $url" >&2
      FAILURES=$((FAILURES + 1))
    fi
  fi
done < "$REPOSITORIES_FILE"

if ((FAILURES > 0)); then
  echo "Offline setup completed with $FAILURES failure(s)." >&2
  exit 1
fi

echo "Offline setup complete: $OFFLINE_ROOT"
