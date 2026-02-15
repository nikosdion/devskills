---
name: unblock
description: Unblock localhost access on Joomla or WordPress sites using Admin Tools for Joomla or Admin Tools for WordPress. Use when a user asks to "unblock localhost", "unblock me", or "unblock my access" and run the correct CLI unblock commands for 127.0.0.1 and ::1.
---

# Admin Tools Localhost Unblock

Unblock localhost access on a Joomla or WordPress site through Admin Tools CLI commands.

## Inputs

- `site_path`: Absolute or relative path to the site root.

## Detect CMS

Identify site type from `site_path`:

- Joomla indicators: `configuration.php`, `cli/joomla.php`, `administrator/`
- WordPress indicators: `wp-config.php`, `wp-content/`, `wp-includes/`

If site type is not identifiable, stop and report unsupported site type.

## Verify Admin Tools Installation

For Joomla, verify Admin Tools for Joomla (`com_admintools`) is installed:

- Preferred check: `php cli/joomla.php list | grep -i admintools`
- Fallback check: `administrator/components/com_admintools` exists

For WordPress, verify Admin Tools for WordPress (`admintoolswp`) is installed:

- Preferred check: `wp plugin is-installed admintoolswp`
- Optional check: `wp plugin status admintoolswp`

If Admin Tools is not installed for the detected CMS, stop and report that unblock cannot be performed.

## Run Unblock Commands

Run commands from `site_path`.

For Joomla:

```bash
php cli/joomla.php admintools:unblock 127.0.0.1
php cli/joomla.php admintools:unblock ::1
```

For WordPress:

```bash
wp admintools unblock 127.0.0.1
wp admintools unblock ::1
```

Run both IPv4 and IPv6 unblock commands in sequence.

## Output

Report:

- Detected CMS type
- Admin Tools installation check result
- Commands executed
- Success/failure for each unblock command
