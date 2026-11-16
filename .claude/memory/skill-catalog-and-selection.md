# Skill catalog, selection rules and execution conventions

Moved from `AGENTS.md`. Keep the catalog matching `skills/`.

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
