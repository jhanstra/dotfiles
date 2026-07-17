#!/usr/bin/env bash
# mac.sh - entry point - set up a new mac from scratch - fully idempotent

set -uo pipefail # continue setup so all failures can be reported together

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/utils.sh"

RUN_INTERACTIVE=false # skip interactive steps by default unless -i or first-time run
DOTFILES_FORCE_LINKS=0 # use safe_link to not replace existing files unless -f
while (($# > 0)); do
  case "$1" in
    -i) RUN_INTERACTIVE=true ;;
    -f|--force) DOTFILES_FORCE_LINKS=1 ;;
    *) echo "usage: ${0##*/} [-i] [-f|--force]" >&2; exit 2 ;;
  esac
  shift
done
export DOTFILES_FORCE_LINKS

ERRORS=()
record_error() {
  local status=$?
  local line="${BASH_LINENO[0]:-unknown}"
  local command="${BASH_COMMAND:-unknown}"
  ERRORS+=("line $line: $command (exit $status)")
}
trap record_error ERR
trap 'exit 130' INT # allow ctrl-c to exit

# Initialize machine profile values before loading saved configuration
DOT_CTX="" CODE="" DOTFILES=""
HOMEBREW_NO_INSTALL_CLEANUP=1

if [[ -f "$HOME/.dotfileconfig" ]]; then
  banner "updating your mac!"
  success "using profile at ~/.dotfileconfig"
  source "$HOME/.dotfileconfig"
else
  RUN_INTERACTIVE=true
  banner "let's set up your new mac!"

  read -rp "which context is this mac? [personal/work] " DOT_CTX
  DOT_CTX="${DOT_CTX:-personal}"

  read -rp "where will your code directory be? [~/code] " CODE
  CODE="${CODE:-$HOME/code}"

  read -rp "where will your dotfiles be located? [$CODE/dotfiles] " DOTFILES
  DOTFILES="${DOTFILES:-$CODE/dotfiles}"
fi

# Refuse unknown contexts before changing the machine
if [[ "$DOT_CTX" != "personal" && "$DOT_CTX" != "work" ]]; then
  echo "Unknown context: $DOT_CTX (expected personal or work)" >&2
  exit 1
fi

# Derive useful paths after loading the repository location
DOT_CFG="$DOTFILES/config"
MAC_CFG="$HOME/.config" # XDG config home
APP_SUP="$HOME/Library/Application Support"

# Save the resolved machine profile to ~/.dotfileconfig
printf 'export DOT_CTX=%q\nexport CODE=%q\nexport DOTFILES=%q\n' \
  "$DOT_CTX" "$CODE" "$DOTFILES" > "$HOME/.dotfileconfig"
chmod 600 "$HOME/.dotfileconfig"

# Print the resolved repository and context
printf '  %-9s %s\n' "dotfiles" "$DOTFILES" "context" "$DOT_CTX"
echo

# Track privileged casks deferred by the shared application allowlist
SUDO_BREWFILE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles/Brewfile.sudo"
export SUDO_BREWFILE
mkdir -p "${SUDO_BREWFILE%/*}"
: > "$SUDO_BREWFILE"

# Check for xcode cli tools
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Complete the Command Line Tools installation, then rerun this script."
  exit 0
fi

