# general linux
alias rl="source ~/.zshrc"
alias cl='clear'

# tmux
alias th="tmux a -t headway"
alias tc="tmux a -t coprime"

# quickly open projects
alias dot='cursor ~/headway/dotfiles'
alias c='cursor ~/coprime'
alias coprime='cursor ~/coprime'
alias cop='cursor ~/coprime'
alias tb='cursor ~/collab/teebox'

alias h="history -10"
alias hg="history | grep"
alias ag="alias | grep"

# common shortcuts
alias md='mkdir'
alias l="ls -l ${colorflag}"
alias la="ls -la ${colorflag}"
alias ..="cd .. && la"
alias cd..="cd .. && la"
alias ...="cd ../.. && la"
alias ....="cd ../../.. && la"
alias .....="cd ../../../.. && la"
alias lsd='ls -l | grep "^d"' # list only directories

alias mac='bash "$DOTFILES/mac.sh"'
alias localip="ipconfig getifaddr en1"
alias die-ds-store="find . -name '*.DS_Store' -type f -ls -delete" # Recursively delete `.DS_Store` files
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

alias python=python3

# node shortcuts
alias npmg='npm ls -g -depth=0'
alias bung='bun pm ls -g'
alias pnpmg='pnpm ls -g -depth=0'
alias yarng='yarn global list'

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
# e() { fasd_cd -d $1 && code . } # finds with 'z' and opens in VSCode

# MacOS commands
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO'
alias update-mac='sudo softwareupdate -i -a'

# tmux aliases
alias tl='tmux ls'
alias tn='tmux new'
alias td='tmux kill-session -t flow'

# Neovim
alias nvc='nvim ~/.config/nvim/init.lua'

