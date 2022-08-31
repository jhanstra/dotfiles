if ! command -v brew &>/dev/null; then
    echo "› install homebrew"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "› brew bundle"
brew bundle install --file=./config/Brewfile

echo "› set mac defaults"
chmod 700 ./config/mac-defaults.sh
sh ./config/mac-defaults.sh

echo "› install vscode extenions"
source ./config/vscode-extensions.sh

if [ ! -d ~/.oh-my-zsh ]
then
  echo "› install oh-my-zsh"
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "› link dotfiles and other config files"
ln -sf ~/coprime/utils/dotfiles/.zshrc ~/.zshrc
ln -sf ~/coprime/utils/dotfiles/config/.gitconfig ~/.gitconfig
ln -sf ~/coprime/utils/dotfiles/config/.gitignore ~/.gitignore
ln -sf ~/coprime/utils/dotfiles/config/vscode.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf ~/coprime/utils/dotfiles/config/vscode-keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

echo "› install pnpm global packages"
export PNPM_HOME="~/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
pnpm add --global trash

echo "› set overrides"
echo "Is this a work profile? (y/n)"
read -e isWork

if [ "$isWork" == "y" ]
then
    echo "Git email to use?"
    read -e gitemail
    git config --global user.email "$gitemail"
    # load work-specific shell code
fi
