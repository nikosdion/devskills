---
name: joomlaupdate
description: Manage Joomla core updates via the Joomla Web Services API. Supports health checks, checking for available updates, and orchestrating the update process. Only works on local development sites.
argument-hint: [site_path] [action]
---

# Joomla Update Manager

Manage Joomla core updates through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `healthcheck`, `check`, `update`, `notify-success`, `notify-failed`.

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

### healthcheck — Check site health

Verifies that the Joomla Update API is accessible and the site is operational.

**Request:**
```
GET <baseUrl>/api/index.php/v1/joomlaupdate/healthcheck
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Report the health status returned by the API.

---

### check — Get available update information

Retrieves information about the available Joomla update (if any).

**Request:**
```
GET <baseUrl>/api/index.php/v1/joomlaupdate/update
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display whether an update is available, and if so, the target version number and download URL.

---

### update — Perform the Joomla core update

Orchestrates the two-step update process: prepare then finalize.

> **Warning:** This will update the Joomla core installation. Back up the site before proceeding.

**Step 1 — Prepare update:**
```
POST <baseUrl>/api/index.php/v1/joomlaupdate/update/prepare
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Step 2 — Finalize update:**
```
POST <baseUrl>/api/index.php/v1/joomlaupdate/update/finalize
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Process:**
1. Run `check` first to confirm an update is available and inform the user of the target version.
2. Ask the user for confirmation before proceeding (unless `force` is set).
3. POST to `/prepare` and verify the response indicates success.
4. POST to `/finalize` and verify the response indicates success.
5. Report the completed update version.

**Output:** Confirm successful update completion with the new Joomla version.

---

### notify-success — Send update success notification

Sends a success notification email after a completed update.

**Request:**
```
POST <baseUrl>/api/index.php/v1/joomlaupdate/update/notify/success
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Output:** Confirm the notification was sent.

---

### notify-failed — Send update failure notification

Sends a failure notification email when an update has failed.

**Request:**
```
POST <baseUrl>/api/index.php/v1/joomlaupdate/update/notify/failed
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json
```

**Output:** Confirm the notification was sent.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `500` | Server Error | Update process failed; display the error message and advise restoring from backup. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract relevant data from the response body.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Always run a backup before performing a Joomla core update.
- The update process must be done in order: `prepare` then `finalize`. Do not skip steps.
