---
name: jlangoverrides
description: Manage Joomla language string overrides via the Joomla Web Services API. Supports listing, getting, creating, updating, and deleting overrides for both site and administrator applications. Only works on local development sites.
argument-hint: [site_path] [app] [lang_code] [action] [options]
---

# Joomla Language Overrides Manager

Manage Joomla language string overrides through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `app`: Application scope — `site` or `administrator`.
- `lang_code`: Language code (e.g. `en-GB`, `fr-FR`).
- `action`: One of `list`, `get`, `create`, `update`, `delete`, `search`, `refresh-cache`.
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

### list — List language overrides

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by language key or override value |

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages/overrides/<app>/<lang_code>[?filter[search]=submit]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of overrides with their `key` and `override` value.

---

### get — Get a single language override

**Additional inputs:**

- `key` (required): The language constant key (e.g. `COM_CONTENT_SAVE_SUCCESS`).

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages/overrides/<app>/<lang_code>/<key>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the override `key` and its `override` value.

---

### create — Create a new language override

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `key` | string | yes | Language constant key (uppercase, e.g. `MY_CUSTOM_STRING`) |
| `override` | string | yes | The replacement string value |

**Request:**
```
POST <baseUrl>/api/index.php/v1/languages/overrides/<app>/<lang_code>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "key": "<key>",
  "override": "<override>"
}
```

**Output:** Confirm the override was created with the `key` and `override` value.

---

### update — Update an existing language override

**Additional inputs:**

- `key` (required): The language constant key to update.
- `override` (required): The new replacement string value.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/languages/overrides/<app>/<lang_code>/<key>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "override": "<override>"
}
```

**Output:** Confirm the updated override value on success.

---

### delete — Delete a language override

**Additional inputs:**

- `key` (required): The language constant key to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/languages/overrides/<app>/<lang_code>/<key>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Confirm deletion success, or report the error.

---

### search — Search language strings for creating overrides

Search existing language strings to find the correct constant key to override.

**Additional inputs:**

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `language` | string | yes | Language code (e.g. `en-GB`) |
| `searchstring` | string | yes | String to search for |
| `searchtype` | string | yes | `constant` (search by key) or `value` (search by string content) |

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages/overrides/search?filter[language]=<language>&filter[searchstring]=<searchstring>&filter[searchtype]=<searchtype>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the matching language constants and their values.

---

### refresh-cache — Refresh language override search cache

Refreshes the cache used by the `search` action. Run this after installing new extensions to ensure the search index is up to date.

**Request:**
```
POST <baseUrl>/api/index.php/v1/languages/overrides/search/cache/refresh
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Output:** Confirm the cache was refreshed.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | No override with that key exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Language constant keys are conventionally uppercase with underscores (e.g. `COM_CONTENT_SAVE_SUCCESS`).
- Overrides are stored in `language/overrides/<lang_code>.override.ini` in the respective application directory.
- Changes take effect immediately without needing to clear the Joomla cache.
