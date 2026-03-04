---
name: jcliadmintools
description: Manage Admin Tools for Joomla via the Joomla CLI on a locally hosted site. Covers WAF configuration, IP allowlist/blocklist, auto-ban, bad words, server configuration files (htaccess/nginx/web.config), security scan, temp directory, blocked request log, emergency offline mode, and configuration export/import.
argument-hint: [site_path] [action] [options]
---

# Admin Tools for Joomla CLI

Manage Admin Tools for Joomla using the Joomla CLI application.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of the actions listed below.
- Action-specific options (see per-action details below).

## Prerequisites

1. Verify the Joomla CLI is available at `site_path/cli/joomla.php`. If not found, stop and report the error.
2. Verify Admin Tools for Joomla (`com_admintools`) is installed. Check with: `php cli/joomla.php list | grep admintools`

All commands are run from `site_path`.

---

## General Actions

### scan — Run the PHP File Change Scanner

Scans the site's files for security issues.

```bash
php cli/joomla.php admintools:scan
```

---

### offline — Enable or disable Emergency Offline mode

```bash
# Enable emergency offline
php cli/joomla.php admintools:offline --enable

# Disable emergency offline
php cli/joomla.php admintools:offline --disable
```

---

### temp-clear — Clear the temp directory

Removes files from the site's temp directory. Files newer than `--age` seconds are preserved. `index.htm[l]`, `.htaccess`, and `web.config` are never removed.

```bash
php cli/joomla.php admintools:temp:clear [--age=<seconds>]
```

Default age: 60 seconds.

---

### unblock — Unblock a blocked IP address

Removes an IP address from all Admin Tools block lists.

```bash
php cli/joomla.php admintools:unblock --ip=<ip>
```

---

### joomlaupdate-reset — Reset Joomla Update to factory defaults

```bash
php cli/joomla.php admintools:joomlaupdate:reset
```

---

### export — Export Admin Tools configuration

Exports the entire Admin Tools configuration to JSON. Optionally write to a file.

```bash
php cli/joomla.php admintools:export [--file=<path>]
```

---

### import — Import Admin Tools configuration

Imports Admin Tools configuration from a JSON file.

```bash
php cli/joomla.php admintools:import --file=<path>
```

---

## WAF Configuration

### waf-list — List all WAF rules

```bash
php cli/joomla.php admintools:waf:list
```

### waf-get — Get a WAF rule value

```bash
php cli/joomla.php admintools:waf:get --rule=<rule>
```

### waf-set — Set a WAF rule value

Supports scalar values, list additions/removals, and clearing.

```bash
php cli/joomla.php admintools:waf:set --key=<key> --value=<value>
php cli/joomla.php admintools:waf:set --key=<key> --add=<value>
php cli/joomla.php admintools:waf:set --key=<key> --remove=<value>
php cli/joomla.php admintools:waf:set --key=<key> --empty
```

---

## WAF Deny Rules

### wafdeny-list — List WAF deny rules

```bash
php cli/joomla.php admintools:wafdeny:list [--format=table|json|yaml|csv|count]
```

### wafdeny-add — Create a WAF deny rule

| Option | Description |
|--------|-------------|
| `--application` | Application side: `site` or `administrator` |
| `--component` | Component name (optional) |
| `--view` | View name (optional) |
| `--task` | Task name (optional) |
| `--query` | Query parameter to match (optional) |
| `--query_type` | Type of check to apply |
| `--query_content` | Content to match against (optional) |
| `--verb` | HTTP verb (optional) |
| `--enabled` | Whether the rule is enabled (optional) |

```bash
php cli/joomla.php admintools:wafdeny:add --application=<app> [--component=<c>] [--view=<v>] [--task=<t>] [--query=<q>] [--query_type=<type>] [--query_content=<content>] [--verb=<verb>] [--enabled=<0|1>]
```

### wafdeny-modify — Modify a WAF deny rule

Same options as `wafdeny-add`, plus the record `id` argument.

```bash
php cli/joomla.php admintools:wafdeny:modify <id> --application=<app> [...]
```

### wafdeny-remove — Delete a WAF deny rule

```bash
php cli/joomla.php admintools:wafdeny:remove <id>
```

---

## WAF Exceptions

### wafexceptions-list — List WAF exceptions

```bash
php cli/joomla.php admintools:wafexceptions:list [--format=table|json|yaml|csv|count]
```

### wafexceptions-add — Create a WAF exception

