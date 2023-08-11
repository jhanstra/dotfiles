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
# alias dev='pnpm run dev'
# alias devt='pnpm run devt'
# alias tst='pnpm run test' # can't call this 'test' without npm yelling at me every time I open a new terminal tab
# alias build='pnpm run build'
# alias start='pnpm run start'
# alias lint="pnpm run lint"

# alias testall="npm run test:all"
# alias deploy="npm run deploy"
# alias prod="npm run prod"
alias npmGlobal='npm ls -g -depth=0'
alias snap='jest --updateSnapshot'

# coprime
alias coprime="code $DOTFILES/config/coprime-main.code-workspace"
alias c="coprime"

# indeed
alias indeed="code $DOTFILES/config/indeed-main.code-workspace"

# react native & xcode
alias rni="react-native run-ios"
alias rna="react-native run-android"
alias rnx="react-native run-ios --simulator \"iPhone X\""
alias rnif="rm -rf ios/build/; kill $(lsof -t -i:8081); react-native run-ios"
alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
alias watchos="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator\ \(Watch\).app"

# NPM aliases
# idev() { pnpm i && pnpm run dev }

# Deno aliases
dr() { deno run -A $1 }
drw() { deno run -A --watch $1 }
dt() { deno test -A tests.ts $1 }

# Git aliases
acp() { git add -A && git commit -m $1 && git push origin main }
save() { git add -A && git commit -m $1 }
saveup() { git add -A && git commit -m $1 && git push origin $(git symbolic-ref --short HEAD) }
sup() { git add -A && git commit -m $1 && git push origin $(git symbolic-ref --short HEAD) }
squash() { git rebase -i HEAD~$1 }
gacp() { git add -A && git commit -m $1 && git push }
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

alias fresh-install="cd ~/coprime && find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'pnpm-lock.yaml' -type f -prune -exec rm '{}' + && pnpm i"
alias fresh-install-npm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'package-lock.json' -type f -prune -exec rm '{}' + && npm i"
alias freshVercel="cd ~/coprime && find . -name '.vercel' -type d -prune -exec rm -rf '{}' +"
alias fresh="fresh-install"

# turbo

# pnpm
alias npm=pnpm

# axiom
alias i="cd ~/coprime && x install"
# alias dev="cd ~/coprime && pnpm dev"
alias d="cd ~/coprime && pnpm dev"
alias t="cd ~/coprime && pnpm jest && pnpm deno-test && pnpm pw"
alias t="test"
alias b="cd ~/coprime && pnpm build"
alias build="b"
alias pw="cd ~/coprime && pnpm run pw"
alias pwh="cd ~/coprime && pnpm run pw:head"
alias pwui="cd ~/coprime && pnpm run pw:ui"
alias clean="cd ~/coprime && find ./* -name 'node_modules' -prune -o -type f -name 'next-env.d.ts' -delete && find ./* -name 'node_modules' -prune -o -type f -name '.gitignore' -delete && find ./* -name 'node_modules' -prune -o -type f -name '.DS_Store' -delete"