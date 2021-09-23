# general linux
alias reload="source ~/.zshrc"
alias rl="source ~/.zshrc"
alias cls='clear' # Good 'ol Clear Screen command
alias md='mkdir'
alias dot='code ~/coprime/dotfiles'
alias rl="source ~/.zshrc"
alias lsd='ls -l | grep "^d"' # list only directories
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias l="ls -l ${colorflag}"
alias la="ls -la ${colorflag}"
alias localip="ipconfig getifaddr en1"
alias die-ds-store="find . -name '*.DS_Store' -type f -ls -delete" # Recursively delete `.DS_Store` files
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# node shortcuts
alias dev='npm run dev'
alias tst='npm run test' # can't call this 'test' without npm yelling at me every time I open a new terminal tab
alias build='npm run build'
alias lint="npm run lint"
alias testall="npm run test:all"
alias deploy="npm run deploy"
alias prod="npm run prod"
alias npmGlobal='npm ls -g -depth=0'
alias snap='jest --updateSnapshot'

# coprime
alias latest="npm i @coprime/concept@latest @coprime/codash@latest @coprime/next-config@latest && npm i -D @coprime/eslint-config@latest @coprime/rollup-config@latest @coprime/next-config@latest"

# react native & xcode
alias rni="react-native run-ios"
alias rna="react-native run-android"
alias rnx="react-native run-ios --simulator \"iPhone X\""
alias rnif="rm -rf ios/build/; kill $(lsof -t -i:8081); react-native run-ios"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

# Function Aliases
coprime() {
  cd ~/coprime/absolutely && code .
  cd ~/coprime/axiom && code .
  cd ~/coprime/codash && code .
  cd ~/coprime/configs && code .
  cd ~/coprime/coprime.io && code .
  cd ~/coprime/concept && code .
  cd ~/coprime/designer && code .
  cd ~/coprime/dotfiles && code .
  cd ~/coprime/firecrunch && code .
  cd ~/coprime/hq && code .
  cd ~/coprime/ipa && code .
  cd ~/coprime/jot && code .
  cd ~/coprime/jth.dev && code .
}

# NPM aliases
idev() {
  npm i && npm run dev
}

# Deno aliases
dr() {
  deno run -A $1
}

drw() {
  deno run -A --watch $1
}

dt() {
  deno test -A tests.ts $1
}


# Git aliases
acp() {
  git add -A && git commit -m $1 && git push origin master
}

save() {
  git add -A && git commit -m $1
}

saveup() {
  git add -A && git commit -m $1 && git push origin
}

squash() {
  git rebase -i HEAD~$1
}

gacp() {
  git add -A && git commit -m $1 && git push
}

gcp() {
  git commit -m $1 && git push origin master
}

gnb() {
  git checkout -b $1
}

gpo() {
  git push origin $1
}

# Other helpers
ports() {
  lsof -i tcp:$1
}

e() {
  # finds the project you want to open with 'z', then opens it in your editor
  fasd_cd -d $1 && code .
}

v() {
  if [ $# -eq 0 ]
  then
    vim .
  else
    fasd_cd -d $1 && vim .
  fi
}

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
alias brewfile='vim ~/coprime/dotfiles/Brewfile'

# git aliases

# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
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

# config
alias be-jared-in-this-repo="git config user.email jhanstra@gmail.com"
alias git-email="git config --global user.email"
alias git-name="git config --global user.name"
