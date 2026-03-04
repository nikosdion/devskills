---
name: jcliconfig
description: Read or set Joomla Global Configuration options via the Joomla CLI on a locally hosted site. Preferred over the jconfig API skill for local sites. Supports reading individual options or grouped options (db, mail, session) and setting one or more options.
argument-hint: [site_path] [action] [options]
---

# Joomla Configuration CLI

Read and update Joomla Global Configuration settings via the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `get` or `set`.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### get — Display a configuration option's current value

Displays the current value of a configuration option. Omit the option name to list all configuration values. Use `--group` to list a logical group of related options.

**Additional inputs (all optional):**

| Input | Description |
|-------|-------------|
| `option` | Name of the configuration option to read |
| `--group` | Option group to list: `db`, `mail`, `session` |

```bash
php cli/joomla.php config:get [<option>] [--group=<group>]
```

**Examples:**
```bash
# Get a single option
php cli/joomla.php config:get sitename

# Get all options in the db group
php cli/joomla.php config:get --group db

# List all configuration options
php cli/joomla.php config:get
```

---

### set — Set one or more configuration options

Sets one or more configuration options. Each option must be provided in `option=value` format.

**Additional inputs:**
- One or more `option=value` pairs (required).

```bash
php cli/joomla.php config:set <option>=<value> [<option2>=<value2> ...]
```

**Examples:**
```bash
# Set site name
php cli/joomla.php config:set sitename="My Site"

# Enable debug mode
php cli/joomla.php config:set debug=1

# Set multiple options at once
php cli/joomla.php config:set offline=1 offline_message="Site under maintenance"
```

> **Warning:** Changing critical settings (e.g. `offline`, `debug`, SMTP credentials, database connection) takes effect immediately. Confirm with the user before applying such changes if they were not explicitly requested.

---

## Common Configuration Options

| Option | Type | Description |
|--------|------|-------------|
| `sitename` | string | Site name displayed in the frontend |
| `offline` | int | `0`=online, `1`=offline |
| `offline_message` | string | Message shown when site is offline |
| `debug` | int | `0`=off, `1`=on — Debug system |
| `debug_lang` | int | `0`=off, `1`=on — Debug language |
| `error_reporting` | string | Error reporting level (`default`, `maximum`, etc.) |
| `sef` | int | `0`=off, `1`=on — Search Engine Friendly URLs |
| `sef_rewrite` | int | `0`=off, `1`=on — Apache mod_rewrite |
| `cache` | int | `0`=off, `1`=on — System cache |
| `cachetime` | int | Cache lifetime in minutes |
| `session_handler` | string | Session handler (`database`, `filesystem`, etc.) |
| `lifetime` | int | Session lifetime in minutes |
| `mailonline` | int | `0`=off, `1`=on — Send mail |
| `mailer` | string | Mailer type (`mail`, `smtp`, `sendmail`) |
| `mailfrom` | string | From email address |
| `smtphost` | string | SMTP host |
| `smtpport` | int | SMTP port |

Use `config:get` without arguments to see all available options.

---

## Output

Report:
- The action performed
- Command executed
- Current or updated option value(s)
- Success/failure and key CLI output
