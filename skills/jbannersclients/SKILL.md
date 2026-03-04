---
name: jbannersclients
description: Manage Joomla banner clients via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting banner clients. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Banner Clients Manager

Manage Joomla banner clients through the Joomla Web Services API on a local development site.

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

### list — List banner clients

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by client name |
| `state` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |

**Request:**
```
GET <baseUrl>/api/index.php/v1/banners/clients[?filter[state]=1&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of clients with their `id`, `name`, `contact`, `email`, and `state`.

---

### get — Get a single banner client

**Additional inputs:**

- `id` (required): Numeric ID of the client to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/banners/clients/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full client details including `id`, `name`, `contact`, `email`, `state`, `metakey`, and `metadesc`.

---

### create — Create a new banner client

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Client/company name |
| `contact` | string | no | — | Contact person name |
| `email` | string | no | — | Contact email address |
| `state` | int | no | `1` | `0`=unpublished, `1`=published |
| `metakey` | string | no | `""` | Meta keywords for banners |
| `metadesc` | string | no | `""` | Meta description |

**Request:**
```
POST <baseUrl>/api/index.php/v1/banners/clients
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "name": "<name>",
  "contact": "<contact>",
  "email": "<email>",
  "state": <state>
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new client's `id` and `name` on success.

---

### update — Update an existing banner client

**Additional inputs:**

- `id` (required): Numeric ID of the client to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/banners/clients/<id>
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

### delete — Delete a banner client

> **Important:** Joomla requires a banner client to be trashed (`state = -2`) before it can be deleted. If the client is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the client to delete.
- `force` (optional, boolean): If `true`, automatically trash the client first without asking.

**Process:**
1. Run `get` to check the current `state` value of the client.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the client to set `state: -2` (trash it).
4. DELETE the client.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/banners/clients/<id>
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
| `404` | Not Found | No client with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
