echo "› Let's set up your new Mac!"
echo "Is this a work profile? (y/n)"
read -e ISWORK
if [ ! -f ~/.dotfileconfig ]
then
  echo "Where will your code directory be? (e.g. ~/coprime)"
  read -e CODE
  echo "Where will your dotfiles be located? (e.g. $CODE/dotfiles)"
  read -e DOTFILES
  echo "\nexport ISWORK=$ISWORK\nexport CODE=$CODE\nexport DOTFILES=$DOTFILES" > $HOME/.dotfileconfig
else
  echo "Using dotfile config at ~/.dotfileconfig. If you wish to start over from scratch, remove this file"
  source $HOME/.dotfileconfig
fi

echo $DOTFILES
echo $ISWORK

if ! command -v brew &>/dev/null; then
  echo "› install homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "› install most important brew packages"
brew bundle install --file=$DOTFILES/config/Brewfile
# speed up dramatically by only installing these for now.
# Run `sh config/fullBrew.sh` later on - it takes forever

echo "› set mac defaults"
chmod 700 $DOTFILES/config/mac-defaults.sh
sh $DOTFILES/config/mac-defaults.sh

echo "› install vscode extenions"
source $DOTFILES/config/vscode-extensions.sh

if [ ! -d ~/.oh-my-zsh ]
then
  echo "› install oh-my-zsh"
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "› link dotfiles and other config files"
ln -sf $DOTFILES/.zshrc ~/.zshrc
ln -sf $DOTFILES/config/.gitconfig ~/.gitconfig
ln -sf $DOTFILES/config/.gitignore ~/.gitignore
ln -sf $DOTFILES/config/karabiner.json ~/.config/karabiner/karabiner.json
ln -sf $DOTFILES/config/vscode.json ~/Library/Application\ Support/Code/User/settings.json
ln -sf $DOTFILES/config/vscode-keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
cp -R $DOTFILES/fonts/ ~/Library/Fonts

if [ ! -d ~/.nvm ]
then
  echo "› set up nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | zsh
else
  source $HOME/.nvm/nvm.sh # Load nvm
fi

if [ ! -d ~/.bun ]
then
  echo "› install bun"
  curl https://bun.sh/install | bash
fi

if [ ! -d ~/.ssh ]
then
  echo "› set up ssh"
  ssh-keygen -f ~/.ssh/id_rsa
fi

echo "› install pnpm global packages"
export PNPM_HOME="~/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
cd ~/ && pnpm install --global trash-cli snipster eslint jest tldr
rm -rf /Users/jth/~

if [ "$ISWORK" == "y" ]
then
  # Work-specific config
  echo "Git email to use?"
  read -e gitemail
  git config --global user.email "$gitemail"
else
  # Personal-specific config
  echo "› npm login & install projects"
  npm whoami
  if [ $? -eq 0 ]; then
    echo "Logged in to npm"
  else
    npm login
  fi

  # Main repos at top level of code directory
  for name in jot axiom concept ipa codash jth.dev; do
    cd $CODE
    git clone https://github.com/coprime/$name.git
    cd $name
    nvm use
    pnpm install
  done

  # Secondary repos in /etc folder in code directory
  mkdir $CODE/etc
  for name in eslint-config domains domains2 codra-kai firecrunch designer absolutely middleway rollup-config coprime.dev austin-medical-associates coprime.io hq; do
    cd $CODE/etc
    git clone https://github.com/coprime/$name.git
    cd $name
    nvm use
    pnpm install
  done

  echo "› install deno binaries"
  deno install -A -f -r -n concept $CODE/concept/cli/mod.js
  deno install -A -f -r -n x $CODE/axiom/mod.js
  deno install -A -f -r $CODE/axiom/mod.js
  deno install -A -f -r $CODE/etc/absolutely/mod.js
fi
