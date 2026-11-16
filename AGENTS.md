# AGENTS.md

This file provides guidance to Claude Code, Codex, Qwen Code, and Kimi Code when working with code in this
repository.

## Scope

These instructions apply to the entire repository: a plugin of agent skills (`skills/*/SKILL.md`) packaged by `package.sh` for Claude Code, Codex, Qwen Code and Kimi Code.

## Deploying changes

Edits here are NOT live until installed: run `./install-claude.sh`, `./install-codex.sh`, `./install-qwen.sh` or `./install-kimi.sh` for the host you are deploying to. `.env` must exist (copy it from `env.sample`) before any installer succeeds. `bash package.sh` alone builds the plugin ZIP without installing it.


**Bump the version in every manifest for every content change.** The Claude cache is keyed by
`.claude-plugin/plugin.json`; the Codex install mirrors whatever sits in `.codex-plugin/plugin.json`;
the Qwen Code manifest in `qwen-extension.json` is informational but documents the loaded release; the
Kimi Code managed copy is built from whatever sits in `kimi.plugin.json` at stage time. If any of them
does not change, the corresponding host keeps serving the previous version.

## Always-on rules

- `{{VARIABLE}}` placeholders in `SKILL.md` files are substituted from `.env` by `package.sh`; add new variables to both `env.sample` and `package.sh` together.
- Keep YAML frontmatter in `SKILL.md` limited to `name` and `description`.
- After adding, removing, or renaming a skill, update the skill catalog in `.claude/memory/skill-catalog-and-selection.md` so it keeps matching `skills/`.
- Prefer `jcli*` CLI skills for local Joomla sites and `j*` API skills (which need `japitoken`) for remote ones.

## Git: commit and tag outside the sandbox

Commits and tags are always signed, with a key held in 1Password. The 1Password signing agent is reached
over a local socket that agent sandboxes do not expose, so a sandboxed `git commit` or `git tag` **always**
fails (e.g. `error: 1Password: Could not connect to socket. Is the agent running?`).

Run every `git commit` and `git tag` **outside the sandbox from the first attempt** — in Claude Code with
`dangerouslyDisableSandbox: true`, in other harnesses with their equivalent unsandboxed / escalated
execution. Do not try the sandboxed form first, do not diagnose the failure, and never work around it
with `--no-gpg-sign`, `-c commit.gpgsign=false` or unsigned tags.

## Project memory

Project memory lives in `.claude/memory/`, committed with the code, so that it is shared across machines
and across agentic harnesses (Claude Code, Codex, Qwen Code, Kimi Code, Junie, …). Read the matching file before starting that kind of work.

| File | Read it when… |
|------|---------------|
| [`deploying-changes.md`](.claude/memory/deploying-changes.md) | Before you install or reinstall the plugin on a host, or bump plugin manifest versions |
| [`skill-catalog-and-selection.md`](.claude/memory/skill-catalog-and-selection.md) | Before you add, remove or rename a skill, or decide which skill (CLI vs API) a workflow should use |
| [`skill-authoring.md`](.claude/memory/skill-authoring.md) | Before you write or edit a `SKILL.md` (frontmatter, description, `{{VARIABLE}}` placeholders) |
| [`bash-scripting.md`](.claude/memory/bash-scripting.md) | Before you write or edit `package.sh`, an `install-*.sh` script or any shell snippet with BSD/GNU or other environment-specific variants |

### Recording new memories

This is the **default and only** place for project memory. Do not write memories for this project to a
harness's private memory store (such as Claude Code's auto-memory under `~/.claude/projects/`); write
them here instead:

- Add to the existing topic file when one fits; otherwise create a new kebab-case `.md` file named after
  the topic, and add a row for it to the table above with a concrete trigger.
- Plain Markdown, no frontmatter. State the rule, then **Why:** (the reason or incident behind it) and
  **How to apply:**. Link related files with relative Markdown links.
- Don't record what the code, Git history or an existing `AGENTS.md` already says — update that
  `AGENTS.md` instead when the rule belongs there. Remove or correct entries that turn out wrong.
- These files are committed: no secrets, credentials, customer data or personal details.
