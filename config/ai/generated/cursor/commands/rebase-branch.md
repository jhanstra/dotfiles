---
name: rebase-branch
description: Safely rebase the current branch
---

# Rebase the current branch

Safely rebase the current Git branch using the latest remote state. Inspect the repository, remotes, tracking branch, remote default branch, commit graph, and working tree before acting. Fetch first.

Preserve every local and remote commit: incorporate remote-only commits from the current branch's upstream when present, then rebase the combined branch onto the remote default branch, normally `origin/main`. Resolve conflicts from the intent and history on both sides, and run focused verification when conflict resolution changes code.

Never discard work, use destructive resets, rebase the default branch itself, or push. Preserve uncommitted changes and restore them afterward. If the rebase cannot be completed safely, abort it, restore the original working-tree state, and explain the blocker.
