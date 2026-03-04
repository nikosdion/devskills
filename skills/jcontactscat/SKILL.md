---
name: jcontactscat
description: Manage Joomla contacts categories via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting categories. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Contacts Categories Manager

Manage Joomla contacts categories through the Joomla Web Services API on a local development site.

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

### list — List contacts categories

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by category title |
| `published` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `language` | string | Language code or `*` for all languages |
| `level` | int | Category nesting level |

**Request:**
```
GET <baseUrl>/api/index.php/v1/contacts/categories[?filter[published]=1&filter[search]=foo&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of categories with their `id`, `title`, `alias`, `published` status, `parent_id`, and `language`.

---

### get — Get a single contacts category

**Additional inputs:**

- `id` (required): Numeric ID of the category to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/contacts/categories/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the category details.

---

### create — Create a new contacts category

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Category title |
| `alias` | string | no | auto-generated | URL alias (slug) |
| `parent_id` | int | no | `1` | Parent category ID (`1` = root) |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |
| `description` | string | no | `""` | Category description (HTML allowed) |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/contacts/categories
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "alias": "<alias>",
  "parent_id": <parent_id>,
  "published": <published>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new category's `id`, `title`, and `alias` on success.

---

### update — Update an existing contacts category

**Additional inputs:**

- `id` (required): Numeric ID of the category to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/contacts/categories/<id>
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

### delete — Delete a contacts category

> **Important:** Joomla requires a category to be trashed (`published = -2`) before it can be deleted. If the category is not already trashed, first run an `update` to set `published` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the category to delete.
- `force` (optional, boolean): If `true`, automatically trash the category first without asking.

**Process:**
1. Run `get` to check the current `published` value of the category.
2. If not trashed (`published != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the category to set `published: -2` (trash it).
4. DELETE the category.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/contacts/categories/<id>
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
| `404` | Not Found | No category with that ID exists. |
| `409` | Conflict | Alias already in use; suggest a different alias. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Category IDs 1 and 2 are system categories (root and uncategorised); warn the user before modifying or deleting them.
- Use `curl` for HTTP requests unless another HTTP client is available.