openvim() {
  if (( $# == 0 )); then
    nvim .
  else
    nvim "$@"
  fi
}

alias v='openvim'
alias vim='openvim'
alias brewfile='nvim "$DOTFILES/config/homebrew/Brewfile.cli"'
alias brewapps='nvim "$DOTFILES/config/homebrew/Brewfile.apps"'

# Use `hub` as our git wrapper / http://defunkt.github.com/hub/
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
alias gitignore="git rm -r --cached . && git add ."
alias git-reset="git rm -r --cached . && git add ."

# branches and checking out
alias gb="git branch"
alias gba="git branch -a"
alias branches="git branch -a"
alias gcm="git checkout master"
alias gcmp="git checkout master && git pull"
alias gcb="git checkout -b"
alias gnb="git checkout -b"
alias co="git checkout"
alias gco="git checkout"
alias gbm='git branch -m'
alias gbr='git branch -m'
alias tags="git tag -l"
alias remotes="git remote -v"
# Create branch if missing, otherwise switch to it (avoid naming this `go` — conflicts with Go).
ggo() { git checkout -b "$1" 2>/dev/null || git checkout "$1"; }
# Clear when dirty, then show patch + file stats (no pager).
gds() { git diff-index --quiet HEAD -- || clear; git --no-pager diff --patch-with-stat; }

# rebasing
alias rebase='git fetch && git rebase origin/main'
alias continue='git add -A && git rebase --continue'
alias push='git push --force-with-lease'
# alias git-delete-local-merged="git branch -d `git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n'`"

# pushing and pulling
alias gp="git pull"
alias gpom="git pull origin main && git pull"
alias gpm="git push origin main"

# merge special main branches
alias merge-dev="git fetch origin && git merge origin/dev"

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

# fresh installs / resets
alias freshnpm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'package-lock.json' -type f -prune -exec rm '{}' + && npm i"
alias freshyarn="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'yarn.lock' -type f -prune -exec rm '{}' + && yarn install"
alias freshpnpm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'pnpm-lock.yaml' -type f -prune -exec rm '{}' + && pnpm i"
alias freshbun="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'bun.lock' -type f -prune -exec rm '{}' + && bun install"
alias freshVercel="cd ~/coprime && find . -name '.vercel' -type d -prune -exec rm -rf '{}' +"

# turbo
alias build-actions="bun run build-actions"
alias build-github-actions="bun run build-github-actions"
alias types="bun run types"
alias lint="bun run lint"
alias fmt="bun run fmt"
alias fmt:check="bun run fmt:check"
alias test="bun run test"
alias pw:install="bun run pw:install"
alias pw:ci="bun run pw:ci"
alias pw:basic="bun run pw:basic"
alias pw:app="bun run pw:app"
alias build-preview="bun run build-preview"
alias build-prod="bun run build-prod"
alias deploy-preview="bun run deploy-preview"
alias deploy-prod="bun run deploy-prod"
alias hook-user-prompt-submit="bun run hook-user-prompt-submit"
alias hook-pre-tool-use="bun run hook-pre-tool-use"
alias hook-notification="bun run hook-notification"
alias hook-stop="bun run hook-stop"
alias hook-sub-agent-stop="bun run hook-sub-agent-stop"
alias hook-pre-compact="bun run hook-pre-compact"
alias hook-cursor-stop="bun run hook-cursor-stop"
alias check="cd ~/coprime && axiom check"

# # bun
# alias npm=bun

# axiom
alias ab="cd ~/coprime && axiom bootstrap"
alias b="cd ~/coprime && axiom bootstrap"
alias e="cd ~/coprime && code ."
alias d="cd ~/coprime && bun dev"
alias t="cd ~/coprime && bun run bun-test && bun run deno-test && bun run pw"
alias build="bun run build"
alias dev="bun run dev"
alias only="bun run only"
alias devt="bun run devt"
alias start="bun run start"
alias analyze="bun run analyze"
alias only="bun run only"
alias pw="cd ~/coprime && bun run pw"
alias pwh="cd ~/coprime && bun run pw:head"
alias pwui="cd ~/coprime && bun run pw:ui"
alias qd="bun run build-vercel && bun run deploy-vercel"

alias lines="cloc ~/coprime --exclude-dir=node_modules,dist,.next,.vercel,.turbo,.swc --not-match-f='pnpm-lock.yaml|sw.js|workbox-.*\.js|classnames.json|collisions.json|collisionsByCn.json'"
alias local-iphone="cd && ./ngrok http 7777"

# bun binaries
alias axiom="bun run ~/coprime/bun/axiom/index.js"
alias concept="bun run ~/coprime/bun/concept-cli/index.js"

function startup() {
  (cd ~/coprime &)
  sleep 0.5
  for dir in ~/coprime/apps/*/ ~/coprime/sites/*/ ~/collab/*/; do
    (cd "$dir" && bun run dev &)
  done
}


function shutdown() {
  # Ports that Coprime projects can run on
  ports=(3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 3011 3012 3013 3014 3015 3016 3017 7777 9000 1111 2222 9999)

  for port in "${ports[@]}"; do
    pids=$(lsof -ti :$port)
    if [ ! -z "$pids" ]; then
      echo "Shutting down process(es) on port $port (PIDs: $pids)"
      echo "$pids" | xargs -r kill -15
      # Wait a moment and force kill if still running
      sleep 0.2
      still_running=$(lsof -ti :$port)
      if [ ! -z "$still_running" ]; then
        echo "Force killing process(es) still running on port $port"
        echo "$still_running" | xargs -r kill -9
      fi
    else
      echo "No process found on port $port"
    fi
  done
}

alias restart="shutdown && startup"
alias stash="git stash --include-untracked"

# claude
alias fix-types='claude --dangerously-skip-permissions "Fix the types in this repo. The command to check types is `bun run types`."'
alias yolo='claude --dangerously-skip-permissions'
# alias claude='claude --dangerously-skip-permissions'

# Function to create new git branch
branch() {
    # Check if branch name argument is provided
    if [ $# -eq 0 ]; then
        echo "Usage: branch <branch-name>"
        echo "Example: branch feature/new-feature"
        return 1
    fi

    local BRANCH_NAME="$1"

    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    echo "Switching to main branch..."
    git checkout main || return 1

    echo "Pulling latest changes..."
    git pull || return 1

    echo "Creating and switching to new branch: $BRANCH_NAME"
    git checkout -b "$BRANCH_NAME" || return 1

    echo "Pushing new branch to remote..."
    git push -u origin "$BRANCH_NAME" || return 1

    echo "Successfully created, switched to, and pushed branch: $BRANCH_NAME"
}

# nv - create a new file or directory and open it in neovim
nv() {
    if [[ "$1" == *"."* ]]; then
        # Has a dot - treat as file
        mkdir -p "$(dirname "$1")"
        nvim "$1"
    else
        # No dot - treat as directory
        mkdir -p "$1"
        nvim "$1"
    fi
}

alias checks="cd ~/coprime && axiom check"
