---
name: japitoken
description: Retrieve a valid Joomla API token from a local development Joomla site for testing API endpoints. Only works on local development sites (localhost, *.akeeba.dev, *.local.web, or sites under ~/Sites).
---

# Joomla API Token Retriever

Retrieve a valid Joomla API token from a local development Joomla site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.

## Safety Constraints

This skill only executes on local development sites. The site must meet at least one of these criteria:

- Domain resolves to `127.0.0.1`, `::1`, or a private subnet IP (e.g., `192.168.x.x`, `10.x.x.x`, `172.16.x.x` - `172.31.x.x`)
- Domain is `akeeba.dev` or a subdomain (e.g., `*.akeeba.dev`)
- Domain is `local.web` or a subdomain (e.g., `*.local.web`)
- Site root is under `/home/nicholas/Sites` or `/Users/nicholas/Sites`

If none of these criteria are met, refuse to execute and report the safety constraint violation.

## Domain Detection

To determine the site's domain:

1. Check for virtual host configuration files in common locations:
   - Apache: `/etc/apache2/sites-enabled/*`, `/etc/httpd/conf.d/*`
   - Nginx: `/etc/nginx/sites-enabled/*`, `/etc/nginx/conf.d/*`
   - Look for `DocumentRoot` or `root` directives matching `site_path`

2. If virtual host config is found, extract the domain from `ServerName` (Apache) or `server_name` (Nginx)

3. If no virtual host config is found and site is under `/home/nicholas/Sites` or `/Users/nicholas/Sites`, extract domain from directory basename and assume `<basename>.akeeba.dev`

4. Verify the domain resolution using `host <domain>` or `dig +short <domain>`

## Verify Joomla Installation

Check that `site_path` contains a valid Joomla installation:

- `configuration.php` exists in `site_path`
- `administrator/` directory exists
- `libraries/src/` directory exists (Joomla 4+/5+)

If not a valid Joomla site, stop and report.

## Process

1. Verify the site meets safety constraints
2. Copy the PHP script `get_token.php` from the skill directory to `site_path`
3. Execute the PHP script from `site_path`: `php get_token.php`
4. Parse the JSON output
5. Delete `get_token.php` from `site_path`

## Output

If successful, the JSON output contains:

```json
{"token": "BASE64_ENCODED_TOKEN"}
```

If failed, the JSON output contains:

```json
{"error": "Error message"}
```

Report the retrieved token to the user or the error encountered.

## Common Errors

- **configuration.php not found**: Not a valid Joomla installation or wrong site path
- **No Super Users found**: No users in the Super Users group (group_id=8)
- **No active Super Users found**: All Super Users are blocked or have pending activation
- **No users with API token enabled**: No Super Users have enabled the Joomla API token in their profile
- **No API token seed found**: No token seed exists in user profiles

## Notes

- This skill retrieves the first available valid API token from an active Super User who has the token feature enabled
- The token format is `sha256:USER_ID:HMAC_HASH` encoded in base64
- The HMAC hash is calculated using the site's secret key from `configuration.php`
- The API token is used in HTTP requests with the header: `X-Joomla-Token: <token>`
