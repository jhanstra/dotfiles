# Shell and navigation

mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git workflows

save() {
  git add -A &&
    git commit -m "$*"
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
    return 0
  fi

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

  push_current_branch
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
