#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="devskills"
OUTPUT="$SCRIPT_DIR/devskills.zip"
INSTALL_DIR="$HOME/.qwen-plugins/$PLUGIN_NAME"

# ---------------------------------------------------------------------------
# Verify the manifest is present so we link the right directory.
# ---------------------------------------------------------------------------
if [ ! -f "$SCRIPT_DIR/qwen-extension.json" ]; then
  echo "qwen-extension.json not found in $SCRIPT_DIR" >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Build devskills.zip (substitutes .env values into every SKILL.md), then
# extract it into a stable install directory. We link this build output
# rather than the source tree directly, because the source tree's SKILL.md
# files still contain unsubstituted {{VARIABLE}} placeholders.
# ---------------------------------------------------------------------------
bash "$SCRIPT_DIR/package.sh"

mkdir -p "$HOME/.qwen-plugins"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT" -d "$INSTALL_DIR"

# ---------------------------------------------------------------------------
# Idempotent link: the rebuild above already refreshed the linked directory,
# so skip re-linking it. Linking again would trigger an interactive trust
# prompt on every run. Match on the absolute path because the display name
# ("Dev Skills") does not contain the internal id.
# ---------------------------------------------------------------------------
if qwen extensions list 2>/dev/null | grep -Fq "$INSTALL_DIR"; then
  echo "$PLUGIN_NAME is already linked for Qwen Code; refreshed $INSTALL_DIR."
  echo "Restart Qwen Code to pick up the changes."
  exit 0
fi

qwen extensions link "$INSTALL_DIR"

echo "Linked $PLUGIN_NAME for Qwen Code. Restart Qwen Code to load it."
echo "Rerun ./install-qwen.sh after every edit to refresh $INSTALL_DIR."
