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

### Joomla API Skills (remote sites)

- `jconfig` (`jconfig/SKILL.md`): Read/update Joomla Global Configuration and per-component configuration via the API.
- `jextensions` (`jextensions/SKILL.md`): List installed Joomla extensions via the API.
- `joomlaupdate` (`joomlaupdate/SKILL.md`): Manage Joomla core updates via the API.
- `jusers` (`jusers/SKILL.md`): Manage Joomla users via the API.
- (and other `j*` skills for content, menus, modules, banners, etc.)

### Joomla CLI Skills (local sites — preferred over API skills)

- `jclisite` (`jclisite/SKILL.md`): Site online/offline, cache clean, Smart Search index rebuild, database maintenance, session GC, extension update checks, old-file cleanup.
- `jcliconfig` (`jcliconfig/SKILL.md`): Read and set Joomla Global Configuration options.
- `jclicore` (`jclicore/SKILL.md`): Core update check, perform update, set update channel, register/unregister auto-update service.
- `jclidb` (`jclidb/SKILL.md`): Export and import the Joomla database (SQL files or ZIP).
- `jcliext` (`jcliext/SKILL.md`): List, install, remove, discover, and discover-install Joomla extensions.
- `jcliuser` (`jcliuser/SKILL.md`): List, add, delete users; reset passwords; manage group memberships.
- `jclischeduler` (`jclischeduler/SKILL.md`): List, run, and change state of Joomla scheduled tasks.
- `jcliadmintools` (`jcliadmintools/SKILL.md`): Full Admin Tools for Joomla CLI — WAF, IP lists, server config files, scan, offline mode, export/import.
- `jcliakeeba` (`jcliakeeba/SKILL.md`): Full Akeeba Backup CLI — take backups, manage records/profiles/filters/options/logs.
- `jcliats` (`jcliats/SKILL.md`): Akeeba Ticket System configuration and CRON tasks.
- `jclidatacompliance` (`jclidatacompliance/SKILL.md`): GDPR-compliant user account deletion and lifecycle notifications via Akeeba DataCompliance.
- `jclidocimport` (`jclidocimport/SKILL.md`): Regenerate Akeeba DocImport category content from DocBook XML sources.
- `jclipanopticon` (`jclipanopticon/SKILL.md`): Retrieve or reset the Akeeba Panopticon API connection token.

## Skill Selection Rules

- Use `mysql` when asked to create, reset, or recreate a local MySQL DB/user.
- Use `joomla` when asked to download/install Joomla locally.
- Use `backup` when asked to take/create/run a backup of a Joomla or WordPress site (also see `jcliakeeba` for Joomla-only local sites).
- Use `restore` when asked to restore/extract/recover a site from a backup archive.
- Use `unblock` when asked to “unblock localhost”, “unblock me”, or “unblock my access” (also see `jcliadmintools` unblock action for Joomla local sites).
- Use `japitoken` when asked to “get a Joomla API token”, “retrieve the API token”, or “show my Joomla API token”.
- **For local Joomla sites:** prefer `jcli*` CLI skills over `j*` API skills.
- **For remote Joomla sites:** use `j*` API skills (require `japitoken`).
- Use `jclisite` for site maintenance tasks: online/offline, cache, finder index, DB maintenance, sessions, update checks.
- Use `jcliconfig` to read or change Joomla configuration settings on a local site.
- Use `jclicore` to check for or perform Joomla core updates on a local site.
- Use `jclidb` to export or import the Joomla database on a local site.
- Use `jcliext` to install, remove, or manage extensions on a local site.
- Use `jcliuser` to manage users on a local site.
- Use `jclischeduler` to manage or run scheduled tasks on a local site.
- Use `jcliadmintools` for any Admin Tools for Joomla management on a local site.
- Use `jcliakeeba` for Akeeba Backup management on a local Joomla site.
- Use `jcliats` for Akeeba Ticket System management on a local site.
- Use `jclidatacompliance` for GDPR account deletion/notification on a local site.
- Use `jclidocimport` to regenerate DocImport content on a local site.
- Use `jclipanopticon` to retrieve or reset the Panopticon API token on a local site.
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
