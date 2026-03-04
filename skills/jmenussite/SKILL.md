---
name: jmenussite
description: Manage Joomla site menus via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting site menus. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Site Menus Manager

Manage Joomla site menus through the Joomla Web Services API on a local development site.

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

### list — List site menus

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by menu title |

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/site[?filter[search]=main]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of menus with their `id`, `title`, `menutype`, and `description`.

---

### get — Get a single site menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/menus/site/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full menu details including `id`, `title`, `menutype`, `description`, and `client_id`.

---

### create — Create a new site menu

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | yes | Menu title (human-readable name) |
| `menutype` | string | yes | Menu type identifier (unique slug, e.g. `mainmenu`) |
| `description` | string | no | Menu description |

**Request:**
```
POST <baseUrl>/api/index.php/v1/menus/site
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "menutype": "<menutype>",
  "description": "<description>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new menu's `id`, `title`, and `menutype` on success.

---

### update — Update an existing site menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/menus/site/<id>
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

### delete — Delete a site menu

**Additional inputs:**

- `id` (required): Numeric ID of the menu to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/menus/site/<id>
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
| `404` | Not Found | No menu with that ID exists. |
| `409` | Conflict | Menu type identifier already in use; suggest a different `menutype`. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- The `menutype` is a unique string identifier (slug) used internally to reference the menu. Common built-in menu types include `mainmenu`, `usermenu`.
- Use `jmenussiteitems` to manage the menu items within a site menu.
