---
name: jclidocimport
description: Regenerate Akeeba DocImport category content from DocBook 5+ XML sources via the Joomla CLI on a locally hosted site. Supports regenerating all categories or a specific one, with an option to force regeneration even if already up-to-date.
argument-hint: [site_path] [category_id] [--force]
---

# Joomla DocImport Content Generator CLI

Regenerate Akeeba DocImport category content from DocBook XML sources using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `category` (optional): Numeric ID of a specific DocImport category to regenerate. Omit to regenerate all categories.
- `--force` (optional): Regenerate even if the category is already up-to-date.

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Akeeba DocImport must be installed on the site.

All commands are run from `site_path`.

---

## Command

### Regenerate all categories

```bash
php cli/joomla.php docimport:generate [--force]
```

### Regenerate a specific category

```bash
php cli/joomla.php docimport:generate <category_id> [--force]
```

---

## Output

Report:
- Categories regenerated
- Command executed
- Success/failure and key CLI output
- Any warnings or errors (e.g. missing XML sources)
