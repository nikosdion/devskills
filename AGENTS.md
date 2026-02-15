# AGENTS.md

## Scope

These instructions apply to the entire repository.

## Repository Skills

- `mysql` (`mysql/SKILL.md`): Create/reset a local MySQL database and matching localhost user with `utf8mb4` / `utf8mb4_unicode_ci`.
- `joomla` (`joomla/SKILL.md`): Download and install Joomla 5+ locally, preferring stable releases and `.tar.zst` / `.tar.gz` packages.
- `backup` (`backup/SKILL.md`): Take a backup of a Joomla/WordPress site using Akeeba Backup CLI commands.
- `restore` (`restore/SKILL.md`): Restore a Joomla/WordPress backup archive using Akeeba Kickstart and the Akeeba Backup Restoration Script.
- `unblock` (`unblock/SKILL.md`): Unblock localhost access in Admin Tools for Joomla/WordPress.
- `japitoken` (`japitoken/SKILL.md`): Retrieve a valid Joomla API token from a local development Joomla site.

## Skill Selection Rules

- Use `mysql` when asked to create, reset, or recreate a local MySQL DB/user.
- Use `joomla` when asked to download/install Joomla locally.
- Use `backup` when asked to take/create/run a backup.
- Use `restore` when asked to restore/extract/recover a site from a backup archive.
- Use `unblock` when asked to “unblock localhost”, “unblock me”, or “unblock my access”.
- Use `japitoken` when asked to "get a Joomla API token", "retrieve the API token", or "show my Joomla API token".
- Combine skills when required by workflow (for example `joomla` or `restore` may call `mysql` for missing DB credentials).

## Execution Conventions

- Detect Joomla vs WordPress before running CMS-specific commands.
- Ensure it is a locally hosted site resolving to a localhost or internal network domain.
- Verify required extension/plugin presence before running product-specific CLI commands.
- Prefer non-interactive CLI execution where supported.
- Stop and report clearly when prerequisites are missing or the requested action is unsupported.

## Editing Conventions

- Keep each `SKILL.md` concise, deterministic, and task-focused.
- Keep YAML frontmatter limited to `name` and `description`.
- When updating a skill, preserve product names and CLI identifiers exactly as required by that product.
