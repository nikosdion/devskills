---
name: jbanners
description: Manage Joomla banners via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting banners. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Banners Manager

Manage Joomla banners through the Joomla Web Services API on a local development site.

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

### list — List banners

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by banner name |
| `state` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `category` | int | Filter by category ID |
| `client_id` | int | Filter by client ID |

**Request:**
```
GET <baseUrl>/api/index.php/v1/banners[?filter[state]=1&filter[category]=3&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of banners with their `id`, `name`, `alias`, `state`, `catid`, `client_id`, and `language`.

---

### get — Get a single banner

**Additional inputs:**

- `id` (required): Numeric ID of the banner to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/banners/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full banner details including `id`, `name`, `alias`, `state`, `catid`, `client_id`, `type`, `clickurl`, and `language`.

---

### create — Create a new banner

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Banner name |
| `alias` | string | no | auto-generated | URL alias (slug) |
| `catid` | int | no | — | Category ID |
| `client_id` | int | no | — | Client ID |
| `state` | int | no | `1` | `0`=unpublished, `1`=published |
| `type` | string | no | `"0"` | Banner type: `"0"`=image, `"1"`=custom HTML |
| `clickurl` | string | no | — | URL to open when banner is clicked |
| `language` | string | no | `*` | Language code or `*` for all |

**Request:**
```
POST <baseUrl>/api/index.php/v1/banners
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "name": "<name>",
  "catid": <catid>,
  "state": <state>,
  "type": "<type>",
  "clickurl": "<clickurl>",
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new banner's `id`, `name`, and `alias` on success.

---

### update — Update an existing banner

**Additional inputs:**

- `id` (required): Numeric ID of the banner to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/banners/<id>
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

### delete — Delete a banner

> **Important:** Joomla requires a banner to be trashed (`state = -2`) before it can be deleted. If the banner is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the banner to delete.
- `force` (optional, boolean): If `true`, automatically trash the banner first without asking.

**Process:**
1. Run `get` to check the current `state` value of the banner.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the banner to set `state: -2` (trash it).
4. DELETE the banner.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/banners/<id>
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
| `404` | Not Found | No banner with that ID exists. |
| `409` | Conflict | Alias already in use; suggest a different alias. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
