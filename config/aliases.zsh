# general linux
alias reload="source ~/.zshrc"
alias rl="source ~/.zshrc"
alias cl='clear'
alias cls='clear'
alias md='mkdir'
alias dot='code ~/coprime/dotfiles'
alias r="source ~/.zshrc"
alias h="history -10"
alias hg="history | grep"
alias ag="alias | grep"
alias lsd='ls -l | grep "^d"' # list only directories
alias dot="code -n ~/coprime/dotfiles"
alias mac="sh $DOTFILES/mac.sh"
alias l="ls -l ${colorflag}"
alias la="ls -la ${colorflag}"
alias ..="cd .. && la"
alias cd..="cd .. && la"
alias ...="cd ../.. && la"
alias ....="cd ../../.. && la"
alias .....="cd ../../../.. && la"
alias co="cd $CODE && la"
alias cop="cd $CODE && la"
alias localip="ipconfig getifaddr en1"
alias die-ds-store="find . -name '*.DS_Store' -type f -ls -delete" # Recursively delete `.DS_Store` files
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# node shortcuts
alias dev='npm run dev'
alias devt='npm run devt'
alias tst='npm run test' # can't call this 'test' without npm yelling at me every time I open a new terminal tab
alias build='npm run build'
alias start='npm run start'
alias lint="npm run lint"
alias testall="npm run test:all"
alias deploy="npm run deploy"
alias prod="npm run prod"
alias npmGlobal='npm ls -g -depth=0'
alias snap='jest --updateSnapshot'
alias installEslint='yarn add --dev @babel/core@7.16.0 @babel/eslint-parser@7.16.0 @coprime/eslint-config@1.2.8 eslint@8.1.0 eslint-config-airbnb@18.2.1 eslint-config-prettier@8.3.0 eslint-import-resolver-webpack@0.13.2 eslint-plugin-import@2.25.2 eslint-plugin-jsx-a11y@6.4.1 eslint-plugin-mdx@1.16.0 eslint-plugin-prettier@4.0.0 eslint-plugin-react@7.26.1 eslint-plugin-react-hooks@4.2.0 prettier@2.4.1 prettier-eslint@13.0.0'
alias esl='installEslint'

# coprime
alias coprime="code $DOTFILES/config/coprime-main.code-workspace"
alias c="coprime"
alias latest="npm i @coprime/concept@latest @coprime/codash@latest @coprime/next-config@latest && npm i -D @coprime/eslint-config@latest @coprime/rollup-config@latest @coprime/next-config@latest"

# indeed
alias indeed="code $DOTFILES/config/indeed-main.code-workspace"
alias i="indeed"

# react native & xcode
alias rni="react-native run-ios"
alias rna="react-native run-android"
alias rnx="react-native run-ios --simulator \"iPhone X\""
alias rnif="rm -rf ios/build/; kill $(lsof -t -i:8081); react-native run-ios"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

# NPM aliases
idev() { pnpm i && pnpm run dev }

# Deno aliases
dr() { deno run -A $1 }
drw() { deno run -A --watch $1 }
dt() { deno test -A tests.ts $1 }

# Git aliases
acp() { git add -A && git commit -m $1 && git push origin main }
save() { git add -A && git commit -m $1 }
saveup() { git add -A && git commit -m $1 && git push origin }
sup() { git add -A && git commit -m $1 && git push origin }
squash() { git rebase -i HEAD~$1 }
gacp() { git add -A && git commit -m $1 && git push }
# gcp() { git commit -m $1 && git push origin master }
# gnb() { git checkout -b $1 }
gpo() { git push origin $1 }

# Other helpers
ports() { lsof -i tcp:$1 }
e() { fasd_cd -d $1 && code . } # finds with 'z' and opens in VSCode

# MacOS commands
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO'
alias update-mac='sudo softwareupdate -i -a'

# tmux aliases
alias tl='tmux ls'
alias tn='tmux new'
alias td='tmux kill-session -t flow'

# vim aliases
alias vimrc='vim ~/.vimrc'
alias v='vim .'
alias brewfile='vim $DOTFILES/config/Brewfile'

# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  # alias git=$hub_path
fi

# statuses
alias gs="git status -sb" # upgrade your git if -sb breaks for you. it's fun.
alias gl="git log --graph --pretty=format:'%Cred%h%Creset %an: %s%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r' # Remove `+` and `-` from start of diff lines; just rely upon color.

# fetching and rebasing
alias gf="git fetch"
alias grom="git rebase origin/master"
alias gfgrom="git fetch && git rebase origin/master"

# adding and committing
alias ga="git add -A"
alias gc="git commit"
alias gac="git add -A && git commit"
alias gacm="git add -A && git commit -m"
alias gacc="git add -A && git commit"
alias amend='git commit --amend -m'
alias gu="git reset --" # undoing

# branches and checking out
alias gb="git branch"
alias gba="git branch -a"
alias gcm="git checkout master"
alias gcmp="git checkout master && git pull"
alias gcb="git checkout -b"
alias gnb="git checkout -b"
alias gco="git checkout"
alias gbm='git branch -m'
alias gbr='git branch -m'
# alias git-delete-local-merged="git branch -d `git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n'`"

# pushing and pulling
alias gp="git pull"
alias gpom="git push origin master"
alias gpm="git push origin main"

# config
alias be-jared-in-this-repo="git config user.email jhanstra@gmail.com"
alias git-email="git config --global user.email"
alias git-name="git config --global user.name"

# etc
alias usage="du -h -d1 -I=/\.git/"
alias lowpower="sudo pmset -a lowpowermode 1" # switch to Low Power mode on Mac
alias highpower="sudo pmset -a lowpowermode 0" # switch to normal power mode
alias islowpower="pmset -g |grep lowpowermode" # are we on Low Power mode?
alias path="echo $PATH | tr ":" "\n" | sort" # print $PATH nicely
alias myip="curl https://ipinfo.io/json"
alias python="python3"

alias fresh-install="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'pnpm-lock.yaml' -type f -prune -exec rm '{}' + && pnpm i"
alias fresh="fresh-install"

# turbo
alias turbo="cd ~/coprime && turbo dev"
alias build="cd ~/coprime && turbo build"
alias test="cd ~/coprime && turbo test"
alias test="cd ~/coprime && turbo test"

# pnpm
alias npm=pnpm