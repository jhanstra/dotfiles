### this file is responsible for linking the vscode and karabiner settings, so they
### can be hosted here but live in their correct locations

cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)

rm "$HOME/Library/Application Support/Code/User/settings.json"
rm "$HOME/.config/karabiner/karabiner.json"

ln -s "$DOTFILES_ROOT/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
ln -s "$DOTFILES_ROOT/karabiner/karabiner.json" "$HOME/.config/karabiner/karabiner.json"