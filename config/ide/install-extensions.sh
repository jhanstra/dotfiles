#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"
EDITORS=(code cursor)
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
elif [[ $# -gt 0 ]]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

for editor in "${EDITORS[@]}"; do
  if ! command -v "$editor" >/dev/null 2>&1; then
    echo "Skipping $editor: command not found"
    continue
  fi

  echo "Installing extensions for $editor"

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    # Skip blank lines and comments.
    [[ -z "$extension" || "$extension" == \#* ]] && continue

    if [[ "$DRY_RUN" == true ]]; then
      echo "$editor --install-extension $extension"
    else
      "$editor" --install-extension "$extension"
    fi
  done < "$EXTENSIONS_FILE"
done
