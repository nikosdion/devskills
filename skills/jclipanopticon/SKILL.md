---
name: jclipanopticon
description: Retrieve or reset the Akeeba Panopticon API connection token for a Joomla Super User via the Joomla CLI on a locally hosted site.
argument-hint: [site_path] [username] [--reset]
---

# Joomla Panopticon Token CLI

Retrieve or reset the Akeeba Panopticon API connection token for a Super User using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `username`: Username of a Super User account.
- `--reset` (optional): Reset the token, generating a new one.

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Panopticon integration must be installed on the site.

All commands are run from `site_path`.

---

## Command

### Get the current token

```bash
php cli/joomla.php panopticon:token:get --username=<username>
```

### Reset and get a new token

```bash
php cli/joomla.php panopticon:token:get --username=<username> --reset
```

---

## Output

Report:
- The username queried
- Whether the token was reset or retrieved
- The API token value
- Success/failure and key CLI output

> **Note:** The token is used to authenticate Panopticon's connection to this Joomla site. Keep it secure.
