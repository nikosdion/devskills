---
name: jmedia
description: Manage Joomla media files and folders via the Joomla Web Services API. Supports listing adapters, listing files, getting, uploading, updating, and deleting media files. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Media Manager

Manage Joomla media files and folders through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list-adapters`, `get-adapter`, `list-files`, `get-file`, `upload`, `update`, `delete`.
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

### list-adapters — List media adapters

Lists the available media adapters (storage backends).

**Request:**
```
GET <baseUrl>/api/index.php/v1/media/adapters
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of adapters with their `id` and `display_name`.

---

### get-adapter — Get a specific media adapter

**Additional inputs:**

- `id` (required): Numeric ID of the adapter.

**Request:**
```
GET <baseUrl>/api/index.php/v1/media/adapters/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full adapter details.

---

### list-files — List media files

**Additional inputs (all optional):**

| Parameter | Type | Description |
|-----------|------|-------------|
| `path` | string | Subdirectory path relative to the media root (e.g. `images/sampledata`) |
| `adapter` | string | Media adapter name (defaults to local filesystem) |

**Request:**
```
GET <baseUrl>/api/index.php/v1/media/files[?path=images/sampledata]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of files and folders with their `name`, `path`, `type` (`file` or `dir`), `size`, and `mime_type`.

---

### get-file — Get a specific media file

**Additional inputs:**

- `path` (required): Full path to the file relative to the media root (e.g. `images/joomla_black.png`). Include it in the URL path.

**Request:**
```
GET <baseUrl>/api/index.php/v1/media/files/<path>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the file metadata including `name`, `path`, `size`, `mime_type`, and `width`/`height` for images.

---

### upload — Upload a new media file

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `path` | string | yes | Destination path including filename (e.g. `images/test.txt`) |
| `content` | string | yes | Base64-encoded file content |

**Request:**
```
POST <baseUrl>/api/index.php/v1/media/files
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "path": "<path>",
  "content": "<base64_encoded_content>"
}
```

**Process:** If the user provides a local file path, read the file and base64-encode its content before sending.

**Output:** Confirm the file was uploaded successfully with its path.

---

### update — Update (overwrite) a media file

**Additional inputs:**

- `path` (required): Full path of the file to update (e.g. `images/test.txt`). Include it in the URL path.
- `content` (required): Base64-encoded new file content.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/media/files/<path>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "content": "<base64_encoded_content>"
}
```

**Output:** Confirm the file was updated successfully.

---

### delete — Delete a media file

**Additional inputs:**

- `path` (required): Full path of the file to delete (e.g. `images/test.txt`). Include it in the URL path.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/media/files/<path>
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
| `404` | Not Found | No file at that path exists. |
| `422` | Unprocessable | Validation error (e.g. unsupported file type); display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- File content must be Base64-encoded when uploading or updating. Use `base64` command: `base64 -w 0 <file>`.
- The default media root is the `images/` directory under the Joomla site root.
- File paths in the URL must be URL-encoded if they contain special characters.
