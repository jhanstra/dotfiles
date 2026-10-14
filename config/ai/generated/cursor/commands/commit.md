---
name: commit
description: Create focused commits for in-progress work
---

# Commit in-progress work

Review all in-progress changes and create small, self-contained commits grouped by purpose. Exclude secrets and unrelated changes, and do not push.

## Commit-message style

- Use a concise, direct, imperative subject describing the outcome, usually in lowercase.
- Prefer plain subjects such as `add ...`, `fix ...`, `remove ...`, `migrate ...`, `simplify ...`, or `update ...`; do not use a Conventional Commits prefix unless the repository is already using one for that change.
- Do not add a period or other decorative punctuation. Keep the subject specific and generally under 72 characters.
- For substantial changes, add a short body after a blank line. Use bullets when useful to capture the main changes, rationale, migration impact, tests, or before/after measurements.
- Preserve meaningful product or technology capitalization in subjects and bodies (`HQ`, `Axiom`, `Fluent`, `Codash`, `AI`, etc.).
- Avoid vague subjects like `changes` or `work` unless the commit is intentionally a temporary checkpoint.

## Examples from this repository

These are real subjects from commits to use as examples of good commits:

- `add PR info graphql query`
- `migrate hq + cursor actions to canonical api architecture`
- `extract types, enforce single-line ifs`
- `more fixes, create full-screen modal`
- `fallow: clear all 55 unused-file findings + test top refactor target`
- `Add reusable voice recording + transcription, wired into HQ`
- `Refactor Fluent to use Codash atomics; add percent + fillTemplate`