# Install homebrew when it is not already available
if ! command -v brew >/dev/null 2>&1 &&
   [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  step "install homebrew"
  safe_install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh /bin/bash
fi

# Make homebrew available in this process
if [[ -x /opt/homebrew/bin/brew ]]; then # apple silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then # intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install only needed tools initially
step "update homebrew and install essential packages"
timed 15m brew update
timed 2m brew trust --formula puma/puma/puma-dev
timed 2m brew trust --formula stripe/stripe-cli/stripe
timed 2m brew trust --formula supabase/tap/supabase
timed 2m brew trust --formula withgraphite/tap/graphite
timed 10m brew bundle install --file="$DOT_CFG/homebrew/Brewfile.bootstrap"

# Xcode installation and updates can require password
if $RUN_INTERACTIVE; then
  update_xcode
fi

# Install node with mise before the interactive npm authentication step uses it
mkdir -p "$MAC_CFG/mise"
if [[ "$DOT_CTX" == "personal" ]]; then
  safe_link "$DOT_CFG/mise/config.toml" "$MAC_CFG/mise/config.toml"
  mise trust "$MAC_CFG/mise/config.toml"
else
  mkdir -p "$MAC_CFG/mise/conf.d"
  safe_link "$DOT_CFG/mise/config.toml" "$MAC_CFG/mise/conf.d/90.jhanstra.toml"
fi

mise install node@24.18.0

# Complete all setup tasks that require user input
if $RUN_INTERACTIVE; then
  bash "$DOTFILES/scripts/interactive.sh"
else
  step "skip interactive setup (use -i to run)"
fi

# Apply our preferred macOS system defaults
step "set macos defaults"
sh "$DOTFILES/scripts/mac-defaults.sh"

# Create needed directories
mkdir -p \
  "$MAC_CFG"/{karabiner,nvim,tmux,git,mise,opencode,zed} \
  "$APP_SUP"/{Code,Cursor}/User \
  "$APP_SUP/com.mitchellh.ghostty" \
  "$APP_SUP/iTerm2/DynamicProfiles" \
  "$HOME"/{.cursor/plugins/local,.claude/skills,.codex,.agents/skills}

# Link config files shared by personal and work Macs
step "link shared config files"
safe_link "$DOT_CFG/git/.gitconfig" "$MAC_CFG/git/config"
safe_link "$DOT_CFG/git/.gitignore" "$MAC_CFG/git/ignore"
safe_link "$DOT_CFG/karabiner/karabiner.json" "$MAC_CFG/karabiner/karabiner.json"
safe_link "$DOT_CFG/vim+tmux/nvim.lua" "$MAC_CFG/nvim/init.lua"
safe_link "$DOT_CFG/vim+tmux/neovim-plugins.json" "$MAC_CFG/nvim/lazy-lock.json"
safe_link "$DOT_CFG/vim+tmux/.tmux.conf" "$MAC_CFG/tmux/tmux.conf"
safe_link "$DOT_CFG/ide/settings.json" "$APP_SUP/Code/User/settings.json"
safe_link "$DOT_CFG/ide/keybindings.json" "$APP_SUP/Code/User/keybindings.json"
safe_link "$DOT_CFG/ide/settings.json" "$APP_SUP/Cursor/User/settings.json"
safe_link "$DOT_CFG/ide/keybindings.json" "$APP_SUP/Cursor/User/keybindings.json"
safe_link "$DOT_CFG/zed/settings.json" "$MAC_CFG/zed/settings.json"
safe_link "$DOT_CFG/ghostty/config" "$APP_SUP/com.mitchellh.ghostty/config"
safe_link "$DOT_CFG/iterm2/profiles.json" "$APP_SUP/iTerm2/DynamicProfiles/jth.json"
# Link AI configuration
safe_link "$DOT_CFG/ai/generated/cursor" "$HOME/.cursor/plugins/local/jth"
safe_link "$DOT_CFG/ai/generated/shared/AGENTS.md" "$HOME/.claude/CLAUDE.md"
safe_link "$DOT_CFG/ai/generated/shared/AGENTS.md" "$HOME/.codex/AGENTS.md"
safe_link "$DOT_CFG/ai/generated/shared/AGENTS.md" "$MAC_CFG/opencode/AGENTS.md"
link_dir "$DOT_CFG/ai/generated/skills" "$HOME/.claude/skills"
link_dir "$DOT_CFG/ai/generated/skills" "$HOME/.agents/skills"

# Install the rest of the languages with mise
step "install language runtimes with mise"
mise install

# Install everything with homebrew
step "install cli homebrew packages"
# Do not apply user pip policies to Homebrew-managed Python environments.
PIP_CONFIG_FILE=/dev/null timed 30m brew bundle install --file="$DOT_CFG/homebrew/Brewfile.cli"

step "install homebrew apps"
install_app_bundle "$DOT_CFG/homebrew/Brewfile.apps"

step "configure app settings"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool false
bash "$DOT_CFG/contexts/settings.sh"
bash "$DOT_CFG/rectangle/settings.sh"

step "install fonts"
timed 30m brew bundle install --file="$DOT_CFG/homebrew/Brewfile.fonts"

step "install other things homebrew doesn't do"
bash "$DOTFILES/scripts/install.sh"

# Install extensions after vscode and cursor are available
step "install ide extensions"
"$DOT_CFG/ide/install-extensions.sh"

# Configure shared and context-specific apps and services that start on login
step "configure startup apps and services"
mkdir -p "$HOME/Library/LaunchAgents"
link_dir "$DOT_CFG/launchd" "$HOME/Library/LaunchAgents"

while IFS=$'\t' read -r context startup_type name _target || [[ -n "$context" ]]; do
  [[ -z "$context" || "$context" == \#* ]] && continue
  [[ "$context" == "all" || "$context" == "$DOT_CTX" ]] || continue
  [[ "$startup_type" == "service" ]] || continue

  timed 5m brew services start "$name"
done < "$DOT_CFG/startup.tsv"

# Personal-only steps
if [[ "$DOT_CTX" == "personal" ]]; then
  step "install personal homebrew apps and run personal-only steps"
  safe_link "$DOT_CFG/zsh/zshrc.zsh" "$HOME/.zshrc"
  safe_link "$DOT_CFG/zsh/zprofile.zsh" "$HOME/.zprofile"
  safe_link "$DOT_CFG/git/.gitconfig.personal" "$HOME/.gitconfig"
  install_app_bundle "$DOT_CFG/homebrew/Brewfile.apps.personal"
else
  step "install work homebrew apps and run work-only steps"
  safe_link "$DOTFILES/adapters/headway/config/.gitconfig.work" "$HOME/.gitconfig.local"
  install_app_bundle "$DOTFILES/adapters/headway/config/Brewfile.apps.work"
  "$DOTFILES/adapters/headway/adapt.sh"
fi

# cleanup items and readout
step "cleanup homebrew"
timed 15m brew cleanup

if [[ -s "$SUDO_BREWFILE" ]]; then
  step "sudo-required setup remains"
  printf '  Run: bash %q\n' "$DOTFILES/sudo.sh"
fi

if ((${#ERRORS[@]} > 0)); then
  step "setup finished with ${#ERRORS[@]} error(s):" >&2
  printf '  - %s\n' "${ERRORS[@]}" >&2
  exit 1
fi

success "setup complete! enjoy your mac!"
