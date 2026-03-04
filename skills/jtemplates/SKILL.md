---
name: jtemplates
description: Manage Joomla template styles via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting template styles for both site and administrator applications. Only works on local development sites.
argument-hint: [site_path] [app] [action] [options]
---

# Joomla Template Styles Manager

Manage Joomla template styles through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `app`: Application scope — `site` or `administrator`.
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

## API Endpoint Pattern

All endpoints use the base path: `<baseUrl>/api/index.php/v1/templates/styles/<app>`

Where `<app>` is `site` or `administrator`.

---

## Actions

### list — List template styles

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by style title |
| `template` | string | Filter by template name (e.g. `cassiopeia`, `atum`) |

**Request:**
```
GET <baseUrl>/api/index.php/v1/templates/styles/<app>[?filter[template]=cassiopeia]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of template styles with their `id`, `title`, `template`, `home`, and `client_id`.

---

### get — Get a single template style

**Additional inputs:**

- `id` (required): Numeric ID of the template style to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/templates/styles/<app>/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full template style details including `id`, `title`, `template`, `home`, `client_id`, and `params`.

---

### create — Create a new template style

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Style title (human-readable name) |
| `template` | string | yes | — | Template name (e.g. `cassiopeia` for site, `atum` for administrator) |
| `home` | bool | no | `false` | Whether this is the default (home) style |

**Request:**
```
POST <baseUrl>/api/index.php/v1/templates/styles/<app>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "template": "<template>",
  "home": <home>
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new style's `id`, `title`, and `template` on success.

---

### update — Update an existing template style

**Additional inputs:**

- `id` (required): Numeric ID of the template style to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/templates/styles/<app>/<id>
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

### delete — Delete a template style

**Additional inputs:**

- `id` (required): Numeric ID of the template style to delete.

> **Warning:** Do not delete the default (home) template style or the only style for a template; this can break the site's frontend or backend.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/templates/styles/<app>/<id>
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
| `404` | Not Found | No template style with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- A "template style" is a named configuration of a template. Multiple styles can exist for the same template (e.g. different colour schemes), and each can be assigned to different menu items.
- The `home` field indicates the default style used when no specific style is assigned to a menu item.
- Default templates: `cassiopeia` for site, `atum` for administrator.
