---
name: jmenusadminitems
description: Manage Joomla administrator menu items via the Joomla Web Services API. Supports listing, filtering, getting, listing item types, creating, updating, and deleting administrator menu items. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Administrator Menu Items Manager

Manage Joomla administrator menu items through the Joomla Web Services API on a local development site.

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

### list — List administrator menu items

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by item title |
| `published` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `language` | string | Language code or `*` for all |
| `menutype` | string | Filter by menu type identifier (e.g. `main`) |
| `level` | int | Menu item nesting level |

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/administrator/items[?filter[published]=1&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of menu items with their `id`, `title`, `alias`, `published`, `menutype`, `type`, `parent_id`, and `language`.

---

### get — Get a single administrator menu item

**Additional inputs:**

- `id` (required): Numeric ID of the menu item to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/administrator/items/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full menu item details including `id`, `title`, `alias`, `published`, `menutype`, `type`, `link`, `parent_id`, `level`, and `language`.

---

### list-types — List available administrator menu item types

Lists all menu item types available for creation in the administrator application.

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/administrator/items/types
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of available menu item types with their `title`, `type`, and `component`.

---

### create — Create a new administrator menu item

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Menu item title |
| `alias` | string | no | auto-generated | URL alias |
| `menutype` | string | yes | — | Menu type identifier (e.g. `main`) |
| `type` | string | yes | — | Item type: `component`, `url`, `alias`, `separator`, `heading` |
| `link` | string | yes | — | URL or component link (e.g. `index.php?option=com_content`) |
| `parent_id` | int | no | `1` | Parent item ID (`1` = root) |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |

**Request:**
```
POST <baseUrl>/api/index.php/v1/menus/administrator/items
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "menutype": "<menutype>",
  "type": "<type>",
  "link": "<link>",
  "parent_id": <parent_id>,
  "published": <published>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new menu item's `id`, `title`, and `alias` on success.

---

### update — Update an existing administrator menu item

**Additional inputs:**

- `id` (required): Numeric ID of the menu item to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/menus/administrator/items/<id>
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

### delete — Delete an administrator menu item

**Additional inputs:**

- `id` (required): Numeric ID of the menu item to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/menus/administrator/items/<id>
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
| `404` | Not Found | No menu item with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Use `jmenusadmin` to manage the administrator menus that contain these items.
