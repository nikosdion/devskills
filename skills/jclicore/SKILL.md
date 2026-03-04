---
name: jclicore
description: Manage Joomla core updates via the Joomla CLI on a locally hosted site — check for updates, set the update channel, perform the update, and register/unregister from the automated update service. Preferred over the joomlaupdate API skill for local sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Core Update CLI

Manage Joomla core updates using the Joomla CLI application on a local site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### update-check — Check for available Joomla core updates

```bash
php cli/joomla.php core:update:check
```

**Output:** Reports whether an update is available and the target version if so.

---

### update — Perform the Joomla core update

> **Warning:** This updates the Joomla core installation. Recommend taking a backup first (see the `backup` skill).

```bash
php cli/joomla.php core:update
```

**Process:**
1. Run `update-check` first to confirm an update is available and inform the user of the target version.
2. Ask the user for confirmation before proceeding.
3. Run `core:update` and report success or failure.

---

### update-channel — View or set the update channel

Returns the currently configured update channel when called without arguments. Sets it when a channel name is provided.

**Additional inputs (optional):**

| Input | Description |
|-------|-------------|
| `channel` | Channel name: `default`, `next`, or `custom` |
| `--url` | Update source URL (only for `custom` channel) |

```bash
# View current channel
php cli/joomla.php core:update:channel

# Set to a standard channel
php cli/joomla.php core:update:channel <channel>

# Set to a custom channel
php cli/joomla.php core:update:channel custom --url=<url>
```

---

### autoupdate-register — Register for the automated core update service

Registers the site with Joomla's automated core update service.

```bash
php cli/joomla.php core:autoupdate:register
```

---

### autoupdate-unregister — Unregister from the automated core update service

Unregisters the site from Joomla's automated core update service.

```bash
php cli/joomla.php core:autoupdate:unregister
```

---

## Output

Report:
- The action performed
- Command executed
- Success/failure and key CLI output (e.g. current version, available version, new update channel)
- Any warnings or errors from the CLI
