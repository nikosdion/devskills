---
name: installjoomla
description: Download and install Joomla CMS 5+ into a local directory, selecting the closest matching stable release from Joomla GitHub releases, provisioning local MySQL defaults when missing, running CLI installation, and verifying frontend access on the corresponding *.akeeba.dev hostname.
argument-hint: [version]
---

# Joomla Local Install

Install Joomla 5 or later on localhost for development/testing.

## Inputs

- `target_dir`: Install directory path or bare name.
- `requested_version` (optional): Version constraint (examples: `6`, `6.0`, `6.0.2`).
- `site_name` (optional)
- `admin_name` (optional)
- `admin_username` (optional)
- `admin_password` (optional)
- `admin_email` (optional)
- Database connection fields (optional): `db_type`, `db_host`, `db_user`, `db_pass`, `db_name`, `db_prefix`, `db_encryption`, SSL options.
- `allow_prerelease` (optional): Only true when explicitly requested by the user.

## Defaults

- If `target_dir` is a bare name (no `/`), install to `~/Sites/<name>`.
- If `site_name` is missing, use the directory basename.
- If admin fields are missing, use:
- `admin_name`: `Nicholas K. Dionysopoulos`
- `admin_username`: `nicholas`
- `admin_password`: `B1ftekiP@tates`
- `admin_email`: `nicholas@akeeba.com`
- If DB fields are missing, create and use a local MySQL DB/user using the `mysql` skill in this plugin with the directory basename as input.
- `db_type`: `mysqli`
- `db_host`: `localhost`
- `db_user`: `<basename>`
- `db_pass`: `<basename>`
- `db_name`: `<basename>`

## Release Selection Rules

1. Resolve releases from GitHub:
- `https://api.github.com/repos/joomla/joomla-cms/releases`
2. Keep only tags with major version `>= 5`.
3. Unless explicitly requested, exclude prerelease builds:
- GitHub `prerelease == true`
- Tags containing `alpha`, `beta`, or `rc` (case-insensitive)
4. Select the closest matching version:
- If exact (`6.0.2`) is requested, use exact tag match.
- If partial (`6.0`) is requested, use highest patch in `6.0.x`.
- If major only (`6`) is requested, use highest `6.x.y`.
- If no version is requested, use the latest stable release `>= 5`.
5. If no valid stable release is available for the request, stop and report the mismatch.

## Download and Extract

1. Pick asset file in this order:
- `*.tar.zst` (preferred)
- `*.tar.gz` (fallback)
2. Create target directory.
3. Download selected archive to a temp location.
4. Extract archive into target directory.
5. Ensure Joomla files are at the target root and include `installation/joomla.php`.

## Database Provisioning

If the user did not provide DB connection details, invoke the local `mysql` skill with the directory basename to recreate:

- Database `<basename>` with `utf8mb4` and `utf8mb4_unicode_ci`
- User `'<basename>'@'localhost'` with password `<basename>`
- Grants on `<basename>.*`

## Joomla CLI Installation

Run from Joomla root:

```bash
php installation/joomla.php install \
  --site-name="<site_name>" \
  --admin-user="<admin_name>" \
  --admin-username="<admin_username>" \
  --admin-password="<admin_password>" \
  --admin-email="<admin_email>" \
  --db-type="<db_type>" \
  --db-host="<db_host>" \
  --db-user="<db_user>" \
  --db-pass="<db_pass>" \
  --db-name="<db_name>" \
  --no-interaction
```

Add DB options only when explicitly provided or required (`--db-prefix`, encryption, SSL options, `--public-folder`).

## Frontend Verification

1. Compute hostname from directory basename: `https://<basename>.akeeba.dev`
2. Verify the site responds (for example with `curl -k -I`), expecting an HTTP success or redirect status.
3. Report the final URL checked and status code.

## Constraints

- Install only Joomla version 5 or later.
- Do not install alpha/beta/RC unless explicitly requested.
- Use only for local development/testing on localhost environments.
