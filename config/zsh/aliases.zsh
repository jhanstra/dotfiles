# shell and navigation
alias rl='exec zsh' # start a clean shell without initializing plugins twice
alias cl='clear' # clear the screen
alias h='history -10' # show last 10 commands
alias hg='history | grep' # search history for a command

# alias l='ls -l ${colorflag}' # list files and directories in long format
# alias la='ls -la ${colorflag}' # list all files and directories
# alias lsd='ls -l | grep "^d"' # list only directories
if (( $+commands[eza] )); then
  alias ls='eza --hyperlink --icons=auto'
  alias l='eza -l --hyperlink --icons=auto --group-directories-first --git'
  alias la='eza -la --hyperlink --icons=auto --group-directories-first --git'
  alias lsd='eza -l --only-dirs --hyperlink --icons=auto'
  alias ll='ls -l --group-directories-first --git'
  alias lt='ls --tree'
  alias llt='ll --tree'
fi
alias cd..='cd .. && la'
alias ..='cd .. && la'
alias ...='cd ../.. && la'
alias ....='cd ../../.. && la'
alias .....='cd ../../../.. && la'
alias o='open .'


# projects
alias c='cursor ~/coprime'

# axiom
alias b='cd ~/coprime && axiom bootstrap'
alias checks='cd ~/coprime && axiom check'
alias a='axiom ai'
alias ai='axiom ai'
alias cursorcommit='axiom ai cursorcommit'
alias task='axiom ai task'
alias plan='axiom ai plan'
alias explain='axiom ai explain'
alias fix='axiom ai fix'
alias review='axiom ai review'
alias verify='axiom ai verify'
alias simplify='axiom ai simplify'
alias docs='axiom ai docs'
alias recap='axiom ai recap'
alias pr='axiom ai pr'

# git status and history
alias gs='git status -sb'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset %an: %s%Creset %Cgreen(%cr)%Creset%C(yellow)%d%Creset' --abbrev-commit --date=relative"
alias gd='git diff --color | sed "s/^\([^-+ ]*\)[-+ ]/\\1/" | less -r'

# git changes and branches
alias rebase='git fetch && git rebase origin/main'
alias gcont='git add -A && git rebase --continue'
alias ga='git add -A'
alias git-reset='git rm -r --cached . && git add .'
alias branch='git checkout -b'
alias stash='git stash --include-untracked'
alias gu='git reset --'
alias branches='git branch -a'
alias push='git push'
alias force-push='git push --force-with-lease'
alias gp='git pull'

# project tasks
alias types='bun run types'
alias lint='bun run lint'
alias build='bun run build'
alias dev='bun run dev'
alias only='bun run only'
alias devt='bun run devt'
alias start='bun run start'
alias analyze='bun run analyze'
alias fmt='bun run fmt'
alias fmt:check='bun run fmt:check'
alias test='bun run test'
alias pw:install='bun run pw:install'
alias pw:ci='bun run pw:ci'
alias pw:basic='bun run pw:basic'
alias pw:app='bun run pw:app'
alias build-preview='bun run build-preview'
alias build-prod='bun run build-prod'
alias deploy-preview='bun run deploy-preview'
alias deploy-prod='bun run deploy-prod'
alias fresh-vercel="cd ~/coprime && find . -name '.vercel' -type d -prune -exec rm -rf '{}' +"

# vim + tmux
alias vim='openvim'
alias v='openvim'
alias nvc='nvim ~/.config/nvim/init.lua'
alias tl='tmux ls'
alias tn='tmux new'
alias td='tmux kill-session -t flow'
alias tc='tmux a -t coprime'

# mac utils
alias mac='bash "$DOTFILES/mac.sh"'
alias mac-i='bash "$DOTFILES/mac.sh" -i'
alias mac-f='bash "$DOTFILES/mac.sh" -f'
alias mac-if='bash "$DOTFILES/mac.sh" -i -f'
alias update-mac='sudo softwareupdate -i -a'
alias ds-store='find "$HOME" \( -path "$HOME/Library" -o -path "$HOME/Music" -o -path "$HOME/Movies" -o -path "$HOME/Pictures" -o -path "$HOME/Dropbox" -o -path "$HOME/Google Drive" -o -path "$HOME/OneDrive" -o -name ".git" -o -name "node_modules" -o -name ".cache" \) -prune -o -name ".DS_Store" -type f -exec rm -f {} +'
alias pubkey="pbcopy < ~/.ssh/id_ed25519.pub && echo '=> Public key copied to pasteboard'"
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO'
alias restart='shutdown && startup-web'
alias usage='du -h -d1 -I=/\.git/'
alias lowpower='sudo pmset -a lowpowermode 1'
alias highpower='sudo pmset -a lowpowermode 0'
alias islowpower='pmset -g | grep lowpowermode'
alias path='echo "$PATH" | tr ":" "\n" | sort'

# networking
alias myip='curl https://ipinfo.io/json'
alias localip='ipconfig getifaddr en1'
alias listening='lsof -nP -iTCP -sTCP:LISTEN'

# package managers
alias npmg='npm ls -g -depth=0'
alias bung='bun pm ls -g'
alias fresh-npm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'package-lock.json' -type f -prune -exec rm '{}' + && npm i"
alias fresh-yarn="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'yarn.lock' -type f -prune -exec rm '{}' + && yarn install"
alias fresh-pnpm="find . -name 'node_modules' -type d -prune -exec rm -rf '{}' + && find . -name 'pnpm-lock.yaml' -type f -prune -exec rm '{}' + && pnpm i"
alias fresh-bun="find . -type d \( -name node_modules -o -name .next -o -name dist -o -name build -o -name .turbo -o -name .vercel -o -name coverage \) -prune -exec rm -rf '{}' + && bun install --frozen-lockfile"

# misc
alias python='python3'
alias lines="cloc ~/coprime --exclude-dir=node_modules,dist,.next,.vercel,.turbo,.swc --not-match-f='pnpm-lock.yaml|sw.js|workbox-.*\.js|classnames.json|collisions.json|collisionsByCn.json'"
alias local-iphone='cd && ./ngrok http 7777'