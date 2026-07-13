#!/usr/bin/env bash
# mac.sh - entry point - set up a new mac from scratch

set -euo pipefail # exit on errors

# Initialize machine profile values before loading saved configuration
DOT_CTX="" CODE="" DOTFILES=""

echo "› let's set up your new mac!"

# Load the saved user profile or collect it
if [[ -f "$HOME/.dotfileconfig" ]]; then
  echo "using profile at ~/.dotfileconfig"
  source "$HOME/.dotfileconfig"
else
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
source "$DOT_CFG/scripts/utils.sh"

# Save the resolved machine profile to ~/.dotfileconfig
printf 'export DOT_CTX=%q\nexport CODE=%q\nexport DOTFILES=%q\n' \
  "$DOT_CTX" "$CODE" "$DOTFILES" > "$HOME/.dotfileconfig"
chmod 600 "$HOME/.dotfileconfig"

# Print the resolved repository and context
echo "DOTFILES: $DOTFILES"
echo "CONTEXT: $DOT_CTX"

# Check for xcode cli tools
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Complete the Command Line Tools installation, then rerun this script."
  exit 0
fi

# Install homebrew when it is not already available
if ! command -v brew >/dev/null 2>&1 &&
   [[ ! -x /opt/homebrew/bin/brew && ! -x /usr/local/bin/brew ]]; then
  echo "› install homebrew"
  safe_install https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh /bin/bash
fi

# Make homebrew available in this process
if [[ -x /opt/homebrew/bin/brew ]]; then # apple silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then # intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Install only needed tools initially
echo "› install bootstrap homebrew packages"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.bootstrap"

# Complete all setup tasks that require user input
bash "$DOT_CFG/scripts/interactive.sh"

# Apply our preferred macOS system defaults
echo "› set macos defaults"
sh "$DOT_CFG/scripts/mac-defaults.sh"

# Create needed directories
mkdir -p "$MAC_CFG/karabiner" "$MAC_CFG/nvim" "$MAC_CFG/tmux" \
  "$APP_SUP/Code/User" "$APP_SUP/Cursor/User" "$MAC_CFG/git" "$MAC_CFG/mise"

# Link config files shared by personal and work Macs
echo "› link shared config files"
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
safe_link "$DOT_CFG/mise/config.toml" "$MAC_CFG/mise/config.toml"

# Set up mise for language runtime management
echo "› set up mise and install language runtimes"
mise trust "$MAC_CFG/mise/config.toml"
mise install

# Install everything with homebrew
echo "› install cli homebrew packages"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.cli"

echo "› install homebrew apps"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.apps"

echo "› install other things homebrew doesn't do"
bash "$DOT_CFG/scripts/install.sh"

# Install fonts
echo "› install fonts"
mkdir -p "$HOME/Library/Fonts"
while IFS= read -r -d '' FONT; do
  safe_copy "$FONT" "$HOME/Library/Fonts/${FONT##*/}"
done < <(find "$DOTFILES/fonts" -type f \( -name '*.ttf' -o -name '*.otf' -o -name '*.ttc' \) -print0)

# Install extensions after vscode and cursor are available
echo "› install ide extensions"
"$DOT_CFG/ide/install-extensions.sh"

# Personal-only steps
if [[ "$DOT_CTX" == "personal" ]]; then
  echo "› install personal homebrew apps and run personal-only steps"
  safe_link "$DOT_CFG/zsh/zshrc.zsh" "$HOME/.zshrc"
  safe_link "$DOT_CFG/zsh/zprofile.zsh" "$HOME/.zprofile"
  safe_link "$DOT_CFG/git/.gitconfig.personal" "$HOME/.gitconfig"
  brew bundle install --file="$DOT_CFG/homebrew/Brewfile.apps.personal"
fi

# Work-only steps
if [[ "$DOT_CTX" == "work" ]]; then
  echo "› install work homebrew apps and run work-only steps"
  safe_link "$DOTFILES/adapters/headway/config/.gitconfig.work" "$HOME/.gitconfig.local"
  brew bundle install --file="$DOTFILES/adapters/headway/config/Brewfile.apps.work"
  "$DOTFILES/adapters/headway/adapt.sh"
fi

# Success!
echo "› setup complete! enjoy your mac!"
