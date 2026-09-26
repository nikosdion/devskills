# CLAUDE.md

This file provides guidance to Claude Code, Codex, and Qwen Code when working with code in this
repository.

## Scope

These instructions apply to the entire repository.

## Deploying changes

Edits here are NOT live until installed. Choose the host you are deploying to:

- **Claude Code** — run `./install-claude.sh`. This rebuilds `devskills.zip` (substituting your `.env`
  values into every `SKILL.md`), replaces `~/.claude-plugins/devskills/`, registers the plugin in the
  local marketplace, and reinstalls it. Then run `/reload-plugins` in Claude Code (or restart it).
- **Codex** — run `./install-codex.sh`. This rebuilds `devskills.zip`, installs a clean copy under
  `~/plugins/devskills/`, registers it in the personal marketplace, and installs it via the Codex CLI.
  Start a new Codex conversation to load it.
- **Qwen Code** — run `./install-qwen.sh`. This rebuilds `devskills.zip`, extracts it into
  `~/.qwen-plugins/devskills/`, and links that directory via `qwen extensions link`. Restart Qwen Code
  to pick up the link.

All three installers call `bash package.sh` internally, so `.env` must exist (copy it from
`env.sample` first) before any of them will succeed.

**Bump the version in every manifest for every content change.** The Claude cache is keyed by
`.claude-plugin/plugin.json`; the Codex install mirrors whatever sits in `.codex-plugin/plugin.json`;
the Qwen Code manifest in `qwen-extension.json` is informational but documents the loaded release. If
any of them does not change, the corresponding host keeps serving the previous version.

Building the plugin ZIP without installing it anywhere (e.g. for Claude Desktop's Cowork custom plugin
upload) is still just `bash package.sh` — see the README for that flow.

## Repository Skills

- `mysql` (`skills/mysql/SKILL.md`): Create/reset a local MySQL database and matching localhost user
  with `utf8mb4` / `utf8mb4_unicode_ci`.
- `installjoomla` (`skills/installjoomla/SKILL.md`): Download and install Joomla 5+ locally, preferring
  stable releases and `.tar.zst` / `.tar.gz` packages.
- `backup` (`skills/backup/SKILL.md`): Take a backup of a Joomla/WordPress site using Akeeba Backup CLI
  commands.
- `restore` (`skills/restore/SKILL.md`): Restore a Joomla/WordPress backup archive using Akeeba
  Kickstart and the Akeeba Backup Restoration Script.
- `unblock` (`skills/unblock/SKILL.md`): Unblock localhost access in Admin Tools for Joomla/WordPress.
- `japitoken` (`skills/japitoken/SKILL.md`): Retrieve a valid Joomla API token from a local development
  Joomla site.
- `jchildtemplate` (`skills/jchildtemplate/SKILL.md`): Create a Joomla 5 Cassiopeia child template with
  optional auto dark/light mode CSS support.

### Joomla API Skills (remote sites)

- `jconfig`, `jextensions`, `joomlaupdate`, `jusers`, and the other `j*` skills (content, menus,
  modules, banners, contacts, fields, tags, redirects, privacy, messages, media, templates, plugins,
  language content/overrides/packages, news feeds, extensions) — manage a remote Joomla site over its
  REST API. Require `japitoken`.

### Joomla CLI Skills (local sites — preferred over API skills)

- `jclisite`, `jcliconfig`, `jclicore`, `jclidb`, `jcliext`, `jcliuser`, `jclischeduler`,
  `jcliadmintools`, `jcliakeeba`, `jcliats`, `jclidatacompliance`, `jclidocimport`, `jclipanopticon` —
  administer a locally hosted Joomla site through its CLI console (`cli/joomla.php`) instead of the
  REST API.

## Skill Selection Rules

- **For local Joomla sites:** prefer `jcli*` CLI skills over `j*` API skills.
- **For remote Joomla sites:** use `j*` API skills (require `japitoken`).
- Combine skills when required by workflow (for example `installjoomla` or `restore` may call `mysql`
  for missing DB credentials).

## Execution Conventions

- Detect Joomla vs WordPress before running CMS-specific commands.
- Ensure it is a locally hosted site resolving to a localhost or internal network domain.
- Verify required extension/plugin presence before running product-specific CLI commands.
- Prefer non-interactive CLI execution where supported.
- Stop and report clearly when prerequisites are missing or the requested action is unsupported.

## Skill authoring conventions

- Keep each `SKILL.md` concise, deterministic, and task-focused.
- Keep YAML frontmatter limited to `name` and `description`.
- The `description` frontmatter field is the trigger — be precise. Too broad and the skill fires
  spuriously; too narrow and it misses.
- When updating a skill, preserve product names and CLI identifiers exactly as required by that
  product.
- `{{VARIABLE}}` placeholders in `SKILL.md` files are substituted from `.env` by `package.sh` at build
  time — see `env.sample` for the full list. Add new variables to both `env.sample` and `package.sh`
  together.
- After adding, removing, or renaming a skill, update the skill catalog above so it keeps matching
  `skills/`.
