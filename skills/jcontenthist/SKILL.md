---
name: jcontenthist
description: Manage Joomla content article version history via the Joomla Web Services API. Supports listing history versions, toggling the keep flag, and deleting versions. Only works on local development sites.
argument-hint: [site_path] [article_id] [action] [options]
---

# Joomla Content History Manager

Manage version history of Joomla content articles through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `article_id`: Numeric ID of the article whose history you want to manage.
- `action`: One of `list`, `keep`, `delete`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Use the `japitoken` skill to retrieve a valid API token for the site at `site_path`.
2. Determine the site's base URL using the same domain-detection logic as `japitoken` (virtual host config or directory-basename + `{{JOOMLA_SITE_DOMAIN}}`).
3. All API requests use:
   - `Authorization: Bearer <token>`
   - `Accept: application/vnd.api+json`
   - For PATCH: also `Content-Type: application/json`

## Safety Constraints

Inherits the same constraints as `japitoken`: only operates on local development sites (localhost, `*.{{JOOMLA_SITE_DOMAIN}}`, `*.local.web`, or under `{{JOOMLA_SITES_DIR}}`).

---

## Actions

### list — List history versions for an article

**Additional inputs:** none (only `article_id` is required).

**Request:**
```
GET <baseUrl>/api/index.php/v1/content/articles/<article_id>/contenthistory
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display each history version with its `id`, `version_note`, `save_date`, `editor`, `character_count`, and whether the `keep_forever` flag is set.

---

### keep — Toggle the keep flag on a history version

Toggles the `keep_forever` flag on a specific history version. When enabled, the version is protected from automatic pruning by Joomla's history cleanup.

**Additional inputs:**

- `version_id` (required): Numeric ID of the history version to toggle.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/content/articles/<article_id>/contenthistory/<version_id>/keep
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Output:** Confirm the toggle was successful and report the new `keep_forever` state if returned by the API.

---

### delete — Delete a history version

Permanently removes a specific history version. This cannot be undone.

**Additional inputs:**

- `version_id` (required): Numeric ID of the history version to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/content/articles/<article_id>/contenthistory/<version_id>
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
| `404` | Not Found | No article or history version with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- The `version_id` values for history versions are separate from the `article_id`. Use the `list` action first to discover available version IDs.
- Versions with `keep_forever` set to `true` are protected from automatic cleanup. The `keep` action toggles this state on each call.
