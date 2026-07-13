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

  installed_count=0
  installed_now_count=0
  if [[ "$DRY_RUN" == false ]]; then
    installed_extensions="$("$editor" --list-extensions 2>/dev/null)"
    installed_extensions="$(printf '%s\n' "$installed_extensions" | tr '[:upper:]' '[:lower:]')"
  fi

  while IFS= read -r extension || [[ -n "$extension" ]]; do
    # Skip blank lines and comments
    [[ -z "$extension" || "$extension" == \#* ]] && continue

    # Copilot Chat is available in VS Code but not Cursor's extension marketplace.
    [[ "$editor" == "cursor" && "$extension" == "github.copilot-chat" ]] && continue

    if [[ "$DRY_RUN" == true ]]; then
      echo "$editor --install-extension $extension"
    else
      extension_lower="$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')"
      if [[ $'\n'"$installed_extensions"$'\n' == *$'\n'"$extension_lower"$'\n'* ]]; then
        ((installed_count += 1))
        continue
      fi

      if output="$("$editor" --install-extension "$extension" 2>&1)"; then
        echo "Installed $extension for $editor"
        ((installed_now_count += 1))
      else
        printf '%s\n' "$output" >&2
        exit 1
      fi
    fi
  done < "$EXTENSIONS_FILE"

  if [[ "$DRY_RUN" == false ]]; then
    echo "$editor extensions: $installed_count already installed, $installed_now_count installed"
  fi
done
