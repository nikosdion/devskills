---
name: jmessages
description: Manage Joomla private messages via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, and deleting private messages between users. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Private Messages Manager

Manage Joomla private messages through the Joomla Web Services API on a local development site.

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

### list — List private messages

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `state` | int | `0`=unread, `1`=read, `-2`=trashed |

**Request:**
```
GET <baseUrl>/api/index.php/v1/messages[?filter[state]=0]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of messages with their `id`, `subject`, `user_id_from`, `user_id_to`, `date_time`, and `state`.

---

### get — Get a single private message

**Additional inputs:**

- `id` (required): Numeric ID of the message to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/messages/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full message details including `id`, `subject`, `message`, `user_id_from`, `user_id_to`, `date_time`, and `state`.

---

### create — Create (send) a new private message

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `user_id_to` | int | yes | Recipient user ID |
| `subject` | string | yes | Message subject |
| `message` | string | yes | Message body |

**Request:**
```
POST <baseUrl>/api/index.php/v1/messages
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "user_id_to": <user_id_to>,
  "subject": "<subject>",
  "message": "<message>"
}
```

**Output:** Report the new message's `id` and `subject` on success.

---

### update — Update a private message

**Additional inputs:**

- `id` (required): Numeric ID of the message to update.
- One or more of the following fields (only include fields to change):
  - `subject` (string): New message subject.
  - `message` (string): New message body.

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/messages/<id>
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

### delete — Delete a private message

> **Important:** Joomla requires a message to be trashed (`state = -2`) before it can be deleted. If the message is not already trashed, first run an `update` to set `state` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the message to delete.
- `force` (optional, boolean): If `true`, automatically trash the message first without asking.

**Process:**
1. Run `get` to check the current `state` value of the message.
2. If not trashed (`state != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the message to set `state: -2` (trash it).
4. DELETE the message.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/messages/<id>
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
| `404` | Not Found | No message with that ID exists. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Private messages are internal to the Joomla administrator backend (com_messages). They are not email messages.
- Use `jusers` to look up user IDs when you need to find a recipient.
