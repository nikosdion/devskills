---
name: jlangcontent
description: Manage Joomla content languages via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting content languages. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Content Languages Manager

Manage Joomla content languages through the Joomla Web Services API on a local development site.

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

### list — List content languages

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `published` | int | `0`=unpublished, `1`=published |

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages/content[?filter[published]=1]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of content languages with their `id`, `lang_code`, `title`, `title_native`, `sef`, `image`, and `published`.

---

### get — Get a single content language

**Additional inputs:**

- `id` (required): Numeric ID of the content language to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages/content/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full content language details including `id`, `lang_code`, `title`, `title_native`, `sef`, `image`, `published`, `access`, and `description`.

---

### create — Create a new content language

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `lang_code` | string | yes | — | BCP 47 language code (e.g. `fr-FR`) |
| `title` | string | yes | — | Language title in English (e.g. `French (France)`) |
| `title_native` | string | yes | — | Language title in the native language (e.g. `Français (France)`) |
| `sef` | string | yes | — | SEF URL prefix (e.g. `fr`) |
| `image` | string | no | — | Flag image code (e.g. `fr_fr`), used for language flags |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `access` | int | no | `1` | Access level ID (`1`=Public) |
| `description` | string | no | `""` | Language description |

**Request:**
```
POST <baseUrl>/api/index.php/v1/languages/content
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "lang_code": "<lang_code>",
  "title": "<title>",
  "title_native": "<title_native>",
  "sef": "<sef>",
  "image": "<image>",
  "published": <published>
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new content language's `id`, `lang_code`, and `title` on success.

---

### update — Update an existing content language

**Additional inputs:**

- `id` (required): Numeric ID of the content language to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/languages/content/<id>
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

### delete — Delete a content language

**Additional inputs:**

- `id` (required): Numeric ID of the content language to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/languages/content/<id>
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
| `404` | Not Found | No content language with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Content languages are separate from language packages (interface translation files). Use `jlangpackages` to install translation packages.
- The `sef` field must be unique per language and is used as the URL prefix in multilingual sites (e.g. `/fr/` for French).
