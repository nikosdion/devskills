---
name: jmenusadmin
description: Manage Joomla administrator menus via the Joomla Web Services API. Supports listing, getting, creating, updating, and deleting administrator menus. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Administrator Menus Manager

Manage Joomla administrator menus through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `get`, `create`, `update`, `delete`.
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

### list — List administrator menus

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/administrator
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of administrator menus with their `id`, `title`, `menutype`, and `description`.

---

### get — Get a single administrator menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/administrator/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full menu details including `id`, `title`, `menutype`, and `description`.

---

### create — Create a new administrator menu

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | yes | Menu title (human-readable name) |
| `menutype` | string | yes | Menu type identifier (unique slug, e.g. `test-admin-menu`) |
| `description` | string | no | Menu description |

**Request:**
```
POST <baseUrl>/api/index.php/v1/menus/administrator
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "menutype": "<menutype>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new menu's `id`, `title`, and `menutype` on success.

---

### update — Update an existing administrator menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/menus/administrator/<id>
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

### delete — Delete an administrator menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/menus/administrator/<id>
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
| `404` | Not Found | No administrator menu with that ID exists. |
| `409` | Conflict | Menu type identifier already in use; suggest a different `menutype`. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Use `jmenusadminitems` to manage the menu items within an administrator menu.
- Administrator menus appear in the Joomla backend sidebar and top navigation.
