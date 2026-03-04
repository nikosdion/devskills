---
name: jclisite
description: Manage a local Joomla site via CLI — take it online/offline, clean cache, rebuild the Smart Search index, check and fix database structure, run session garbage collection, check for extension updates, and remove old post-update files. Preferred over the Joomla API for locally hosted sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Site Management CLI

Manage a local Joomla site using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### site-up — Put the site into online mode

```bash
php cli/joomla.php site:up
```

---

### site-down — Put the site into offline mode

```bash
php cli/joomla.php site:down
```

---

### site-create-public-folder — Create a public folder

**Additional inputs:**
- `public_folder` (optional): Absolute path for the public folder. Omit to use the Joomla default.

```bash
php cli/joomla.php site:create-public-folder [--public-folder=<path>]
```

---

### cache-clean — Clean site cache

Clears all cache entries. To clear only expired entries, pass `expired` as an argument.

```bash
php cli/joomla.php cache:clean [expired]
```

---

### finder-index — Purge and rebuild the Smart Search index

Purges and rebuilds the Finder (Smart Search) index. Search filters are preserved.

**Additional inputs (all optional):**

| Option | Default | Description |
|--------|---------|-------------|
| `purge` | — | Pass `1` to explicitly purge before rebuilding |
| `--minproctime` | `1` | Minimum processing time in seconds before pausing |
| `--pause` | `division` | Pause type or pause time in seconds |
| `--divisor` | `5` | Divisor for the division pause calculation |

```bash
php cli/joomla.php finder:index [purge] [--minproctime=<s>] [--pause=<type>] [--divisor=<n>]
```

---

### maintenance-db — Check (and optionally fix) database structure

Checks database structure for integrity issues. Pass `--fix` to apply corrections.

```bash
php cli/joomla.php maintenance:database [--fix]
```

---

### session-gc — Run session garbage collection

Removes expired session data. Defaults to the frontend (`site`) application.

**Additional inputs (optional):**
- `--application`: Application context — `site` (default) or `administrator`.

```bash
php cli/joomla.php session:gc [--application=<app>]
```

---

### session-metadata-gc — Run session metadata garbage collection

Removes expired Joomla session metadata records.

```bash
php cli/joomla.php session:metadata:gc
```

---

### update-extensions-check — Check for pending extension updates

Queries update servers for available extension updates.

```bash
php cli/joomla.php update:extensions:check
```

---

### update-remove-old-files — Remove old post-update system files

Removes files that should have been deleted during a Joomla update but were not. Use `--dry-run` to preview without deleting.

```bash
php cli/joomla.php update:joomla:remove-old-files [--dry-run]
```

---

## Output

Report:
- The action performed
- Command executed
- Success/failure and key CLI output
- Any warnings or errors from the CLI
