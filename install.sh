#!/usr/bin/env bash
#
# Run all dotfiles installers.

set -e

cd "$(dirname $0)"/..

# Run Homebrew through the Brewfile
echo "› brew bundle"
# arch -x86_64 brew bundle --file=~/coprime/dotfiles/Brewfile
# arch -x86_64 brew install 'homebrew/cask/1password'
# arch -x86_64 brew install 'homebrew/cask/alfred'
# arch -x86_64 brew install 'homebrew/cask/brave-browser'
# arch -x86_64 brew install 'homebrew/cask/charles'
# arch -x86_64 brew install 'homebrew/cask/docker'
# arch -x86_64 brew install 'homebrew/cask/dropbox'
# arch -x86_64 brew install 'homebrew/cask/firefox'
# arch -x86_64 brew install 'homebrew/cask/google-chrome'
# arch -x86_64 brew install 'homebrew/cask/grandperspective'
# arch -x86_64 brew install 'homebrew/cask/hammerspoon'
# arch -x86_64 brew install 'homebrew/cask/insomnia'
# arch -x86_64 brew install 'homebrew/cask/iterm2'
# arch -x86_64 brew install 'homebrew/cask/karabiner-elements'
# arch -x86_64 brew install 'homebrew/cask/kindle'
# arch -x86_64 brew install 'homebrew/cask/moom'
# arch -x86_64 brew install 'homebrew/cask/mysqlworkbench'
# arch -x86_64 brew install 'homebrew/cask/notion'
# arch -x86_64 brew install 'homebrew/cask/postman'
# arch -x86_64 brew install 'homebrew/cask/sip'
# arch -x86_64 brew install 'homebrew/cask/sketch'
# arch -x86_64 brew install 'homebrew/cask/slack'
# arch -x86_64 brew install 'homebrew/cask/spectacle'
# arch -x86_64 brew install 'homebrew/cask/spotify'
# arch -x86_64 brew install 'homebrew/cask/virtualbox'
# arch -x86_64 brew install 'homebrew/cask/visual-studio-code'
arch -x86_64 brew install 'homebrew/cask/vlc'

# find the installers and run them iteratively
find . -name install.sh | while read installer ; do sh -c "${installer}" ; done

# set up permissions for executable files
cd ..
find bin -type f -exec chmod 700 {} \;
find functions -type f -exec chmod 700 {} \;
chmod 700 homebrew/install.sh
chmod 700 macos/install.sh
chmod 700 macos/set-defaults.sh
