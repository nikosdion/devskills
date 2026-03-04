---
name: jclidatacompliance
description: Manage GDPR-compliant user account deletion and lifecycle notifications via the Joomla CLI on a locally hosted site using Akeeba DataCompliance. Supports deleting individual accounts, automatically removing expired accounts, and sending pre-deletion notifications.
argument-hint: [site_path] [action] [options]
---

# Akeeba DataCompliance CLI

Perform GDPR-compliant user account management using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `delete-account`, `lifecycle-delete`, or `lifecycle-notify`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Akeeba DataCompliance must be installed on the site.

All commands are run from `site_path`.

---

## Actions

### delete-account — GDPR-compliant deletion of a user account

Permanently wipes a specific user account in a GDPR-compliant manner. Either `--username` or `--id` must be provided.

> **Warning:** This permanently and irreversibly deletes the user account and all associated data. This action cannot be undone. Always use `--dry-run` first to review what will be deleted.

**Additional inputs:**

| Option | Description |
|--------|-------------|
| `-u` / `--username` | Username of the account to delete |
| `-i` / `--id` | Numeric user ID of the account to delete |
| `-f` / `--force` | Ignore safety checks (DANGER — can delete Super User accounts) |
| `-r` / `--dry-run` | Simulate the deletion without actually removing anything |
| `-d` / `--debug` | Enable debug mode |

```bash
# Dry run first (recommended)
php cli/joomla.php datacompliance:account:delete --username=<username> --dry-run

# Actual deletion
php cli/joomla.php datacompliance:account:delete --username=<username>

# By user ID
php cli/joomla.php datacompliance:account:delete --id=<user_id>
```

---

### lifecycle-delete — Automatically remove expired inactive user accounts

Deletes user accounts that have exceeded their allowed inactivity period according to DataCompliance lifecycle rules.

> **Warning:** This permanently wipes multiple user accounts. Use `--dry-run` first.

**Additional inputs (optional):**

| Option | Description |
|--------|-------------|
| `-r` / `--dry-run` | Simulate deletion without removing anything |
| `-f` / `--force` | Force deletion even if accounts have not been notified first |
| `-d` / `--debug` | Enable debug mode |

```bash
# Dry run first
php cli/joomla.php datacompliance:lifecycle:delete --dry-run

# Actual deletion
php cli/joomla.php datacompliance:lifecycle:delete
```

---

### lifecycle-notify — Notify users before their accounts are removed

Sends email notifications to users whose accounts are scheduled for deletion due to inactivity, giving them an opportunity to log in or opt out.

**Additional inputs (optional):**

| Option | Description |
|--------|-------------|
| `-p` / `--period` | Notification period before deletion as a PHP DateInterval (e.g. `P1M` for 1 month, `P2W` for 2 weeks) |
| `-r` / `--dry-run` | Simulate sending without actually sending emails |
| `-d` / `--debug` | Enable debug mode |

```bash
# Notify users who will be deleted within 1 month
php cli/joomla.php datacompliance:lifecycle:notify --period=P1M

# Dry run
php cli/joomla.php datacompliance:lifecycle:notify --period=P1M --dry-run
```

**Typical lifecycle workflow:**
1. Run `lifecycle-notify` to warn users.
2. Wait for the notification period to expire.
3. Run `lifecycle-delete` (with `--dry-run` first) to remove expired accounts.

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- Number of accounts affected or notifications sent
- Any errors or skipped accounts with reasons
