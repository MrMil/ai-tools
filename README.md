# ai-tools

Reusable instructions for AI coding agents (Claude Code and similar).

## Contents

- **[`global-claude-md/CLAUDE.md`](global-claude-md/CLAUDE.md)** — personal working agreements for all projects. Currently one rule: never commit, push, rebase or rewrite history unless explicitly asked. Copy it to `~/.claude/CLAUDE.md`.

- **[`meta-documentation/docs-infect.md`](meta-documentation/docs-infect.md)** — a one-time install prompt that sets up a self-maintaining documentation system in any repo: a recursive `docs/` tree of hub `README.md` pages mirroring the system, a `docs/CONVENTIONS.md`, and standing rules patched into `AGENTS.md` / `CLAUDE.md` / `README.md` so new work carries its own docs — including *why* each decision was made. To use it, open an agent in the target repo and tell it to follow the file.