| Option | Description |
|--------|-------------|
| `--component` | Component name (required) |
| `--view` | View name (required) |
| `--query` | Query parameter to exempt (required) |

```bash
php cli/joomla.php admintools:wafexceptions:add --component=<c> --view=<v> --query=<q>
```

### wafexceptions-modify — Modify a WAF exception

```bash
php cli/joomla.php admintools:wafexceptions:modify <id> --component=<c> --view=<v> --query=<q>
```

### wafexceptions-remove — Delete a WAF exception

```bash
php cli/joomla.php admintools:wafexceptions:remove <id>
```

---

## IP Allow List (Administrator Exclusive Allow)

### ipallow-list — List allowed IPs

```bash
php cli/joomla.php admintools:ipallow:list [--format=table|json|yaml|csv|count]
```

### ipallow-add — Add an IP to the allow list

```bash
php cli/joomla.php admintools:ipallow:add --ip=<ip> [--description=<desc>]
```

### ipallow-modify — Modify an IP allow list entry

```bash
php cli/joomla.php admintools:ipallow:modify <id> --ip=<ip> [--description=<desc>]
```

### ipallow-remove — Remove an IP from the allow list

```bash
php cli/joomla.php admintools:ipallow:remove <id>
```

---

## IP Disallow List (Site IP Blocklist)

### ipdisallow-list — List blocked IPs

```bash
php cli/joomla.php admintools:ipdisallow:list [--format=table|json|yaml|csv|count]
```

### ipdisallow-add — Block an IP

```bash
php cli/joomla.php admintools:ipdisallow:add --ip=<ip> [--description=<desc>]
```

### ipdisallow-modify — Modify a blocked IP entry

```bash
php cli/joomla.php admintools:ipdisallow:modify <id> --ip=<ip> [--description=<desc>]
```

### ipdisallow-remove — Remove an IP from the blocklist

```bash
php cli/joomla.php admintools:ipdisallow:remove <id>
```

---

## Automatically Blocked IPs (Auto-ban)

### autoban-list — List automatically blocked IPs

```bash
php cli/joomla.php admintools:autoban:list [--format=table|json|yaml|csv|count]
```

### autoban-remove — Remove an entry from the auto-ban list

```bash
php cli/joomla.php admintools:autoban:remove <id>
```

---

## Auto-ban History

### autobanhistory-list — List auto-ban history

```bash
php cli/joomla.php admintools:autobanhistory:list [--format=table|json|yaml|csv|count]
```

### autobanhistory-remove — Remove a history entry

```bash
php cli/joomla.php admintools:autobanhistory:remove <id>
```

---

## Blocked Request Log

### log-list — List blocked request log entries

```bash
php cli/joomla.php admintools:log:list [--format=table|json|yaml|csv|count]
```

### log-remove — Remove a log entry

```bash
php cli/joomla.php admintools:log:remove <id>
```

---

## Bad Words List

### badwords-list — List bad words

```bash
php cli/joomla.php admintools:badwords:list [--format=table|json|yaml|csv|count]
```

### badwords-add — Add a bad word

```bash
php cli/joomla.php admintools:badwords:add --word=<word>
```

### badwords-remove — Remove a bad word

```bash
php cli/joomla.php admintools:badwords:remove <id>
```

---

## Server Configuration Files

Admin Tools supports generating server configuration files for Apache (`.htaccess`), Nginx, and IIS (`web.config`). Each web server type has the same four sub-commands: `list`, `get`, `set`, and `make`.

Replace `<server>` with `htmaker` (Apache), `nginxmaker` (Nginx), or `webconfigmaker` (IIS/web.config).

### <server>-list — List all server configuration rules

```bash
php cli/joomla.php admintools:<server>:list
```

### <server>-get — Get a specific server configuration option

```bash
php cli/joomla.php admintools:<server>:get --option=<option>
```

### <server>-set — Set a server configuration rule

```bash
php cli/joomla.php admintools:<server>:set --key=<key> --value=<value>
php cli/joomla.php admintools:<server>:set --key=<key> --add=<value>
php cli/joomla.php admintools:<server>:set --key=<key> --remove=<value>
php cli/joomla.php admintools:<server>:set --key=<key> --empty
```

### <server>-make — Generate the server configuration file

Generates and writes the configuration file to disk. Use `--preview` to output to console without writing.

```bash
php cli/joomla.php admintools:<server>:make [--preview] [--server_version=<version>]
```

---

## Output

Report:
- The action performed
- Command executed with all options
- Success/failure and key CLI output
- For list commands: display results in a readable table
