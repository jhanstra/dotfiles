#!/usr/bin/env bash
# doctor.sh - report whether this Mac matches the dotfiles configuration

set -uo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES="${DOTFILES:-$SCRIPT_DIR}"
DOT_CTX="${DOT_CTX:-}"
CODE="${CODE:-}"
FAILURES=()

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  GREEN=$'\033[32m' RED=$'\033[31m' DIM=$'\033[2m' RESET=$'\033[0m'
else
  GREEN="" RED="" DIM="" RESET=""
fi

pass() { printf '%s✓%s %-22s — %s\n' "$GREEN" "$RESET" "$1" "$2"; }
skip() { printf '%s– %-22s — %s%s\n' "$DIM" "$1" "$2" "$RESET"; }
fail() {
  printf '%s✗%s %-22s — %s\n' "$RED" "$RESET" "$1" "$2"
  FAILURES+=("$1")
}

run_check() {
  local label="$1" ok="$2" fix="$3"
  shift 3
  if "$@" >/dev/null 2>&1; then
    pass "$label" "$ok"
  else
    fail "$label" "$fix"
  fi
}

check_commands() {
  local command missing=()
  for command in "$@"; do
    command -v "$command" >/dev/null 2>&1 || missing+=("$command")
  done
  ((${#missing[@]} == 0)) || {
    MISSING_COMMANDS="${missing[*]}"
    return 1
  }
}

check_link() {
  local source_path="$1" target_path="$2"
  [[ -L "$target_path" && "$(readlink "$target_path")" == "$source_path" ]]
}

check_link_set() {
  local source_path target_path
  BROKEN_LINKS=()
  while (($# > 0)); do
    source_path="$1"
    target_path="$2"
    shift 2
    check_link "$source_path" "$target_path" || BROKEN_LINKS+=("$target_path")
  done
  ((${#BROKEN_LINKS[@]} == 0))
}

check_link_dir() {
  local source_dir="$1" target_dir="$2" source_path
  shopt -s nullglob dotglob
  for source_path in "$source_dir"/*; do
    check_link "$source_path" "$target_dir/${source_path##*/}" || return 1
  done
}

check_brewfile() {
  brew bundle check --file="$1"
}

check_mise() {
  [[ -z "$(mise ls --current --missing --no-header 2>/dev/null)" ]]
}

check_extensions() {
  local editor="$1" extension installed
  installed="$("$editor" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')" || return
  while IFS= read -r extension || [[ -n "$extension" ]]; do
    [[ -z "$extension" || "$extension" == \#* ]] && continue
    [[ "$editor" == "cursor" && "$extension" == "github.copilot-chat" ]] && continue
    extension="$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')"
    [[ $'\n'"$installed"$'\n' == *$'\n'"$extension"$'\n'* ]] || return 1
  done < "$DOTFILES/config/ide/extensions.txt"
}

check_ssh_key() {
  local public_key
  shopt -s nullglob
  for public_key in "$HOME"/.ssh/*.pub; do
    [[ -f "${public_key%.pub}" ]] || continue
    [[ "$(cut -d ' ' -f 1 "$public_key")" == "ssh-ed25519" ]] && return 0
  done
  return 1
}

check_other_tools() {
  local data_home="${XDG_DATA_HOME:-$HOME/.local/share}"
  [[ -d "$data_home/tmux/plugins/tpm/.git" ]] &&
    [[ -x "$data_home/tmux/plugins/tpm/tpm" ]] &&
    { command -v agent >/dev/null 2>&1 || [[ -x "$HOME/.local/bin/agent" ]]; } &&
    [[ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]] &&
    [[ -f "$HOME/.hushlogin" ]]
}

check_repositories() {
  local context repository destination target
  while IFS=$'\t' read -r context repository destination || [[ -n "$context" ]]; do
    [[ -z "$context" || "$context" == \#* ]] && continue
    [[ "$context" == "all" || "$context" == "$DOT_CTX" ]] || continue
    target="$HOME/$destination"
    if [[ "$repository" == */\* ]]; then
      [[ -d "$target" ]] || return 1
    else
      [[ -d "$target/.git" ]] || return 1
    fi
  done < "$DOTFILES/config/repos.tsv"
}

if [[ -f "$HOME/.dotfileconfig" ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.dotfileconfig"
  pass "Machine profile" "${DOT_CTX:-unset} · ${DOTFILES:-unset}"
else
  fail "Machine profile" "missing ~/.dotfileconfig; run ./mac.sh"
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  pass "Platform" "macOS $(sw_vers -productVersion)"
else
  fail "Platform" "macOS is required"
fi

if [[ -d "$DOTFILES/.git" ]]; then
  pass "Dotfiles repository" "$DOTFILES"
else
  fail "Dotfiles repository" "not a git repository: $DOTFILES"
fi

if [[ "$DOT_CTX" == "personal" || "$DOT_CTX" == "work" ]]; then
  pass "Context" "$DOT_CTX"
else
  fail "Context" "expected personal or work, got ${DOT_CTX:-unset}"
fi

run_check "Xcode tools" "$(xcode-select -p 2>/dev/null)" "run xcode-select --install" xcode-select -p

if command -v brew >/dev/null 2>&1; then
  pass "Homebrew" "$(brew --prefix)"
else
  fail "Homebrew" "not on PATH; run ./mac.sh"
fi

if check_commands git gh mise jq curl bun shellcheck; then
  pass "Core CLI tools" "all installed"
else
  fail "Core CLI tools" "missing: $MISSING_COMMANDS; run ./mac.sh"
fi

if command -v brew >/dev/null 2>&1; then
  run_check "Bootstrap packages" "Brewfile satisfied" "missing packages; run ./mac.sh" \
    check_brewfile "$DOTFILES/config/homebrew/Brewfile.bootstrap"
  run_check "CLI packages" "Brewfile satisfied" "missing packages; run ./mac.sh" \
    check_brewfile "$DOTFILES/config/homebrew/Brewfile.cli"
  run_check "Applications" "Brewfile satisfied" "missing apps; run ./mac.sh" \
    check_brewfile "$DOTFILES/config/homebrew/Brewfile.apps"
  run_check "Fonts" "Brewfile satisfied" "missing fonts; run ./mac.sh" \
    check_brewfile "$DOTFILES/config/homebrew/Brewfile.fonts"

  if [[ "$DOT_CTX" == "personal" ]]; then
    run_check "Personal applications" "Brewfile satisfied" "missing apps; run ./mac.sh" \
      check_brewfile "$DOTFILES/config/homebrew/Brewfile.apps.personal"
  elif [[ "$DOT_CTX" == "work" ]]; then
    run_check "Work applications" "Brewfile satisfied" "missing apps; run ./mac.sh" \
      check_brewfile "$DOTFILES/adapters/headway/config/Brewfile.apps.work"
  fi
else
  skip "Homebrew packages" "skipped because brew is unavailable"
fi

if command -v mise >/dev/null 2>&1; then
  run_check "Mise runtimes" "all installed" "missing runtimes; run mise install" check_mise
else
  skip "Mise runtimes" "skipped because mise is unavailable"
fi

MAC_CFG="$HOME/.config"
APP_SUP="$HOME/Library/Application Support"
if check_link_set \
  "$DOTFILES/config/git/.gitconfig" "$MAC_CFG/git/config" \
  "$DOTFILES/config/git/.gitignore" "$MAC_CFG/git/ignore" \
  "$DOTFILES/config/karabiner/karabiner.json" "$MAC_CFG/karabiner/karabiner.json" \
  "$DOTFILES/config/vim+tmux/nvim.lua" "$MAC_CFG/nvim/init.lua" \
  "$DOTFILES/config/vim+tmux/neovim-plugins.json" "$MAC_CFG/nvim/lazy-lock.json" \
  "$DOTFILES/config/vim+tmux/.tmux.conf" "$MAC_CFG/tmux/tmux.conf" \
  "$DOTFILES/config/ide/settings.json" "$APP_SUP/Code/User/settings.json" \
  "$DOTFILES/config/ide/keybindings.json" "$APP_SUP/Code/User/keybindings.json" \
  "$DOTFILES/config/ide/settings.json" "$APP_SUP/Cursor/User/settings.json" \
  "$DOTFILES/config/ide/keybindings.json" "$APP_SUP/Cursor/User/keybindings.json" \
  "$DOTFILES/config/zed/settings.json" "$MAC_CFG/zed/settings.json" \
  "$DOTFILES/config/ghostty/config" "$APP_SUP/com.mitchellh.ghostty/config" \
  "$DOTFILES/config/iterm2/profiles.json" "$APP_SUP/iTerm2/DynamicProfiles/jth.json" \
  "$DOTFILES/config/ai/generated/cursor" "$HOME/.cursor/plugins/local/jth" \
  "$DOTFILES/config/ai/generated/shared/AGENTS.md" "$HOME/.claude/CLAUDE.md" \
  "$DOTFILES/config/ai/generated/shared/AGENTS.md" "$HOME/.codex/AGENTS.md" \
  "$DOTFILES/config/ai/generated/shared/AGENTS.md" "$MAC_CFG/opencode/AGENTS.md"; then
  pass "Shared config links" "all correct"
else
  fail "Shared config links" "${#BROKEN_LINKS[@]} incorrect; run ./mac.sh"
fi

if check_link_dir "$DOTFILES/config/ai/generated/skills" "$HOME/.claude/skills" &&
   check_link_dir "$DOTFILES/config/ai/generated/skills" "$HOME/.agents/skills" &&
   check_link_dir "$DOTFILES/config/launchd" "$HOME/Library/LaunchAgents"; then
  pass "Managed directories" "skills and LaunchAgents linked"
else
  fail "Managed directories" "links differ; run ./mac.sh"
fi

if [[ "$DOT_CTX" == "personal" ]]; then
  if check_link_set \
    "$DOTFILES/config/mise/config.toml" "$MAC_CFG/mise/config.toml" \
    "$DOTFILES/config/zsh/zshrc.zsh" "$HOME/.zshrc" \
    "$DOTFILES/config/zsh/zprofile.zsh" "$HOME/.zprofile" \
    "$DOTFILES/config/git/.gitconfig.personal" "$HOME/.gitconfig"; then
    pass "Personal config" "mise, zsh, and git linked"
  else
    fail "Personal config" "${#BROKEN_LINKS[@]} incorrect; run ./mac.sh"
  fi
elif [[ "$DOT_CTX" == "work" ]]; then
  if check_link_set \
    "$DOTFILES/config/mise/config.toml" "$MAC_CFG/mise/conf.d/90.jhanstra.toml" \
    "$DOTFILES/adapters/headway/config/.gitconfig.work" "$HOME/.gitconfig.local" \
    "$DOTFILES/adapters/headway/config/zshrc.work.zsh" "$HOME/.zshrc.d/99.jth.headway.zsh" &&
     [[ -f "$HOME/.zshrc.d/00.jth.headway.zsh" ]] &&
     grep -qx 'export NO_FANCY_SHELL=1' "$HOME/.zshrc.d/00.jth.headway.zsh"; then
    pass "Work adapter" "mise, zsh, and git configured"
  else
    fail "Work adapter" "configuration differs; run adapters/headway/adapt.sh"
  fi
fi

run_check "GitHub authentication" "authenticated as $(gh api user --jq .login 2>/dev/null)" \
  "not authenticated; run gh auth login" gh auth status --hostname github.com

run_check "SSH key" "Ed25519 key present" "missing key; run ./mac.sh -i" check_ssh_key
run_check "Other installers" "TPM, Agent, Oh My Zsh ready" "incomplete; run ./mac.sh" check_other_tools

if [[ "$DOT_CTX" == "personal" ]]; then
  run_check "Repositories" "configured paths present" "missing repositories; run ./mac.sh" check_repositories
else
  skip "Repositories" "none configured for $DOT_CTX"
fi

if [[ -f "$DOTFILES/.env" ]]; then
  pass "Local environment" ".env present"
else
  fail "Local environment" "missing .env; copy .env.example"
fi

run_check "Karabiner config" "valid JSON" "invalid JSON; rebuild config/karabiner" \
  jq empty "$DOTFILES/config/karabiner/karabiner.json"

for editor in code cursor; do
  case "$editor" in
    code) editor_label="Code" ;;
    cursor) editor_label="Cursor" ;;
  esac
  if command -v "$editor" >/dev/null 2>&1; then
    run_check "$editor_label extensions" "all installed" "missing extensions; run config/ide/install-extensions.sh" \
      check_extensions "$editor"
  else
    fail "$editor_label extensions" "$editor command not found"
  fi
done

SUDO_BREWFILE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/Brewfile.sudo"
if [[ ! -s "$SUDO_BREWFILE" ]]; then
  pass "Privileged apps" "nothing pending"
else
  fail "Privileged apps" "pending installs; run ./sudo.sh"
fi

run_check "Startup agent" "loaded" "not loaded; log out and back in" \
  launchctl print "gui/$(id -u)/com.jth.dotfiles.startup-apps"

if ((${#FAILURES[@]} == 0)); then
  printf '\n%s✓ healthy%s\n' "$GREEN" "$RESET"
else
  failure_index=1
  printf '\n%s✗ %d failed%s — ' "$RED" "${#FAILURES[@]}" "$RESET"
  printf '%s' "${FAILURES[0]}"
  while ((failure_index < ${#FAILURES[@]})); do
    printf ', %s' "${FAILURES[$failure_index]}"
    ((failure_index += 1))
  done
  printf '\n'
  exit 1
fi
