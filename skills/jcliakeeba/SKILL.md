---
name: jcliakeeba
description: Manage Akeeba Backup for Joomla via the Joomla CLI on a locally hosted site. Covers taking backups, listing and managing backup records, managing backup profiles and their configuration, managing backup filters, viewing logs, and managing component-wide settings. Preferred over the backup API skill for local sites.
argument-hint: [site_path] [action] [options]
---

# Akeeba Backup CLI

Manage Akeeba Backup for Joomla using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.
- Action-specific options (see per-action details below).

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Verify Akeeba Backup (`com_akeebabackup`) is installed: `php cli/joomla.php list | grep akeeba`

All commands are run from `site_path`.

---

## Backup Operations

### backup-take — Take a backup

Takes a backup using Akeeba Backup's direct CLI feature.

**Additional inputs (all optional):**

| Option | Description |
|--------|-------------|
| `--profile` | Backup profile number (default: 1) |
| `--description` | Short description for the backup record (supports Akeeba naming variables) |
| `--comment` | Longer comment in HTML format |
| `--overrides` | Configuration overrides in `key1=value1,key2=value2` format |

```bash
php cli/joomla.php akeeba:backup:take [--profile=<id>] [--description=<desc>] [--comment=<html>] [--overrides=<k=v,...>]
```

---

### backup-alternate — Take a backup via the front-end backup feature

```bash
php cli/joomla.php akeeba:backup:alternate [--profile=<id>]
```

---

### backup-check — Check for failed backup attempts

Checks for any failed backup attempts and reports them.

```bash
php cli/joomla.php akeeba:backup:check
```

---

### backup-check-upload — Check for failed remote storage uploads

```bash
php cli/joomla.php akeeba:backup:check:upload
```

---

### backup-alternate-check — Check for failed front-end backup attempts

```bash
php cli/joomla.php akeeba:backup:alternate_check
```

---

### backup-alternate-check-upload — Check for failed front-end remote uploads

```bash
php cli/joomla.php akeeba:backup:alternate_check:upload
```

---

## Backup Record Management

### backup-list — List backup records

Lists backup records known to Akeeba Backup.

**Additional inputs (all optional):**

| Option | Default | Description |
|--------|---------|-------------|
| `--from` | `0` | Records to skip before output |
| `--limit` | `50` | Maximum records to display |
| `--format` | `table` | Output format: `table`, `json`, `yaml`, `csv`, `count` |
| `--description` | — | Filter by partial description match |
| `--after` | — | List backups taken after this date |
| `--before` | — | List backups taken before this date |
| `--origin` | — | Filter by origin: `backend`, `frontend`, `json`, `cli` |
| `--profile` | — | Filter by profile ID |
| `--sort-by` | `id` | Sort column: `id`, `description`, `profile_id`, `backupstart` |
| `--sort-order` | `desc` | Sort order: `asc`, `desc` |

```bash
php cli/joomla.php akeeba:backup:list [--from=<n>] [--limit=<n>] [--format=<fmt>] [--description=<text>] [--after=<date>] [--before=<date>] [--origin=<origin>] [--profile=<id>] [--sort-by=<col>] [--sort-order=<order>]
```

---

### backup-info — Show details of a backup record

```bash
php cli/joomla.php akeeba:backup:info <id> [--format=<fmt>]
```

---

### backup-modify — Update a backup record's description or comment

```bash
php cli/joomla.php akeeba:backup:modify <id> [--description=<desc>] [--comment=<html>]
```

---

### backup-delete — Delete a backup record

Deletes the record and its files. Use `--only-files` to delete only the archive files while keeping the database record.

> **Warning:** This is irreversible. Confirm with the user first.

```bash
php cli/joomla.php akeeba:backup:delete <id> [--only-files]
```

---

### backup-download — Download a backup archive part

Downloads a backup archive part. Outputs to STDOUT if `--file` is not specified.

```bash
php cli/joomla.php akeeba:backup:download <id> [<part>] [--file=<path>]
```

---

### backup-fetch — Fetch backup archives from remote storage

Downloads backup archives from remote storage back to the server.

```bash
php cli/joomla.php akeeba:backup:fetch <id>
```

---

### backup-upload — Retry uploading a backup to remote storage

Retries uploading a backup that previously failed to upload.

```bash
php cli/joomla.php akeeba:backup:upload <id>
```

---

## Backup Profile Management

### profile-list — List all backup profiles

```bash
php cli/joomla.php akeeba:profile:list [--format=<fmt>]
```

---

### profile-create — Create a new backup profile

