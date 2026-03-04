---
name: jfields
description: Manage Joomla custom fields via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting custom fields for any supported context. Only works on local development sites.
argument-hint: [site_path] [context] [action] [options]
---

# Joomla Custom Fields Manager

Manage Joomla custom fields through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `context`: The field context in `component.type` format. Common examples:
  - `com_content.article` — article custom fields
  - `com_contact.contact` — contact custom fields
  - `com_users.user` — user custom fields
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

### list — List custom fields

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by field title |
| `state` | int | `0`=unpublished, `1`=published |

**Request:**
```
GET <baseUrl>/api/index.php/v1/fields/<context>[?filter[search]=...&filter[state]=1]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of fields with their `id`, `title`, `name`, `type`, `state`, `group_id`, and `language`.

---

### get — Get a single custom field

**Additional inputs:**

- `id` (required): Numeric ID of the custom field to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/fields/<context>/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the full field details including `id`, `title`, `name`, `type`, `state`, `group_id`, `language`, `default_value`, `label`, and `description`.

---

### create — Create a new custom field

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Field title (human-readable label) |
| `type` | string | yes | — | Field type (e.g. `text`, `textarea`, `integer`, `list`, `checkboxes`, `radio`, `calendar`, `color`, `editor`, `imagelist`, `media`, `subfields`, `url`, `user`, `usergrouplist`) |
| `state` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |
| `group_id` | int | no | `0` | Field group ID (`0` = no group) |
| `label` | string | no | — | Frontend label (defaults to `title` if omitted) |
| `description` | string | no | `""` | Field description shown as tooltip |
| `default_value` | string | no | `""` | Default value for the field |
| `required` | int | no | `0` | `0`=not required, `1`=required |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/fields/<context>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "type": "<type>",
  "state": <state>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new field's `id`, `title`, `name`, and `type` on success.

---

### update — Update an existing custom field

**Additional inputs:**

- `id` (required): Numeric ID of the field to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/fields/<context>/<id>
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

### delete — Delete a custom field

> **Important:** Joomla requires a custom field to be trashed (`state = -2`) before it can be deleted. If the field is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the field to delete.
- `force` (optional, boolean): If `true`, automatically trash the field first without asking.

**Process:**
1. Run `get` to check the current `state` value of the field.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the field to set `state: -2` (trash it).
4. DELETE the field.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/fields/<context>/<id>
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
| `404` | Not Found | No field with that ID exists in the given context. |
| `409` | Conflict | Field name already in use; suggest a different title. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- The `context` parameter must be a valid Joomla context string (e.g. `com_content.article`). If the user provides a shorthand (e.g. `article`), expand it to the full context (`com_content.article`). Common shorthands: `article` → `com_content.article`, `contact` → `com_contact.contact`, `user` → `com_users.user`.
- The field `name` is auto-generated from `title` by Joomla (lowercased, spaces replaced with underscores). It cannot be set directly via the API.
- The `type` field determines the field's input widget. The most common types are `text`, `textarea`, `integer`, `list`, `checkboxes`, `radio`, `calendar`, and `media`.
