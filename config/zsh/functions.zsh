# Shell and navigation

mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Git workflows

save() {
  git add -A &&
    git commit -m "$*"
}

sup() { # 'save + up'
  git add -A &&
    git commit --quiet -m "$*" &&
    git push --quiet origin "$(git symbolic-ref --short HEAD)"
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