```bash
php cli/joomla.php akeeba:profile:create [--description=<desc>] [--quickicon=<0|1>] [--format=text|json]
```

---

### profile-copy — Copy an existing backup profile

```bash
php cli/joomla.php akeeba:profile:copy <id> [--filters] [--description=<desc>] [--quickicon=<0|1>] [--format=text|json]
```

---

### profile-modify — Modify a backup profile

```bash
php cli/joomla.php akeeba:profile:modify <id> [--description=<desc>] [--quickicon=<0|1>]
```

---

### profile-delete — Delete a backup profile

> **Warning:** This is irreversible. Confirm with the user first.

```bash
php cli/joomla.php akeeba:profile:delete <id>
```

---

### profile-reset — Reset a backup profile to defaults

```bash
php cli/joomla.php akeeba:profile:reset <id> [--filters] [--configuration]
```

---

### profile-export — Export a backup profile as JSON

```bash
php cli/joomla.php akeeba:profile:export <id> [--filters]
```

---

### profile-import — Import a backup profile from JSON

Accepts a JSON file path, a literal JSON string, or reads from STDIN if omitted.

```bash
php cli/joomla.php akeeba:profile:import [<fileOrJSON>] [--format=text|json]
```

---

## Profile Configuration Options

### option-list — List profile configuration options

```bash
php cli/joomla.php akeeba:option:list [--profile=<id>] [--filter=<prefix>] [--sort-by=<col>] [--sort-order=<order>] [--format=<fmt>]
```

---

### option-get — Get a profile configuration option value

```bash
php cli/joomla.php akeeba:option:get [<key>] [--profile=<id>] [--format=text|json|print_r|var_dump|var_export]
```

---

### option-set — Set a profile configuration option value

```bash
php cli/joomla.php akeeba:option:set [<key> [<value>]] [--profile=<id>] [--force]
```

---

## Component-Wide System Configuration

### sysconfig-list — List component-wide options

```bash
php cli/joomla.php akeeba:sysconfig:list [--format=<fmt>]
```

---

### sysconfig-get — Get a component-wide option value

```bash
php cli/joomla.php akeeba:sysconfig:get [<key>] [--format=text|json]
```

---

### sysconfig-set — Set a component-wide option value

```bash
php cli/joomla.php akeeba:sysconfig:set [<key> [<value>]] [--format=text|json]
```

---

## Backup Filters

### filter-list — List backup filters

```bash
php cli/joomla.php akeeba:filter:list [--profile=<id>] [--target=fs|db] [--type=exclude|include|regex] [--root=<root>] [--format=<fmt>]
```

---

### filter-exclude — Add an exclusion filter

**Additional inputs:**

| Input | Description |
|-------|-------------|
| `<filter>` | Full path, table name, or regex depending on filter type |
| `--filterType` | Filter type: `files`, `directories`, `skipdirs`, `skipfiles`, `regexfiles`, `regexdirectories`, `regexskipdirs`, `regexskipfiles`, `tables`, `tabledata`, `regextables`, `regextabledata` |
| `--root` | Filter root (default: `[SITEROOT]` for FS, `[SITEDB]` for DB) |
| `--profile` | Profile ID (default: 1) |

```bash
php cli/joomla.php akeeba:filter:exclude <filter> [--filterType=<type>] [--root=<root>] [--profile=<id>]
```

---

### filter-delete — Delete a filter value

```bash
php cli/joomla.php akeeba:filter:delete <filter> [--filterType=<type>] [--root=<root>] [--profile=<id>]
```

---

### filter-include-directory — Add an off-site directory to backup

```bash
php cli/joomla.php akeeba:filter:include-directory [<directory>] [--profile=<id>] [--virtual=<subfolder>]
```

---

### filter-include-database — Add an additional database to backup

```bash
php cli/joomla.php akeeba:filter:include-database \
  --dbusername=<user> --dbpassword=<pass> --dbname=<db> \
  [--dbdriver=mysqli|pdomysql] [--dbport=<port>] [--dbprefix=<prefix>] \
  [--profile=<id>] [--check]
```

---

## Backup Logs

### log-list — List backup log files for a profile

```bash
php cli/joomla.php akeeba:log:list [<profile_id>] [--format=<fmt>]
```

---

### log-get — Retrieve a backup log file

```bash
php cli/joomla.php akeeba:log:get <profile_id> <log_tag>
```

---

## Migration

### migrate — Migrate settings from Akeeba Backup 8

> **Warning:** This overwrites all current settings without confirmation. Use only when migrating from Akeeba Backup 8.

```bash
php cli/joomla.php akeeba:migrate
```

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For list commands: display results in a readable table
