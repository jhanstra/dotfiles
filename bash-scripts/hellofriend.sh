### this file is responsible for linking the vscode and karabiner settings, so they
### can be hosted here but live in their correct locations

# set up - determine dotfiles root
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

# remove any previous vscode settings and add a new file linked to our dotfiles
rm "$HOME/Library/Application Support/Code/User/settings.json"
ln -s "$DOTFILES_ROOT/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"


# remove any previous karabiner settings and add a new file linked to our dotfiles
rm "$HOME/.config/karabiner/karabiner.json"
ln -s "$DOTFILES_ROOT/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"


# cd into the npm-offline folder and run npm install to pre-install a shit ton of
# packages so we have them pre-cached. This allows us to npm install any of these
# packages even while offline.
cd npm-offline
npm install
