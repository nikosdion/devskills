---
name: jextensions
description: List and filter installed Joomla extensions via the Joomla Web Services API. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Extensions Manager

List and inspect installed Joomla extensions through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `get`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Use the `japitoken` skill to retrieve a valid API token for the site at `site_path`.
2. Determine the site's base URL using the same domain-detection logic as `japitoken` (virtual host config or directory-basename + `{{JOOMLA_SITE_DOMAIN}}`).
3. All API requests use:
   - `Authorization: Bearer <token>`
   - `Accept: application/vnd.api+json`

## Safety Constraints

Inherits the same constraints as `japitoken`: only operates on local development sites (localhost, `*.{{JOOMLA_SITE_DOMAIN}}`, `*.local.web`, or under `{{JOOMLA_SITES_DIR}}`).

---

## Actions

### list — List installed extensions

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by extension name |
| `type` | string | Extension type: `component`, `module`, `plugin`, `template`, `library`, `package` |
| `enabled` | int | `0`=disabled, `1`=enabled |

**Request:**
```
GET <baseUrl>/api/index.php/v1/extensions[?filter[type]=component&filter[enabled]=1&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of extensions with their `extension_id`, `name`, `element`, `type`, `folder`, `enabled`, and `version`.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- This endpoint is read-only. To install or uninstall extensions, use the Joomla administrator backend or the `joomlaupdate` skill for core updates.
- Extension types: `component` (applications), `module` (page sections), `plugin` (event-driven extensions), `template` (themes), `library` (shared code), `package` (bundles of extensions).
