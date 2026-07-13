# Cursor Agent CLI helpers

_cursor_agent() {
  if ! (( $+commands[agent] )); then
    print -u2 "Cursor Agent CLI is not installed. Run: bash \"$DOTFILES/scripts/install.sh\""
    return 127
  fi

  command agent -p --trust "$@"
}

aiask() {
  if (( $# == 0 )); then
    print -u2 "Usage: aiask <question>"
    return 2
  fi

  _cursor_agent "Answer this question about the current repository without modifying files: $*"
}

aicommit() {
  _cursor_agent --force \
    "Review all in-progress changes and create small, self-contained commits grouped by purpose. Match the repository's existing commit-message style, exclude secrets and unrelated changes, and do not push."
}

commit() {
  local branch upstream

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    print -u2 "commit: not inside a Git repository"
    return 1
  fi

  branch=$(git branch --show-current)
  if [[ -z "$branch" ]]; then
    print -u2 "commit: cannot push from a detached HEAD"
    return 1
  fi

  _cursor_agent --force "/commit" || return

  upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)
  if [[ -n "$upstream" ]]; then
    git push
  else
    git push --set-upstream origin "$branch"
  fi
}

aifix() {
  local context="${*:-Diagnose the repository's current test, type-check, or lint failures.}"

  _cursor_agent --force \
    "Diagnose and fix the issue in the current repository. Make focused changes, run relevant verification, and do not commit or push. Context: $context"
}

aireview() {
  _cursor_agent \
    "Review the current repository's in-progress changes. Report only actionable correctness, security, and regression risks, prioritized by severity. Do not modify files."
}

aitest() {
  _cursor_agent --force \
    "Inspect the current repository's in-progress changes, run the most relevant tests and static checks, and fix failures caused by those changes. Do not commit or push."
}
