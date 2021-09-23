#!/usr/bin/env bash

set -e

# Run Homebrew through the Brewfile
echo "› brew bundle"
cd config
brew bundle

# set up permissions for executable files
echo "> set mac defaults"
cd ..
chmod 700 scripts/mac-defaults.sh
sh scripts/mac-defaults.sh

# use this command to list all vscode extensions on an already configured computer:
# code --list-extensions | xargs -L 1 echo code --install-extension
# more info: https://stackoverflow.com/questions/35773299/how-can-you-export-vs-code-extension-list#

echo "> install vscode extensions"
code --install-extension ahmadawais.shades-of-purple
code --install-extension azemoh.one-monokai
code --install-extension BriteSnow.vscode-toggle-quotes
code --install-extension christian-kohler.path-intellisense
code --install-extension dbaeumer.vscode-eslint
code --install-extension dustinsanders.an-old-hope-theme-vscode
code --install-extension eamodio.gitlens
code --install-extension earshinov.sort-lines-by-selection
code --install-extension ericadamski.carbon-now-sh
code --install-extension esbenp.prettier-vscode
code --install-extension fisheva.eva-theme
code --install-extension formulahendry.code-runner
code --install-extension funkyremi.vscode-google-translate
code --install-extension Gruntfuggly.todo-tree
code --install-extension HookyQR.beautify
code --install-extension IBM.output-colorizer
code --install-extension idleberg.hopscotch
code --install-extension jevakallio.vscode-hacker-typer
code --install-extension jpoissonnier.vscode-styled-components
code --install-extension JuanBlanco.solidity
code --install-extension kumar-harsh.graphql-for-vscode
code --install-extension kuscamara.electron
code --install-extension lkytal.pomodoro
code --install-extension mikestead.dotenv
code --install-extension monokai.theme-monokai-pro-vscode
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension naumovs.color-highlight
code --install-extension nopjmp.fairyfloss
code --install-extension Perkovec.emoji
code --install-extension Prisma.prisma
code --install-extension quicktype.quicktype
code --install-extension samundrak.esdoc-mdn
code --install-extension sdras.night-owl
code --install-extension shyykoserhiy.vscode-spotify
code --install-extension thomaspink.theme-github
code --install-extension vikyd.vscode-fold-level
code --install-extension vscode-icons-team.vscode-icons
code --install-extension vscodevim.vim
code --install-extension WakaTime.vscode-wakatime
code --install-extension wart.ariake-dark
code --install-extension wesbos.theme-cobalt2
code --install-extension will-stone.plastic
code --install-extension wix.vscode-import-cost
code --install-extension yatki.vscode-surround
