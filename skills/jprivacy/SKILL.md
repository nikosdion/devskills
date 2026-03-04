---
name: jprivacy
description: Manage Joomla privacy requests and consents via the Joomla Web Services API. Supports listing, getting, creating privacy requests, exporting request data, and viewing consent records. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Privacy Manager

Manage Joomla privacy (GDPR) requests and user consent records through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list-requests`, `get-request`, `create-request`, `export-request`, `list-consents`, `get-consent`.
- Action-specific options (see per-action details below).

## Prerequisites

1. Use the `japitoken` skill to retrieve a valid API token for the site at `site_path`.
2. Determine the site's base URL using the same domain-detection logic as `japitoken` (virtual host config or directory-basename + `{{JOOMLA_SITE_DOMAIN}}`).
3. All API requests use:
   - `Authorization: Bearer <token>`
   - `Accept: application/vnd.api+json`
   - For POST: also `Content-Type: application/json`

## Safety Constraints

Inherits the same constraints as `japitoken`: only operates on local development sites (localhost, `*.{{JOOMLA_SITE_DOMAIN}}`, `*.local.web`, or under `{{JOOMLA_SITES_DIR}}`).

---

## Actions

### list-requests — List privacy requests

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `status` | string | Request status filter |

**Request:**
```
GET <baseUrl>/api/index.php/v1/privacy/requests[?filter[status]=1]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of privacy requests with their `id`, `email`, `request_type`, `status`, and `requested_at`.

---

### get-request — Get a single privacy request

**Additional inputs:**

- `id` (required): Numeric ID of the privacy request to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/privacy/requests/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full request details including `id`, `email`, `request_type`, `status`, `requested_at`, and `checked_out`.

---

### create-request — Create a new privacy request

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `email` | string | yes | Email address of the data subject |
| `request_type` | int | yes | Request type: `1`=export, `2`=remove |

**Request:**
```
POST <baseUrl>/api/index.php/v1/privacy/requests
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "email": "<email>",
  "request_type": <request_type>
}
```

**Output:** Report the new request's `id`, `email`, and `request_type` on success.

---

### export-request — Export privacy request data

Exports all data associated with a privacy request (for data export requests).

**Additional inputs:**

- `id` (required): Numeric ID of the privacy request to export.

**Request:**
```
GET <baseUrl>/api/index.php/v1/privacy/requests/export/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the exported data or save it to a file. Inform the user of the data returned.

---

### list-consents — List privacy consents

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `state` | int | Consent state filter |

**Request:**
```
GET <baseUrl>/api/index.php/v1/privacy/consents[?filter[state]=1]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of consent records with their `id`, `user_id`, `subject`, `body`, `state`, and `created`.

---

### get-consent — Get a single privacy consent record

**Additional inputs:**

- `id` (required): Numeric ID of the consent record to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/privacy/consents/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full consent details including `id`, `user_id`, `subject`, `body`, `state`, and `created`.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | No privacy request or consent with that ID exists. |
| `422` | Unprocessable | Validation error (e.g. invalid email or duplicate request); display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Privacy request types: `1`=data export request, `2`=data removal (right to be forgotten) request.
- The Privacy component must be installed and the `plg_system_privacyconsent` plugin enabled for this API to function.
- Handle exported personal data with care; do not display sensitive information unnecessarily.
