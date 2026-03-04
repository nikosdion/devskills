---
name: jfieldgroups
description: Manage Joomla custom field groups via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting field groups for any supported context. Only works on local development sites.
argument-hint: [site_path] [context] [action] [options]
---

# Joomla Custom Field Groups Manager

Manage Joomla custom field groups through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `context`: The field context in `component.type` format. Common examples:
  - `com_content.article` — article field groups
  - `com_contact.contact` — contact field groups
  - `com_users.user` — user field groups
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

### list — List custom field groups

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by field group title |
| `state` | int | `0`=unpublished, `1`=published |

**Request:**
```
GET <baseUrl>/api/index.php/v1/fields/groups/<context>[?filter[search]=...&filter[state]=1]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of field groups with their `id`, `title`, `state`, and `language`.

---

### get — Get a single custom field group

**Additional inputs:**

- `id` (required): Numeric ID of the field group to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/fields/groups/<context>/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full field group details including `id`, `title`, `state`, `language`, `access`, and `description`.

---

### create — Create a new custom field group

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Field group title |
| `state` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |
| `description` | string | no | `""` | Group description |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/fields/groups/<context>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "state": <state>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new field group's `id` and `title` on success.

---

### update — Update an existing custom field group

**Additional inputs:**

- `id` (required): Numeric ID of the field group to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/fields/groups/<context>/<id>
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

### delete — Delete a custom field group

> **Important:** Joomla requires a field group to be trashed (`state = -2`) before it can be deleted. If the group is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the field group to delete.
- `force` (optional, boolean): If `true`, automatically trash the group first without asking.

**Process:**
1. Run `get` to check the current `state` value of the field group.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the field group to set `state: -2` (trash it).
4. DELETE the field group.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/fields/groups/<context>/<id>
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
| `404` | Not Found | No field group with that ID exists in the given context. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- The `context` parameter must be a valid Joomla context string (e.g. `com_content.article`). If the user provides a shorthand (e.g. `article`), expand it to the full context (`com_content.article`). Common shorthands: `article` → `com_content.article`, `contact` → `com_contact.contact`, `user` → `com_users.user`.
- Field groups organize custom fields into tabs in the item edit form. Deleting a group does not delete the fields within it; fields are moved to no group.
