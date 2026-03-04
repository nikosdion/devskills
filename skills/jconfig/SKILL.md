---
name: jconfig
description: Manage Joomla Global Configuration and component configuration via the Joomla Web Services API. Supports reading and updating application-level configuration and per-component configuration. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Configuration Manager

Manage Joomla's Global Configuration and component configuration through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `get-app`, `update-app`, `get-component`, `update-component`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Use the `japitoken` skill to retrieve a valid API token for the site at `site_path`.
2. Determine the site's base URL using the same domain-detection logic as `japitoken` (virtual host config or directory-basename + `{{JOOMLA_SITE_DOMAIN}}`).
3. All API requests use:
   - `Authorization: Bearer <token>`
   - `Accept: application/vnd.api+json`
   - For PATCH: also `Content-Type: application/json`

## Safety Constraints

Inherits the same constraints as `japitoken`: only operates on local development sites (localhost, `*.{{JOOMLA_SITE_DOMAIN}}`, `*.local.web`, or under `{{JOOMLA_SITES_DIR}}`).

---

## Actions

### get-app — Read the Global Configuration

**Request:**
```
GET <baseUrl>/api/index.php/v1/config/application
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display all configuration attributes returned by the API. Present them in a readable table or key-value format grouped by logical sections (site, database, mail, session, etc.) where possible.

---

### update-app — Update the Global Configuration

**Additional inputs:**

One or more configuration field names and their new values. Any field returned by `get-app` is a valid target. Common fields include:

| Field | Type | Description |
|-------|------|-------------|
| `sitename` | string | Site name displayed in the frontend |
| `offline` | int | `0`=online, `1`=offline |
| `offline_message` | string | Message shown when site is offline |
| `display_offline_message` | int | `0`=use custom message, `1`=use site message, `2`=use Joomla default |
| `offline_image` | string | Path to offline image |
| `sitedescription` | string | Site meta description |
| `robots` | string | Meta robots directive (e.g. `index, follow`) |
| `sef` | int | `0`=off, `1`=on — Search Engine Friendly URLs |
| `sef_rewrite` | int | `0`=off, `1`=on — Apache mod_rewrite |
| `sef_suffix` | int | `0`=off, `1`=on — Add suffix to URLs |
| `unicodeslugs` | int | `0`=off, `1`=on — Unicode aliases |
| `feed_limit` | int | Number of items in news feed |
| `debug` | int | `0`=off, `1`=on — Debug system |
| `debug_lang` | int | `0`=off, `1`=on — Debug language |
| `error_reporting` | string | Error reporting level (e.g. `default`, `maximum`) |
| `helpurl` | string | Help server URL |
| `cachetime` | int | Cache lifetime in minutes |
| `cache` | int | `0`=off, `1`=on — System cache |
| `cache_handler` | string | Cache handler (e.g. `file`) |
| `session_handler` | string | Session handler (e.g. `database`, `filesystem`) |
| `lifetime` | int | Session lifetime in minutes |
| `cookie_domain` | string | Cookie domain |
| `cookie_path` | string | Cookie path |
| `mailonline` | int | `0`=off, `1`=on — Send mail |
| `mailer` | string | Mailer type (e.g. `mail`, `smtp`, `sendmail`) |
| `mailfrom` | string | From email address |
| `fromname` | string | From name |
| `smtphost` | string | SMTP host |
| `smtpport` | int | SMTP port |
| `smtpuser` | string | SMTP username |
| `smtppass` | string | SMTP password |
| `smtpsecure` | string | SMTP security (`none`, `ssl`, `tls`) |
| `smtpauth` | int | `0`=off, `1`=on — SMTP authentication |
| `MetaAuthor` | int | `0`=off, `1`=on — Show author meta tag |
| `MetaVersion` | int | `0`=off, `1`=on — Show Joomla version in meta |
| `list_limit` | int | Default list limit in admin |

Include only the fields provided by the user in the request body; omit all others.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/config/application
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "<field>": <value>,
  ...
}
```

**Output:** Confirm success and list the fields that were updated. If the API returns the updated configuration object, display the new values for the changed fields.

---

### get-component — Read a component's configuration

**Additional inputs:**

- `component` (required): Component name in `com_*` format (e.g. `com_content`, `com_users`, `com_menus`).

**Request:**
```
GET <baseUrl>/api/index.php/v1/config/<component>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display all configuration attributes returned for the component in a readable key-value format.

---

### update-component — Update a component's configuration

**Additional inputs:**

- `component` (required): Component name in `com_*` format.
- One or more configuration field names and their new values. Use `get-component` first to discover available fields for the target component.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/config/<component>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "<field>": <value>,
  ...
}
```

**Output:** Confirm success and list the fields that were updated.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | Configuration endpoint not found; verify the component name is correct. |
| `422` | Unprocessable | Validation error; display the API error message from the response body. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract configuration fields from `data.attributes` in the response.
- Use `get-app` or `get-component` before updating to discover current values and valid field names.
- Changing critical settings (e.g. `offline`, `debug`, SMTP credentials) may affect site behaviour immediately. Confirm with the user before applying such changes if they were not explicitly requested.
- Use `curl` for HTTP requests unless another HTTP client is available.
