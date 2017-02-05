
# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

alias gs="git status -sb" # upgrade your git if -sb breaks for you. it's fun.
alias gb="git branch"
alias gba="git branch -a"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset %an: %s%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gf="git fetch"
alias gco='git checkout'
alias grom="git rebase origin/master"
alias gfgrom="git fetch && git rebase origin/master"
alias ga="git add -A"
alias gc="git commit -m"
alias gac='git add -A && git commit -m'
alias gpom="git push origin master"
alias git-delete-local-merged="git branch -d `git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n'`"
alias git-undo="git reset --soft HEAD^"
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r' # Remove `+` and `-` from start of diff lines; just rely upon color.
