#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/devskills.zip"
STAGING="$SCRIPT_DIR/.staging"

# ---------------------------------------------------------------------------
# Load .env (required); fall back to .env.sample with a warning.
# ---------------------------------------------------------------------------
if [[ -f "$SCRIPT_DIR/.env" ]]; then
  # shellcheck disable=SC1090
  source "$SCRIPT_DIR/.env"
elif [[ -f "$SCRIPT_DIR/env.sample" ]]; then
  echo "WARNING: .env not found; using env.sample values (dummy data)." >&2
  # shellcheck disable=SC1090
  source "$SCRIPT_DIR/env.sample"
else
  echo "ERROR: Neither .env nor env.sample found." >&2
  exit 1
fi

# Ensure every expected variable is set.
: "${MYSQL_ADMIN_USER:?MYSQL_ADMIN_USER must be set in .env}"
: "${MYSQL_ADMIN_PASSWORD:?MYSQL_ADMIN_PASSWORD must be set in .env}"
: "${AKEEBA_KS_DIR:?AKEEBA_KS_DIR must be set in .env}"
: "${JOOMLA_SITES_DIR:?JOOMLA_SITES_DIR must be set in .env}"
: "${JOOMLA_SITE_DOMAIN:?JOOMLA_SITE_DOMAIN must be set in .env}"
: "${JOOMLA_ADMIN_NAME:?JOOMLA_ADMIN_NAME must be set in .env}"
: "${JOOMLA_ADMIN_USERNAME:?JOOMLA_ADMIN_USERNAME must be set in .env}"
: "${JOOMLA_ADMIN_PASSWORD:?JOOMLA_ADMIN_PASSWORD must be set in .env}"
: "${JOOMLA_ADMIN_EMAIL:?JOOMLA_ADMIN_EMAIL must be set in .env}"

# ---------------------------------------------------------------------------
# Build a clean staging copy so the source tree is never modified.
# ---------------------------------------------------------------------------
rm -rf "$STAGING"
mkdir -p "$STAGING"
# Copy everything except the staging dir itself and generated artifacts.
rsync -a \
  --exclude "/.staging" \
  --exclude "/env.sample" \
  --exclude "/devskills.zip" \
  --exclude "/.env" \
  "$SCRIPT_DIR/" "$STAGING/"

# Substitute placeholders in every SKILL.md inside the staging copy.
find "$STAGING" -name "SKILL.md" | while IFS= read -r skill_file; do
  sed -i \
    -e "s|{{MYSQL_ADMIN_USER}}|${MYSQL_ADMIN_USER}|g" \
    -e "s|{{MYSQL_ADMIN_PASSWORD}}|${MYSQL_ADMIN_PASSWORD}|g" \
    -e "s|{{AKEEBA_KS_DIR}}|${AKEEBA_KS_DIR}|g" \
    -e "s|{{JOOMLA_SITES_DIR}}|${JOOMLA_SITES_DIR}|g" \
    -e "s|{{JOOMLA_SITE_DOMAIN}}|${JOOMLA_SITE_DOMAIN}|g" \
    -e "s|{{JOOMLA_ADMIN_NAME}}|${JOOMLA_ADMIN_NAME}|g" \
    -e "s|{{JOOMLA_ADMIN_USERNAME}}|${JOOMLA_ADMIN_USERNAME}|g" \
    -e "s|{{JOOMLA_ADMIN_PASSWORD}}|${JOOMLA_ADMIN_PASSWORD}|g" \
    -e "s|{{JOOMLA_ADMIN_EMAIL}}|${JOOMLA_ADMIN_EMAIL}|g" \
    "$skill_file"
done

# ---------------------------------------------------------------------------
# Zip from the staging directory.
# ---------------------------------------------------------------------------
rm -f "$OUTPUT"

cd "$STAGING"
zip -r "$OUTPUT" . \
  --exclude "./package.sh" \
  --exclude "./devskills.zip" \
  --exclude "./.gitignore" \
  --exclude "./.env" \
  --exclude "./.staging/*"

cd "$SCRIPT_DIR"
rm -rf "$STAGING"

echo "Created $OUTPUT"
