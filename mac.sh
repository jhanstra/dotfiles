#!/usr/bin/env bash
# mac.sh - entry point - set up a new mac from scratch

set -euo pipefail # exit on errors

# Initialize machine profile values before loading saved configuration
DOT_CTX=""
CODE=""
DOTFILES=""

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

# Derive useful paths after loading the repository location
DOT_CFG="$DOTFILES/config"
MAC_CFG="$HOME/.config" # XDG config home
APP_SUP="$HOME/Library/Application Support"
DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}" # XDG data home

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

# Install homebrew if it isn't already
if ! command -v brew >/dev/null 2>&1; then
  echo "› install homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ -x /opt/homebrew/bin/brew ]]; then # apple silicon
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then # intel
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Install bootstrap tools first so later mac.sh steps and linked configs work
echo "› install bootstrap homebrew packages"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.bootstrap"


# Apply our preferred macOS system defaults
echo "› set macos defaults"
sh "$DOT_CFG/mac-defaults.sh"

# Use the personal identity as the top-level Git config on personal macs
if [[ "$DOT_CTX" == "personal" ]]; then
  ln -sf "$DOT_CFG/git/.gitconfig.personal" "$HOME/.gitconfig"
else
  ln -sf "$DOTFILES/adapters/headway/config/.gitconfig.work" "$HOME/.gitconfig.local"
fi

# Link all of our config files
echo "› link config files"
mkdir -p "$MAC_CFG/karabiner" "$MAC_CFG/nvim" "$MAC_CFG/tmux" \
  "$APP_SUP/Code/User" "$APP_SUP/Cursor/User" "$MAC_CFG/git" \
  "$DATA_HOME/tmux/plugins"
ln -sf "$DOT_CFG/zsh/zshrc.zsh" "$HOME/.zshrc"
ln -sf "$DOT_CFG/zsh/zprofile.zsh" "$HOME/.zprofile"
ln -sf "$DOT_CFG/git/.gitconfig" "$MAC_CFG/git/config"
ln -sf "$DOT_CFG/git/.gitignore" "$MAC_CFG/git/ignore"
ln -sf "$DOT_CFG/karabiner/karabiner.json" "$MAC_CFG/karabiner/karabiner.json"
ln -sf "$DOT_CFG/vim+tmux/nvim.lua" "$MAC_CFG/nvim/init.lua"
ln -sf "$DOT_CFG/vim+tmux/neovim-plugins.json" "$MAC_CFG/nvim/lazy-lock.json"
ln -sf "$DOT_CFG/vim+tmux/.tmux.conf" "$MAC_CFG/tmux/tmux.conf"
ln -sf "$DOT_CFG/ide/settings.json" "$APP_SUP/Code/User/settings.json"
ln -sf "$DOT_CFG/ide/keybindings.json" "$APP_SUP/Code/User/keybindings.json"
ln -sf "$DOT_CFG/ide/settings.json" "$APP_SUP/Cursor/User/settings.json"
ln -sf "$DOT_CFG/ide/keybindings.json" "$APP_SUP/Cursor/User/keybindings.json"

# Install TPM under XDG data home when missing
if [[ ! -d "$DATA_HOME/tmux/plugins/tpm" ]]; then
  echo "› install tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm "$DATA_HOME/tmux/plugins/tpm"
fi

# Create an ssh key
if [[ ! -d "$HOME/.ssh" ]]; then
  echo "› create ssh key"
  ssh-keygen -f "$HOME/.ssh/id_rsa"
fi

# Authenticate with npm and suppress login messages
echo "› ensure npm authentication"
if npm whoami >/dev/null 2>&1; then
  echo "Logged in to npm"
else
  npm login
fi

# Install everything with homebrew
echo "› install cli homebrew packages"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.cli"
echo "› install homebrew apps"
brew bundle install --file="$DOT_CFG/homebrew/Brewfile.apps"
if [[ "$DOT_CTX" == "personal" ]]; then
  echo "› install personal homebrew apps"
  brew bundle install --file="$DOT_CFG/homebrew/Brewfile.apps.personal"
else
  echo "› install work homebrew apps"
  brew bundle install --file="$DOTFILES/adapters/headway/config/Brewfile.apps.work"
fi

# Copy bundled fonts into the current user's font library
echo "› install fonts"
mkdir -p "$HOME/Library/Fonts"
cp -R "$DOTFILES/fonts/." "$HOME/Library/Fonts/"

# Install all non-homebrew tools and services in one step
DOT_CTX="$DOT_CTX" "$DOT_CFG/install.sh"

# Install extensions after vscode and cursor are available
echo "› install ide extensions"
"$DOT_CFG/ide/install-extensions.sh"

# Report successful completion after all requested operations finish
echo "› setup complete! enjoy your mac!"
