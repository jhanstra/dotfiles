# general linux
alias reload="source ~/.zshrc"
alias rl="source ~/.zshrc"
alias cls='clear' # Good 'ol Clear Screen command
alias md='mkdir'
alias dot='code ~/coprime/dotfiles'
alias rl="source ~/.zshrc"

# node shortcuts
alias dev='npm run dev'
alias idev='npm i && dev'
alias test='npm run test'
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

## MacOS commands
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO'
