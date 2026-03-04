---
name: jmodulesadmin
description: Manage Joomla administrator modules via the Joomla Web Services API. Supports listing, filtering, getting, listing module types, creating, updating, and deleting administrator modules. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Administrator Modules Manager

Manage Joomla administrator modules through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `get`, `list-types`, `create`, `update`, `delete`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Use the `japitoken` skill to retrieve a valid API token for the site at `site_path`.
2. Determine the site's base URL using the same domain-detection logic as `japitoken` (virtual host config or directory-basename + `{{JOOMLA_SITE_DOMAIN}}`).
3. All API requests use:
   - `Authorization: Bearer <token>`
   - `Accept: application/vnd.api+json`
   - For POST/PATCH: also `Content-Type: application/json`

## Safety Constraints

Inherits the same constraints as `japitoken`: only operates on local development sites (localhost, `*.{{JOOMLA_SITE_DOMAIN}}`, `*.local.web`, or under `{{JOOMLA_SITES_DIR}}`).

---

## Actions

### list — List administrator modules

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by module title |
| `state` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `position` | string | Module position |
| `module` | string | Module type (e.g. `mod_menu`, `mod_custom`) |
| `access` | int | Access level ID |

**Request:**
```
GET <baseUrl>/api/index.php/v1/modules/administrator[?filter[state]=1&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of modules with their `id`, `title`, `module`, `position`, `published`, and `language`.

---

### get — Get a single administrator module

**Additional inputs:**

- `id` (required): Numeric ID of the module to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/modules/administrator/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full module details including `id`, `title`, `module`, `position`, `published`, `language`, `access`, and `params`.

---

### list-types — List available administrator module types

Lists all administrator module types available for installation.

**Request:**
```
GET <baseUrl>/api/index.php/v1/modules/types/administrator
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of available module types with their `name` and `display_name`.

---

### create — Create a new administrator module

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Module title |
| `module` | string | yes | — | Module type (e.g. `mod_custom`, `mod_menu`) |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `position` | string | no | — | Administrator template position |
| `language` | string | no | `*` | Language code or `*` for all |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/modules/administrator
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "module": "<module>",
  "published": <published>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new module's `id`, `title`, and `module` on success.

---

### update — Update an existing administrator module

**Additional inputs:**

- `id` (required): Numeric ID of the module to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/modules/administrator/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "<field>": <value>,
  ...
}
```

**Output:** Confirm the updated fields on success.

---

### delete — Delete an administrator module

> **Important:** Joomla requires a module to be trashed (`published = -2`) before it can be deleted. If the module is not already trashed, first run an `update` to set `published` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the module to delete.
- `force` (optional, boolean): If `true`, automatically trash the module first without asking.

**Process:**
1. Run `get` to check the current `published` value of the module.
2. If not trashed (`published != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the module to set `published: -2` (trash it).
4. DELETE the module.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/modules/administrator/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Confirm deletion success, or report the error.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | No module with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Administrator modules use the field name `published` (not `state`) for publication status.
- Administrator module positions are defined by the active administrator template (default: Atum).
