---
name: restore
description: Restore a Joomla or WordPress site backup created by Akeeba Backup (Joomla/WordPress) or Akeeba Solo using Akeeba Kickstart and the Akeeba Backup Restoration Script, including multipart archive handling, restoration configuration, and post-restore cleanup.
argument-hint: [backup_file]
---

# Akeeba Backup Restoration

Restore a Joomla or WordPress site from an Akeeba backup archive using Akeeba Kickstart and the Akeeba Backup Restoration Script.

## Inputs

- `site_dir`: Target site root directory where the backup will be restored.
- `backup_file`: Main archive filename (`.zip`, `.jpa`, or `.jps`) located in `site_dir`.
- Database connection info (optional): `db_name`, `db_host`, `db_user`, `db_pass`.

## Supported Archives

- Single-part archives: `.zip`, `.jpa`, `.jps`
- Multipart archives:
- `.zip` main file plus `.z01`, `.z02`, ...
- `.jpa` / `.jps` main file plus `.j01`, `.j02`, ...

Treat all matching multipart files with the same basename as part of one backup set.

## Prepare Kickstart

1. Look for Kickstart ZIP in `/release` named `kickstart-core-*.zip`.
2. If missing and `~/Projects/akeeba/ks9` exists:
- Change directory there.
- Run `phing git`.
3. Check `/release` again for `kickstart-core-*.zip`.
4. If still missing, download Kickstart Core from `https://www.akeeba.com/download.html`.

## Extract With Kickstart

1. Extract the Kickstart ZIP.
2. Keep only `kickstart.php`.
3. Rename `kickstart.php` to `extractor.php`.
4. Run extraction from `site_dir`:

```bash
php extractor.php BACKUPFILE
```

Use the provided main archive filename as `BACKUPFILE`.

After successful extraction:

- Delete `extractor.php`.
- Delete the main archive file.
- Delete all multipart sidecar files for the same basename (`.z01`, `.z02`, ... or `.j01`, `.j02`, ...).

## Configure Restoration Script

1. Change directory to `installation` under the restored site root.
2. Run:

```bash
php ./cli.php config:make
```

This creates `config.yml.php`.

`config.yml.php` starts with the line:

```text
#<?php die(); ?>
```

Never remove or alter this line.

## Edit `config.yml.php`

Update these keys.

Under `database.site`:

- `dbname`: Database name
- `dbhost`: Database host
- `dbuser`: Database username
- `dbpass`: Database password

If DB connection info was not provided, create a new local MySQL database using the repository `mysql` skill with `basename(site_dir)` and use:

- `dbname = basename(site_dir)`
- `dbuser = basename(site_dir)`
- `dbpass = basename(site_dir)`
- `dbhost = localhost`

Under `setup`:

- `default_tmp`: Absolute path to `<site_dir>/tmp`
- `default_log`: Absolute path to `<site_dir>/administrator/logs`
- `site_root_dir`: Absolute path to `<site_dir>`

## Execute Restoration

Run:

```bash
php ./cli.php execute
```

If successful, delete `<site_dir>/installation`.

## Output

Report:

- Archive type and whether multipart files were detected
- Kickstart source used (`/release`, `ks9 build`, or downloaded)
- Database settings source (provided or generated via `mysql` skill)
- Restoration command result
- Cleanup actions performed
