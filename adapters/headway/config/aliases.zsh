# Headway-only aliases and functions migrated from 90.my-config.zsh

# work - cd into the directory when switching workspaces
work() {
  if [[ "$1" == "sw" || "$1" == "switch" ]]; then
    local output
    output=$(command work "$@")
    if [[ -d "$output" ]]; then
      cd "$output"
    else
      echo "$output"
    fi
  else
    command work "$@"
  fi
}

# Headway: bring up the full local stack via Tilt without interactive prompts
# Tilt's docker-compose resources hang silently if Docker Desktop isn't running,
# so boot it first and wait for the daemon socket before invoking hw
hw-start() {
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon not reachable; starting Docker Desktop..."
        open -a Docker
        local waited=0
        until docker info >/dev/null 2>&1; do
            if (( waited >= 120 )); then
                echo "Timed out waiting for Docker Desktop after ${waited}s." >&2
                return 1
            fi
            sleep 1
            (( waited++ ))
        done
        echo "Docker ready after ${waited}s."
    fi
    hw local start --stack-name all-services --runner tilt --use-env-defaults "$@"
}
alias hw-stop='hw local stop -y'

# Headway: bring up the full BACKEND stack via Tilt (no frontend apps)
# The installed hw CLI has no `local` subcommand, so this drives Tilt directly,
# which is the canonical orchestrator for every backend service
hw-backend() {
    # Tilt's docker-compose resources hang silently if the Docker daemon socket
    # isn't up yet, so require Docker first. Do NOT auto-launch Docker Desktop:
    # launching it from a non-GUI shell reliably crashes its Electron tray and
    # leaves it half-started, so prompt for a Finder/Spotlight launch instead
    if ! docker info >/dev/null 2>&1; then
        echo "Docker daemon not reachable. Please start Docker Desktop from Finder/Spotlight (Cmd-Space -> Docker)." >&2
        echo "Waiting for the Docker engine..." >&2
        local waited=0
        until docker info >/dev/null 2>&1; do
            if (( waited >= 180 )); then
                echo "Timed out waiting for Docker Desktop after ${waited}s." >&2
                return 1
            fi
            sleep 3
            (( waited += 3 ))
        done
        echo "Docker ready after ${waited}s." >&2
    fi

    # Backend-only Tilt overlay: keep every backend service (database, redis,
    # valkey, s3, elasticsearch, kafka, temporal + workers, eda, ld-server,
    # mamba, celery, celery-beat) and disable the six frontend apps. Lives
    # outside the repo so it never shows up as an untracked file
    local cfg="$HOME/.config/headway/tilt-backend-only.yaml"
    if [ ! -f "$cfg" ]; then
        mkdir -p "$(dirname "$cfg")"
        cat > "$cfg" <<'YAML'
launch_agora: false
launch_atlas: false
launch_marketing: false
launch_sigmund: false
launch_referrals: false
launch_public_marketing: false
YAML
    fi

    ( cd ~/headway/headway || exit 1; tilt up "$@" -- --config-path="$cfg" )
}

# Headway: completely stop and clean up the local stack, reset the postgres database, wait for it to initialize, and seed mock fixtures
hw-reset() {
    local headway_dir="$HOME/headway/headway"
    if [ ! -d "$headway_dir" ]; then
        echo "Error: Headway directory not found at $headway_dir" >&2
        return 1
    fi

    echo "Stopping the local headway stack and killing any orphaned app processes..."
    (cd "$headway_dir" && hw local stop -y >/dev/null 2>&1 || true)

    # Force-kill any lingering processes on our core application ports to prevent connection leaks/locks
    local app_pids
    app_pids=$(lsof -t -i :5000 -i :4004 -i :4001 -i :4000 2>/dev/null)
    if [ -n "$app_pids" ]; then
        echo "Killing active server processes on ports 5000, 4004, 4001, 4000..."
        echo "$app_pids" | xargs kill -9 2>/dev/null || true
    fi

    echo "Wiping local postgres data directory..."
    rm -rf "$headway_dir/local_services/fixtures/_postgres"

    echo "Starting PostgreSQL container..."
    (cd "$headway_dir/local_services/fixtures" && docker compose up -d --wait database)

    echo "Waiting for the 'masteruser' role to be fully created in Postgres..."
    local waited=0
    until docker exec -e PGPASSWORD=headway fixtures-database-1 psql -U masteruser -d headway-local -c "SELECT 1" >/dev/null 2>&1; do
        if (( waited >= 60 )); then
            echo "Timed out waiting for masteruser role in database container." >&2
            return 1
        fi
        sleep 1
        (( waited++ ))
    done
    echo "Database ready and authenticated after ${waited}s."

    echo "Loading mock test fixtures..."
    (cd "$headway_dir/local_services/fixtures" && docker exec --env-file .env -w /tmp/fixtures fixtures-database-1 ./load.sh test)

    echo "🎉 Local database completely reset and seeded successfully!"
}

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
