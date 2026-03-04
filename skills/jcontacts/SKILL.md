---
name: jcontacts
description: Manage Joomla contacts via the Joomla Web Services API. Supports listing, filtering, getting, creating, updating, deleting contacts, and submitting contact forms. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Contacts Manager

Manage Joomla contacts through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `get`, `create`, `update`, `delete`, `submit-form`.
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

### list — List contacts

**Additional inputs (all optional):**

| Filter | Type | Description |
|--------|------|-------------|
| `search` | string | Search by contact name |
| `published` | int | `0`=unpublished, `1`=published, `2`=archived, `-2`=trashed |
| `category` | int | Filter by category ID |
| `language` | string | Language code or `*` for all |

**Request:**
```
GET <baseUrl>/api/index.php/v1/contacts[?filter[published]=1&filter[category]=4&...]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

Append filters as query parameters using the `filter[<name>]` format.

**Output:** Display the list of contacts with their `id`, `name`, `alias`, `published`, `catid`, `email_to`, and `language`.

---

### get — Get a single contact

**Additional inputs:**

- `id` (required): Numeric ID of the contact to retrieve.

**Request:**
```
GET <baseUrl>/api/index.php/v1/contacts/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display full contact details including `id`, `name`, `alias`, `published`, `catid`, `email_to`, `address`, `suburb`, `state`, `postcode`, `country`, `telephone`, `language`, and `misc`.

---

### create — Create a new contact

**Additional inputs:**

| Field | Type | Required | Default | Description |
|-------|------|----------|---------|-------------|
| `name` | string | yes | — | Contact name |
| `alias` | string | no | auto-generated | URL alias (slug) |
| `catid` | int | no | — | Category ID |
| `published` | int | no | `1` | `0`=unpublished, `1`=published |
| `email_to` | string | no | — | Contact email address |
| `language` | string | no | `*` | Language code or `*` for all |
| `address` | string | no | `""` | Street address |
| `suburb` | string | no | `""` | Suburb/city |
| `postcode` | string | no | `""` | Postcode/ZIP |
| `country` | string | no | `""` | Country |
| `telephone` | string | no | `""` | Telephone number |
| `misc` | string | no | `""` | Additional information (HTML allowed) |
| `access` | int | no | `1` | Access level ID (`1`=Public) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/contacts
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "name": "<name>",
  "alias": "<alias>",
  "catid": <catid>,
  "published": <published>,
  "email_to": "<email_to>",
  "language": "<language>"
}
```

Include only the fields provided by the user; omit optional fields if not specified.

**Output:** Report the new contact's `id`, `name`, and `alias` on success.

---

### update — Update an existing contact

**Additional inputs:**

- `id` (required): Numeric ID of the contact to update.
- One or more of the fields from the `create` action (only include fields to change).

**Request:**
```
PATCH <baseUrl>/api/index.php/v1/contacts/<id>
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

### delete — Delete a contact

> **Important:** Joomla requires a contact to be trashed (`published = -2`) before it can be deleted. If the contact is not already trashed, first run an `update` to set `published` to `-2`, then proceed with deletion.

**Additional inputs:**

- `id` (required): Numeric ID of the contact to delete.
- `force` (optional, boolean): If `true`, automatically trash the contact first without asking.

**Process:**
1. Run `get` to check the current `published` value of the contact.
2. If not trashed (`published != -2`):
   - Without `force`: inform the user and ask for confirmation before trashing.
   - With `force`: proceed silently.
3. PATCH the contact to set `published: -2` (trash it).
4. DELETE the contact.

**Delete request:**
```
DELETE <baseUrl>/api/index.php/v1/contacts/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Confirm deletion success, or report the error.

---

### submit-form — Submit a contact form

**Additional inputs:**

- `id` (required): Numeric ID of the contact whose form to submit.
- `contact_name` (required): Sender's name.
- `contact_email` (required): Sender's email address.
- `contact_subject` (required): Message subject.
- `contact_message` (required): Message body.

**Request:**
```
POST <baseUrl>/api/index.php/v1/contacts/form/<id>
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "contact_name": "<contact_name>",
  "contact_email": "<contact_email>",
  "contact_subject": "<contact_subject>",
  "contact_message": "<contact_message>"
}
```

**Output:** Confirm the form was submitted successfully.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `404` | Not Found | No contact with that ID exists. |
| `409` | Conflict | Alias already in use; suggest a different alias. |
| `422` | Unprocessable | Validation error; display the API error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data.attributes` object for individual items and `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Contacts use the field name `published` (not `state`) for publication status.
