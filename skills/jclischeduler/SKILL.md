---
name: jclischeduler
description: Manage and run Joomla scheduled tasks via the Joomla CLI on a locally hosted site — list tasks, run one or all due tasks, and enable/disable/trash individual tasks.
argument-hint: [site_path] [action] [options]
---

# Joomla Task Scheduler CLI

Manage and run Joomla scheduled tasks using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `run`, or `state`.
- Action-specific options (see per-action details below).

## Prerequisites

Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.

All commands are run from `site_path`.

---

## Actions

### list — List all scheduled tasks

Displays all registered scheduled tasks and their current state.

```bash
php cli/joomla.php scheduler:list
```

---

### run — Run scheduled tasks

Runs scheduled tasks. Use `--id` to run a specific task by its numeric ID, or `--all` to run all tasks that are currently due.

**Additional inputs (optional):**

| Option | Description |
|--------|-------------|
| `-i` / `--id` | Numeric ID of a specific task to run (overrides `--all`) |
| `--all` | Run all tasks that are currently due |

```bash
# Run a specific task
php cli/joomla.php scheduler:run --id=<id>

# Run all due tasks
php cli/joomla.php scheduler:run --all
```

---

### state — Change the state of a scheduled task

Enables, disables, or trashes a scheduled task by its numeric ID.

**Additional inputs:**

| Option | Description |
|--------|-------------|
| `-i` / `--id` | Numeric ID of the task to update (required) |
| `-s` / `--state` | New state: `1` or `enable`, `0` or `disable`, `-2` or `trash` |

```bash
# Enable a task
php cli/joomla.php scheduler:state --id=<id> --state=enable

# Disable a task
php cli/joomla.php scheduler:state --id=<id> --state=disable

# Trash a task
php cli/joomla.php scheduler:state --id=<id> --state=trash
```

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For `list`: display task ID, name, type, and state
