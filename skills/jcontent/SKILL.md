---
name: jcontent
description: Manage Joomla content articles via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting articles. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Content Articles Manager

Manage Joomla content articles through the Joomla Web Services API on a local development site.

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

### list — List articles

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by article title |
| `state` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `category` | int | Filter by category ID |
| `author` | int | Filter by author user ID |
| `featured` | int | `0`=non-featured, `1`=featured |
| `tag` | int | Filter by tag ID |
| `language` | string | Language code or `*` for all languages |
| `ordering` | string | Field to sort by (e.g. `title`, `id`, `created`) |
| `direction` | string | Sort direction: `asc` or `desc` |

**Request:**
```
GET <baseUrl>/api/index.php/v1/content/articles[?filter[state]=1&filter[category]=2&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format and ordering as `list[ordering]` / `list[direction]`.

**Output:** Display the list of articles with their `id`, `title`, `alias`, `state`, `catid`, `language`, and `created` date.

---

### get — Get a single article

**Additional inputs:**

- `id` (required): Numeric ID of the article to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/content/articles/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the full article details including `id`, `title`, `alias`, `state`, `catid`, `language`, `introtext`, `fulltext`, `created`, and `modified`.

---

### create — Create a new article

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Article title |
| `alias` | string | no | auto-generated | URL alias (slug) |
| `articletext` | string | no | `""` | Full article body. Separate intro and full text with `<hr id="system-readmore">` |
| `catid` | int | no | `2` | Category ID (`2` = Uncategorised) |
| `state` | int | no | `1` | `0`=unpublished, `1`=published |
| `language` | string | no | `*` | Language code or `*` for all |
| `featured` | int | no | `0` | `0`=not featured, `1`=featured |
| `access` | int | no | `1` | Access level ID (`1`=Public) |
| `image_intro` | string | no | — | Path to intro image (relative to site root) |
| `image_intro_alt` | string | no | `""` | Alt text for intro image |
| `image_fulltext` | string | no | — | Path to full-text image (relative to site root) |
| `image_fulltext_alt` | string | no | `""` | Alt text for full-text image |

**Request:**
```
POST <baseUrl>/api/index.php/v1/content/articles
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "alias": "<alias>",
  "articletext": "<body>",
  "catid": <catid>,
  "state": <state>,
  "language": "<language>",
  "images": {
    "image_intro": "<image_intro>",
    "image_intro_alt": "<image_intro_alt>"
  }
}
```

Include only the fields provided by the user; omit optional fields if not specified. Only include the `images` object if at least one image field is provided.

**Output:** Report the new article's `id`, `title`, and `alias` on success.

---

### update — Update an existing article

**Additional inputs:**

- `id` (required): Numeric ID of the article to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/content/articles/<id>
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

### delete — Delete an article

> **Important:** Joomla requires an article to be trashed (`state = -2`) before it can be deleted. If the article is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the article to delete.
- `force` (optional, boolean): If `true`, automatically trash the article first without asking.

**Process:**
1. Run `get` to check the current `state` value of the article.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the article to set `state: -2` (trash it).
4. DELETE the article.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/content/articles/<id>
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
| `404` | Not Found | No article with that ID exists. |
| `409` | Conflict | Alias already in use; suggest a different alias. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- The `articletext` field combines intro text and full text. Use `<hr id="system-readmore">` as a separator; everything before it is the intro text shown in list views, everything after is the full article text shown on the article page.
- The `images` field is a JSON object nested within the request body. Only include fields that are provided; an empty `images` object should be omitted entirely.
