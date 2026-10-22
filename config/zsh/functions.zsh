# Shell and navigation

mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git workflows

save() {
  git add -A &&
    git commit -m "$*"
}

rename() {
  local message="$*"

  if [[ -z "$message" ]]; then
    print -u2 "usage: rename <commit message>"
    return 2
  fi

  git commit --amend -m "$message"
}

oops-committed-to-main() {
  local branch_name="${1:-my-feature}"

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print -u2 "oops-committed-to-main: not inside a Git repository"
    return 1
  fi

  if [[ "$(git branch --show-current)" != "main" ]]; then
    print -u2 "oops-committed-to-main: current branch is not main"
    return 1
  fi

  if [[ "$branch_name" == "main" || -z "$branch_name" ]]; then
    print -u2 "usage: oops-committed-to-main [feature-branch]"
    return 2
  fi

  if ! git show-ref --verify --quiet "refs/heads/$branch_name"; then
    git branch "$branch_name" || return
  else
    print -u2 "oops-committed-to-main: branch '$branch_name' already exists"
    return 1
  fi

  git reset --hard origin/main &&
    git checkout "$branch_name"
}

push_current_branch() {
  local branch upstream
  local -a push_args
  local -F push_started
  local -i push_elapsed_ms

  zmodload zsh/datetime || return

  branch=$(git branch --show-current)
  if [[ -z "$branch" ]]; then
    print -u2 "push: cannot push from a detached HEAD"
    return 1
  fi

  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)
  push_started=$EPOCHREALTIME
  if [[ -z "$upstream" ]]; then
    push_args=(--set-upstream origin "$branch")
  fi
  if ! git push --quiet "${push_args[@]}"; then
    print -u2 "✗ changes are saved locally; retry with: git push"
    return 1
  fi

  upstream="${upstream:-origin/$branch}"
  push_elapsed_ms=$(((EPOCHREALTIME - push_started) * 1000))
  print "✓ pushed $branch → $upstream (${push_elapsed_ms}ms)"
}

sup() { # 'save + up'
  local branch commit_hash message stats

  message="$*"
  if [[ -z "$message" ]]; then
    print -u2 "usage: sup <commit message>"
    return 2
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print -u2 "sup: not inside a Git repository"
    return 1
  fi

  branch=$(git branch --show-current)
  if [[ -z "$branch" ]]; then
    print -u2 "sup: cannot push from a detached HEAD"
    return 1
  fi

  git add -A || return

  if git diff --cached --quiet; then
    print "✓ nothing to commit"
  else
    git commit --quiet -m "$message" || return

    commit_hash=$(git rev-parse --short HEAD)
    stats=$(git show --numstat --format= HEAD | awk '
      NF >= 3 {
        files++
        if ($1 ~ /^[0-9]+$/) additions += $1
        if ($2 ~ /^[0-9]+$/) deletions += $2
      }
      END { printf "%d file%s, +%d/-%d", files, (files == 1 ? "" : "s"), additions, deletions }
    ')
    print -r -- "✓ committed $commit_hash: $message ($stats)"
  fi

  push_current_branch
}

dangerously-merge-pr() {
  local pr="${1:-}"

  if [[ -n "$pr" ]]; then
    gh pr merge "$pr" --admin --squash
  else
    gh pr merge --admin --squash
  fi
}

# Process management

ports() {
  lsof -i "tcp:$1"
}

startup-web() {
  for dir in ~/coprime/apps/*-web/ ~/coprime/sites/*-web/ ~/collab/*/; do
    (cd "$dir" && bun run dev &)
  done
}

# Mac power

_clam_on() {
  pmset -g | grep -q 'SleepDisabled[[:space:]]*1'
}

is-clam() {
  if _clam_on; then
    echo "Yes - clamshell mode is on"
  else
    echo "No - clamshell mode is off"
    return 1
  fi
}

# never sleep, even with the lid closed and no display, until the battery is low
clam() {
  local watcher="$DOTFILES/scripts/clam-watch.sh"

  if ! _clam_on || ! pgrep -qf "$watcher"; then
    sudo /bin/sh -c 'pmset -a disablesleep 1 && { nohup /bin/sh "$1" >/dev/null 2>&1 & }' \
      sh "$watcher" || return
  fi
  if ! _clam_on; then
    print -u2 "clam: couldn't turn on clamshell mode"
    return 1
  fi
  echo "Yep we're in clamshell mode - you can disconnect from the display"
  echo "It turns off automatically at 20% battery when unplugged"
  echo "Run unclam before closing the lid to travel"
}

unclam() {
  _clam_on && { sudo pmset -a disablesleep 0 || return; }
  if _clam_on; then
    print -u2 "unclam: couldn't turn off clamshell mode"
    return 1
  fi
  echo "Out of clamshell mode - the Mac will sleep normally again"
}

# test
startup-mobile() {
  local app="${1:-}"

  if [[ -z "$app" ]]; then
    echo "Usage: startup-mobile <app-name>"
    return 1
  fi

  [[ "$app" == *-app ]] || app="$app-app"
  local dir="$HOME/coprime/apps/$app"

  if [[ ! -f "$dir/package.json" ]]; then
    echo "Unknown mobile app: $app" >&2
    return 1
  fi

  (cd "$dir" && bun run dev &)
}

shutdown() {
  local port pids still_running
  local -a ports=(3000 3001 3002 3003 3004 3005 3006 3007 3008 3009 3010 3011 3012 3013 3014 3015 3016 3017 5555 5556 7777 7778 9000 1111 2222 9999)

  for port in "${ports[@]}"; do
    pids=$(lsof -ti ":$port")

    if [[ -n "$pids" ]]; then
      echo "Shutting down process(es) on port $port (PIDs: $pids)"
      echo "$pids" | xargs kill -15
      sleep 0.2

      still_running=$(lsof -ti ":$port")
      if [[ -n "$still_running" ]]; then
        echo "Force killing process(es) still running on port $port"
        echo "$still_running" | xargs kill -9
      fi
    else
      echo "No process found on port $port"
    fi
  done
}

clean-house() {
  echo "› shutdown development processes"
  shutdown

  echo "› kill .ds_store files"
  ds-store

  echo "› cleanup homebrew"
  brew cleanup

  echo "› homebrew autoremove"
  brew autoremove

  echo "› fresh install in coprime"
  (cd "$HOME/coprime" && fresh-bun)

  echo "› done! run 'restart' to start your development processes"
}

# Git branches

new-branch() {
  if (( $# == 0 )); then
    echo "Usage: new-branch <branch-name>"
    return 1
  fi

  local branch_name="$1"

  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    echo "Error: Not in a git repository"
    return 1
  fi

  git checkout main &&
    git pull &&
    git checkout -b "$branch_name" &&
    git push -u origin "$branch_name"
}

# Editors

openvim() {
  if (( $# == 0 )); then
    nvim .
  else
    nvim "$@"
  fi
}
