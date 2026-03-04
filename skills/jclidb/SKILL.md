---
name: jclidb
description: Export or import the Joomla database via the Joomla CLI on a locally hosted site. Supports exporting to SQL files or a ZIP archive, and importing from SQL files or a ZIP archive, with optional per-table targeting.
argument-hint: [site_path] [action] [options]
---

# Joomla Database Export/Import CLI

Export and import the Joomla database using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `export` or `import`.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### export — Export the database

Exports the database to SQL files. The output can be compressed into a ZIP archive.

**Additional inputs (all optional):**

| Option | Default | Description |
|--------|---------|-------------|
| `--folder` | `.` (current directory) | Path to write the export files to |
| `--table` | all tables | Name of a specific database table to export |
| `--zip` | — | Save the export as a ZIP archive |

```bash
php cli/joomla.php database:export [--folder=<path>] [--table=<table>] [--zip]
```

**Examples:**
```bash
# Export all tables to current directory
php cli/joomla.php database:export

# Export to a specific folder as ZIP
php cli/joomla.php database:export --folder=/tmp/db-export --zip

# Export a single table
php cli/joomla.php database:export --table=jos_users --folder=/tmp/db-export
```

---

### import — Import the database

Imports database SQL files from a folder or a ZIP archive.

**Additional inputs (all optional):**

| Option | Default | Description |
|--------|---------|-------------|
| `--folder` | `.` (current directory) | Path to the folder containing SQL files to import |
| `--zip` | — | Name of a ZIP file to import |
| `--table` | all tables | Name of a specific database table to import |

```bash
php cli/joomla.php database:import [--folder=<path>] [--zip=<file>] [--table=<table>]
```

**Examples:**
```bash
# Import from a ZIP archive
php cli/joomla.php database:import --zip=backup.zip

# Import all SQL files from a folder
php cli/joomla.php database:import --folder=/tmp/db-export

# Import a single table from a folder
php cli/joomla.php database:import --folder=/tmp/db-export --table=jos_users
```

> **Warning:** Importing will overwrite existing data. Confirm with the user before proceeding.

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- Location of exported files (for export) or tables imported (for import)
