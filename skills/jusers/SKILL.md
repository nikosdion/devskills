---
name: jusers
description: Manage Joomla users, user groups, and viewing access levels via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting users, groups, and access levels. Only works on local development sites.
argument-hint: [site_path] [resource] [action] [options]
---

# Joomla Users Manager

Manage Joomla users, user groups, and viewing access levels through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `resource`: One of `users`, `groups`, `levels`.
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

## Resource: users

### list users

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by username, name, or email |
| `state` | int | `0`=blocked, `1`=active |
| `group` | int | Filter by user group ID |
| `range` | string | Date range filter |

**Request:**
```
GET <baseUrl>/api/index.php/v1/users[?filter[state]=1&filter[group]=2&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of users with their `id`, `name`, `username`, `email`, `block`, `registerDate`, and `lastvisitDate`.

---

### get user

**Additional inputs:**

- `id` (required): Numeric ID of the user to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/users/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full user details including `id`, `name`, `username`, `email`, `block`, `registerDate`, `lastvisitDate`, and `groups`.

---

### create user

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Full name |
| `username` | string | yes | Username (login name) |
| `email` | string | yes | Email address |
| `password` | string | yes | Initial password |
| `groups` | array of int | no | Array of group IDs to assign (e.g. `[2]` for Registered) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/users
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "name": "<name>",
  "username": "<username>",
  "email": "<email>",
  "password": "<password>",
  "groups": [<group_id>]
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new user's `id`, `name`, and `username` on success.

---

### update user

**Additional inputs:**

- `id` (required): Numeric ID of the user to update.
- One or more of the fields from create user (only include fields to change). Omit `password` if not changing it.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/users/<id>
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

### delete user

**Additional inputs:**

- `id` (required): Numeric ID of the user to delete.

> **Warning:** User deletion is immediate and permanent. There is no trash step for users. Confirm with the user before proceeding.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/users/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Confirm deletion success, or report the error.

---

## Resource: groups

### list groups

**Request:**
```
GET <baseUrl>/api/index.php/v1/users/groups
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of groups with their `id`, `title`, and `parent_id`.

---

### get group

**Additional inputs:**

- `id` (required): Numeric ID of the group to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/users/groups/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full group details including `id`, `title`, and `parent_id`.

---

### create group

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `title` | string | yes | — | Group name |
| `parent_id` | int | yes | `1` | Parent group ID (`1` = Public root) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/users/groups
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "parent_id": <parent_id>
}
```

**Output:** Report the new group's `id` and `title` on success.

---

### update group

**Additional inputs:**

- `id` (required): Numeric ID of the group to update.
- `title` (optional): New group name.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/users/groups/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>"
}
```

**Output:** Confirm the updated fields on success.

---

### delete group

**Additional inputs:**

- `id` (required): Numeric ID of the group to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/users/groups/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Confirm deletion success, or report the error.

---

## Resource: levels

Viewing access levels control which groups of users can view content assigned to each level.

### list levels

**Request:**
```
GET <baseUrl>/api/index.php/v1/users/levels
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of access levels with their `id`, `title`, and `rules` (array of group IDs with access).

---

### get level

**Additional inputs:**

- `id` (required): Numeric ID of the access level to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/users/levels/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full access level details including `id`, `title`, and `rules`.

---

### create level

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `title` | string | yes | Access level name |
| `rules` | array of int | yes | Array of group IDs that have access (e.g. `[1, 6, 7]`) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/users/levels
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "title": "<title>",
  "rules": [<group_id>, ...]
}
```

**Output:** Report the new access level's `id` and `title` on success.

---

### update level

**Additional inputs:**

- `id` (required): Numeric ID of the access level to update.
- `title` (optional): New level name.
- `rules` (optional): New array of group IDs.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/users/levels/<id>
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

### delete level

**Additional inputs:**

- `id` (required): Numeric ID of the access level to delete.

**Request:**
```
DELETE <baseUrl>/api/index.php/v1/users/levels/<id>
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
| `404` | Not Found | No resource with that ID exists. |
| `409` | Conflict | Username or email already in use; suggest alternatives. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Default Joomla group IDs: `1`=Public, `2`=Registered, `3`=Author, `4`=Editor, `5`=Publisher, `6`=Manager, `7`=Administrator, `8`=Super Users.
- Default access level IDs: `1`=Public, `2`=Registered, `3`=Special, `4`=Super Users.
- Never delete the Super Users group or remove all users from it, as this locks out all administrator access.
- User deletion is permanent with no undo. Always confirm with the user before deleting accounts.
