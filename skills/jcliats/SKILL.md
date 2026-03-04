---
name: jcliats
description: Manage the Akeeba Ticket System (ATS) via the Joomla CLI on a locally hosted site — view or change component configuration options, and run CRON tasks.
argument-hint: [site_path] [action] [options]
---

# Akeeba Ticket System CLI

Manage Akeeba Ticket System (ATS) configuration and CRON tasks using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `config` or `cron`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Akeeba Ticket System (`com_ats`) must be installed on the site.

All commands are run from `site_path`.

---

## Actions

### config — View or change ATS configuration options

List all options and their values, retrieve a specific option value, set a new value, or unset an option.

**Additional inputs (all optional):**

| Option | Description |
|--------|-------------|
| `-k` / `--key` | Option name (as defined in `administrator/components/com_ats/config.xml`). Omit to list all options. |
| `-a` / `--value` | New value to set. Omit to display the current value. |
| `-u` / `--unset` | Remove (unset) the option value. |
| `-m` / `--machine` | Output in machine-readable JSON format. |

```bash
# List all options
php cli/joomla.php ats:config

# Get a specific option
php cli/joomla.php ats:config --key=<option>

# Set an option value
php cli/joomla.php ats:config --key=<option> --value=<value>

# Unset an option
php cli/joomla.php ats:config --key=<option> --unset

# Get JSON output
php cli/joomla.php ats:config --machine
```

---

### cron — Run an ATS CRON task

Executes an Akeeba Ticket System CRON task.

**Additional inputs:**

| Input | Description |
|-------|-------------|
| `task` | The name of the CRON task to execute |
| `-d` / `--debug` | Force-enable Joomla debug mode during the run |

```bash
php cli/joomla.php ats:cron [<task>] [--debug]
```

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For `config` without arguments: list all options and values
