# AI Configuration

Coprime is the source of truth for portable AI guidance. This repository stores the generated snapshot needed on machines that do not have access to Coprime.

Do not edit `generated/` directly. From the Coprime repository, run:

```sh
bun run ai-export
bash "$DOTFILES/mac.sh" --ai-only
```

Tag portable sections in Coprime's `AGENTS.md` and skills with `ai:universal` markers.
Cursor commands are authored directly in Coprime's `.agents/commands/` directory and exported automatically.

## Installed Targets

`mac.sh` installs the generated guidance for:

- Cursor: copies rule entrypoints and commands from `generated/cursor` → `~/.cursor/plugins/local/jth`; skills come from the shared user skill directories
- Shared on-demand guidance: `generated/shared` → `~/.agents/guidance`
- Claude Code instructions: `generated/shared/AGENTS.md` → `~/.claude/CLAUDE.md`
- Codex instructions: `generated/shared/AGENTS.md` → `~/.codex/AGENTS.md`
- OpenCode instructions: `generated/shared/AGENTS.md` → `~/.config/opencode/AGENTS.md`
- Claude Code skills: `generated/skills/*` → `~/.claude/skills/*`
- Codex skills: `generated/skills/*` → `~/.agents/skills/*`

Global instruction entrypoints load `~/.agents/guidance/universal.md` only outside repositories already providing `ai:universal` sections. Skills use `portable-*` names to avoid shadowing full project skills; their entrypoints load portable content only outside Coprime. Cursor receives no extra skill copies in its plugin.

Coprime owns each instruction once in `AGENTS.md` or `.agents/skills`; its `.claude/skills` compatibility symlink exposes the same skills to Claude. Codex and Cursor discover `.agents/skills` directly. Generated snapshots keep this dotfiles repository portable to machines without Coprime. Never author changes in generated output.

Run `mac.sh --ai-only` after each export. It updates only AI configuration, removes obsolete links owned by this export, and preserves unrelated skills. Cursor rejects plugin content reached through external symlinks, so its thin rule entrypoint and commands are installed as generated copies.

Restart the relevant agent after the first install. For Cursor, run **Developer: Reload Window** or restart the application.

Generated guidance must remain universal: no credentials, employer-owned material, repository-specific paths, or Coprime-only tools and packages.
