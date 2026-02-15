---
name: backup
description: Take a site backup with Akeeba Backup on Joomla or WordPress. Use when a user asks to run a backup, optionally with a specific backup profile by ID or name, and determine CMS type plus Akeeba Backup installation before executing CLI backup commands.
---

# Akeeba Backup Site Backup

Take a backup of a Joomla or WordPress site using Akeeba Backup.

## Inputs

- `site_path`: Path to the site root.
- `profile` (optional): Backup profile ID (number) or profile name (string).

## Detect CMS

From `site_path`, identify the site type:

- Joomla indicators: `configuration.php`, `cli/joomla.php`, `administrator/`
- WordPress indicators: `wp-config.php`, `wp-content/`, `wp-includes/`

If neither set of indicators matches, stop and report unsupported site type.

## Verify Akeeba Backup Is Installed

For Joomla, confirm `com_akeebabackup` exists before backup:

- Preferred check: `php cli/joomla.php list | grep -i akeeba`
- Fallback check: confirm component files under `administrator/components/com_akeebabackup`

For WordPress, confirm `akeebabackupwp` plugin exists before backup:

- Preferred check: `wp plugin is-installed akeebabackupwp`
- Optional check: `wp plugin status akeebabackupwp`

If missing, stop and report that Akeeba Backup is not installed for this CMS.

## Resolve Backup Profile

If `profile` is not provided, run backup with default profile (no `--profile` argument).

If `profile` is numeric, use it directly:

- `--profile=123`

If `profile` is a name, list profiles and resolve name to ID:

- Joomla: `php cli/joomla.php akeeba:profile:list`
- WordPress: `wp akeeba profile list`

Match by exact profile name. If no exact match, stop and report available profiles.

## Run Backup

Run from `site_path`.

For Joomla:

```bash
php cli/joomla.php akeeba:backup:take [--profile=ID]
```

For WordPress:

```bash
wp akeeba backup take [--profile=ID]
```

Use the resolved `--profile=ID` only when applicable.

## Output

Report:

- Detected CMS type
- Akeeba Backup installation check result
- Profile used (default or `ID`)
- Command executed
- Success/failure and key CLI output
