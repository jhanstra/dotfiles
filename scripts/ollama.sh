#!/usr/bin/env bash
# Install optional, large Ollama models declared in config/ollama/models.txt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODELS_FILE="$SCRIPT_DIR/../config/ollama/models.txt"

if ! command -v ollama >/dev/null 2>&1; then
  echo "Ollama is not installed or its command is unavailable." >&2
  exit 1
fi

while IFS= read -r MODEL || [[ -n "$MODEL" ]]; do
  [[ -z "$MODEL" || "$MODEL" == \#* ]] && continue

  if ollama show "$MODEL" >/dev/null 2>&1; then
    echo "Already installed: $MODEL"
  else
    echo "Pulling Ollama model: $MODEL"
    ollama pull "$MODEL"
  fi
done < "$MODELS_FILE"
