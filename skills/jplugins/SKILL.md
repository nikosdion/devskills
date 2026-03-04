---
name: jplugins
description: Manage Joomla plugins via the Joomla Web Services API. Supports listing, filtering, getting, and enabling/disabling plugins. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Plugins Manager

Manage Joomla plugins through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `get`, `update`.
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

### list — List plugins

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by plugin name |
| `enabled` | int | `0`=disabled, `1`=enabled |
| `folder` | string | Plugin group/folder (e.g. `system`, `content`, `user`, `authentication`) |
| `element` | string | Plugin element name (e.g. `plg_system_cache`) |

**Request:**
```
GET <baseUrl>/api/index.php/v1/plugins[?filter[folder]=system&filter[enabled]=1&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of plugins with their `id`, `name`, `element`, `folder`, `enabled`, and `access`.

---

### get — Get a single plugin

**Additional inputs:**

- `id` (required): Numeric ID of the plugin to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/plugins/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full plugin details including `id`, `name`, `element`, `folder`, `enabled`, `access`, and `params`.

---

### update — Update a plugin (enable/disable or change params)

**Additional inputs:**

- `id` (required): Numeric ID of the plugin to update.
- `enabled` (optional, int): `0`=disable, `1`=enable.
- `access` (optional, int): Access level ID.
- Additional plugin-specific `params` fields as needed.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/plugins/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "enabled": <enabled>
}
```

Include only the fields provided by the user.

**Output:** Confirm the updated fields on success.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | No plugin with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Plugins cannot be created or deleted via the API; they are installed/uninstalled via the Joomla installer (use `jextensions` to list them).
- Common plugin folders: `system`, `content`, `user`, `authentication`, `editors`, `editors-xtd`, `search`, `finder`, `captcha`, `installer`, `fields`, `privacy`, `actionlog`, `console`, `webservices`, `workflow`.
- Disabling essential plugins (e.g. authentication plugins) can prevent login. Always verify before disabling.
