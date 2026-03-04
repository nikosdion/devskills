---
name: jcliuser
description: Manage Joomla users via the Joomla CLI on a locally hosted site — list users, add a new user, delete a user, reset a password, and manage user group memberships. Preferred over the jusers API skill for local sites.
argument-hint: [site_path] [action] [options]
---

# Joomla User Management CLI

Manage Joomla users using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### list — List all users

```bash
php cli/joomla.php user:list
```

**Output:** Displays all registered users.

---

### add — Add a new user

Creates a new Joomla user account. The command may prompt interactively if options are omitted; use `--no-interaction` to prevent this and provide all required options upfront.

**Additional inputs (all optional as flags, but required for non-interactive use):**

| Option | Description |
|--------|-------------|
| `--username` | Username |
| `--name` | Full display name |
| `--password` | Password |
| `--email` | Email address |
| `--usergroup` | Comma-separated list of user groups (e.g. `Registered,Author`) |

```bash
php cli/joomla.php user:add \
  --username=<username> \
  --name="<Full Name>" \
  --password=<password> \
  --email=<email> \
  --usergroup=<group1,group2>
```

---

### delete — Delete a user

Permanently deletes a user account. Confirm with the user before proceeding.

**Additional inputs (optional as flag, prompted if omitted):**

| Option | Description |
|--------|-------------|
| `--username` | Username of the account to delete |

```bash
php cli/joomla.php user:delete --username=<username>
```

> **Warning:** This permanently deletes the user account. Confirm with the user first.

---

### reset-password — Change a user's password

Resets the password for an existing user account.

**Additional inputs (optional as flags, prompted if omitted):**

| Option | Description |
|--------|-------------|
| `--username` | Username of the account |
| `--password` | New password |

```bash
php cli/joomla.php user:reset-password --username=<username> --password=<password>
```

---

### addtogroup — Add a user to a group

Adds a user to a Joomla user group.

**Additional inputs (optional as flags, prompted if omitted):**

| Option | Description |
|--------|-------------|
| `--username` | Username |
| `--group` | Group name |

```bash
php cli/joomla.php user:addtogroup --username=<username> --group=<group>
```

---

### removefromgroup — Remove a user from a group

Removes a user from a Joomla user group.

**Additional inputs (optional as flags, prompted if omitted):**

| Option | Description |
|--------|-------------|
| `--username` | Username |
| `--group` | Group name |

```bash
php cli/joomla.php user:removefromgroup --username=<username> --group=<group>
```

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For `list`: display username, name, email, and groups
