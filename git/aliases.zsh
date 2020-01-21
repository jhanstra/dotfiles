
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
# gacp - check /functions dir

# undoing
alias gu="git reset --"

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
alias git-delete-local-merged="git branch -d `git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n'`"

# pushing and pulling
alias gp="git pull"
alias gpom="git push origin master"

# config
alias be-jared-in-this-repo="git config user.email jhanstra@gmail.com"