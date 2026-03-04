---
name: jlangpackages
description: List and install Joomla language packages via the Joomla Web Services API. Only works on local development sites.
argument-hint: [site_path] [action] [options]
---

# Joomla Language Packages Manager

List and install Joomla language packages through the Joomla Web Services API on a local development site.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `action`: One of `list`, `install`.
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

### list — List available language packages

Lists language packages available for installation from the Joomla Language Registry.

**Additional inputs (all optional):**

| Parameter | Type | Description |
|-----------|------|-------------|
| `page_limit` | int | Number of results per page (default: 20) |
| `page_start` | int | Offset for pagination (default: 0) |

**Request:**
```
GET <baseUrl>/api/index.php/v1/languages[?page[limit]=20&page[start]=0]
Authorization: Bearer <token>
Accept: application/vnd.api+json
```

**Output:** Display the list of available language packages with their `language`, `name`, `nativeName`, and `version`.

---

### install — Install a language package

Downloads and installs a language package from the Joomla Language Registry.

**Additional inputs:**

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `package` | string | yes | BCP 47 language code of the package to install (e.g. `fr-FR`, `de-DE`) |

**Request:**
```
POST <baseUrl>/api/index.php/v1/languages
Authorization: Bearer <token>
Accept: application/vnd.api+json
Content-Type: application/json

{
  "package": "<lang_code>"
}
```

**Output:** Confirm the language package was installed successfully, including the installed language code and version.

---

## Error Handling

| HTTP Status | Meaning | Action |
|-------------|---------|--------|
| `401` | Unauthorized | Token may be expired or invalid; re-run `japitoken` and retry. |
| `403` | Forbidden | The authenticated user lacks permission for this operation. |
| `422` | Unprocessable | Invalid language code or package not found; display the API error message. |
| `500` | Server Error | Installation failed (e.g. network issue downloading the package); display the error message. |

Always display the full API error message from the response body when a request fails.

## Notes

- The Joomla API returns JSON:API format. Extract data from the `data[]` array for lists.
- Use `curl` for HTTP requests unless another HTTP client is available.
- Language packages provide interface translations (backend and frontend UI). They are separate from content languages — use `jlangcontent` to enable a content language after installing its package.
- The site must have internet access to download language packages from the Joomla Language Registry.
- After installation, the language is available in the Language Manager but must be enabled as a content language separately if needed for multilingual content.
