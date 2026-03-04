---
name: jnewsfeeds
description: Manage Joomla newsfeeds via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting newsfeeds. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Newsfeeds Manager

Manage Joomla newsfeeds through the Joomla Web Services API on a local development site.

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

### list — List newsfeeds

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by newsfeed name |
| `published` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `category` | int | Filter by category ID |
| `language` | string | Language code or `*` for all |

**Request:**
```
GET <baseUrl>/api/index.php/v1/newsfeeds/feeds[?filter[published]=1&filter[category]=5&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of newsfeeds with their `id`, `name`, `alias`, `published`, `catid`, `link`, and `language`.

---

### get — Get a single newsfeed

**Additional inputs:**

- `id` (required): Numeric ID of the newsfeed to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/newsfeeds/feeds/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full newsfeed details including `id`, `name`, `alias`, `published`, `catid`, `link`, `language`, `numarticles`, and `cache_time`.

---

### create — Create a new newsfeed

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Newsfeed name |
| `alias` | string | no | auto-generated | URL alias (slug) |
| `link` | string | yes | — | URL of the RSS/Atom feed |
| `catid` | int | no | — | Category ID |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |
| `numarticles` | int | no | `5` | Number of articles to display from the feed |
| `cache_time` | int | no | `3600` | Cache duration in seconds |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/newsfeeds/feeds
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "name": "<name>",
  "link": "<link>",
  "catid": <catid>,
  "published": <published>,
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new newsfeed's `id`, `name`, and `alias` on success.

---

### update — Update an existing newsfeed

**Additional inputs:**

- `id` (required): Numeric ID of the newsfeed to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/newsfeeds/feeds/<id>
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

### delete — Delete a newsfeed

> **Important:** Joomla requires a newsfeed to be trashed (`published = -2`) before it can be deleted. If the newsfeed is not already trashed, first run an `update` to set `published` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the newsfeed to delete.
- `force` (optional, boolean): If `true`, automatically trash the newsfeed first without asking.

**Process:**
1. Run `get` to check the current `published` value of the newsfeed.
2. If not trashed (`published != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the newsfeed to set `published: -2` (trash it).
4. DELETE the newsfeed.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/newsfeeds/feeds/<id>
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
| `404` | Not Found | No newsfeed with that ID exists. |
| `409` | Conflict | Alias already in use; suggest a different alias. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Newsfeeds use the field name `published` (not `state`) for publication status.
- Use `jnewsfeedscat` to manage newsfeed categories.
