---
name: jcliext
description: Manage Joomla extensions via the Joomla CLI on a locally hosted site — list installed extensions, install from path or URL, remove by ID, discover unregistered extensions, and install discovered extensions. Preferred over the jextensions API skill for local sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Extension Management CLI

List, install, remove, and discover Joomla extensions using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### list — List installed extensions

Lists all installed extensions. Filter by type with `--type`.

**Additional inputs (optional):**

| Option | Description |
|--------|-------------|
| `--type` | Extension type: `component`, `module`, `plugin`, `template`, `library`, `package` |

```bash
php cli/joomla.php extension:list [--type=<type>]
```

---

### install — Install an extension from a path or URL

Installs an extension from a local file path or a remote URL. Exactly one of `--path` or `--url` must be provided.

**Additional inputs:**

| Option | Description |
|--------|-------------|
| `--path` | Local filesystem path to the extension install package |
| `--url` | URL from which to download and install the extension package |

```bash
php cli/joomla.php extension:install --path=<path>
php cli/joomla.php extension:install --url=<url>
```

---

### remove — Remove an extension by ID

Uninstalls an extension by its numeric ID. Run `list` first to find the extension ID.

> **Warning:** Removing an extension is irreversible. Confirm with the user before proceeding.

**Additional inputs:**
- `extensionId` (required): Numeric ID of the extension to remove.

```bash
php cli/joomla.php extension:remove <extensionId>
```

---

### discover — Scan for unregistered extensions

Scans the Joomla filesystem for extensions that are present but not registered in the database.

```bash
php cli/joomla.php extension:discover
```

---

### discover-list — List discovered (unregistered) extensions

Lists extensions found by the last discovery scan that are not yet installed.

```bash
php cli/joomla.php extension:discover:list
```

---

### discover-install — Install discovered extensions

Installs one or all discovered (unregistered) extensions. If `--eid` is omitted, all discovered extensions are installed.

**Additional inputs (optional):**

| Option | Description |
|--------|-------------|
| `--eid` | Numeric ID of a specific discovered extension to install |

```bash
php cli/joomla.php extension:discover:install [--eid=<id>]
```

**Typical workflow for discover-install:**
1. Run `discover` to scan for unregistered extensions.
2. Run `discover-list` to see what was found.
3. Run `discover-install` (with or without `--eid`) to register/install them.

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For `list`: display extension ID, name, type, enabled status, and version
