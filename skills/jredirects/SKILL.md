---
name: jredirects
description: Manage Joomla URL redirects via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting redirects. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Redirects Manager

Manage Joomla URL redirects through the Joomla Web Services API on a local development site.

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

### list — List redirects

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by source or destination URL |
| `published` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |

**Request:**
```
GET <baseUrl>/api/index.php/v1/redirects[?filter[published]=1&filter[search]=/old&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of redirects with their `id`, `old_url`, `new_url`, `referer` (HTTP status code), `published`, and `hits`.

---

### get — Get a single redirect

**Additional inputs:**

- `id` (required): Numeric ID of the redirect to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/redirects/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full redirect details including `id`, `old_url`, `new_url`, `referer`, `published`, `hits`, and `comment`.

---

### create — Create a new redirect

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `old_url` | string | yes | — | Source URL to redirect from (relative path, e.g. `/old-page`) |
| `new_url` | string | yes | — | Destination URL to redirect to (relative path or absolute URL) |
| `referer` | int | no | `301` | HTTP redirect status code: `301`=permanent, `302`=temporary |
| `published` | int | no | `1` | `0`=disabled, `1`=enabled |
| `comment` | string | no | `""` | Internal note about the redirect |

**Request:**
```
POST <baseUrl>/api/index.php/v1/redirects
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "old_url": "<old_url>",
  "new_url": "<new_url>",
  "referer": <referer>,
  "published": <published>
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new redirect's `id`, `old_url`, and `new_url` on success.

---

### update — Update an existing redirect

**Additional inputs:**

- `id` (required): Numeric ID of the redirect to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/redirects/<id>
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

### delete — Delete a redirect

> **Important:** Joomla requires a redirect to be trashed (`published = -2`) before it can be deleted. If the redirect is not already trashed, first run an `update` to set `published` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the redirect to delete.
- `force` (optional, boolean): If `true`, automatically trash the redirect first without asking.

**Process:**
1. Run `get` to check the current `published` value of the redirect.
2. If not trashed (`published != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the redirect to set `published: -2` (trash it).
4. DELETE the redirect.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/redirects/<id>
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
| `404` | Not Found | No redirect with that ID exists. |
| `422` | Unprocessable | Validation error (e.g. duplicate `old_url`); display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Redirects use the field name `published` (not `state`) for enabled/disabled status.
- The Redirect component (`com_redirect`) and the `plg_system_redirect` plugin must be installed and enabled.
- The `old_url` is typically a relative path. Joomla will match incoming requests against this path and issue the redirect.
- Use `301` (permanent) for moved pages and `302` (temporary) for short-term redirects.
