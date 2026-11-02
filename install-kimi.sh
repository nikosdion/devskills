#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="devskills"
OUTPUT="$SCRIPT_DIR/devskills.zip"
STAGING_ROOT="$HOME/.kimi-plugins"
STAGING_DIR="$STAGING_ROOT/$PLUGIN_NAME"
KIMI_HOME="${KIMI_CODE_HOME:-$HOME/.kimi-code}"
MANAGED_DIR="$KIMI_HOME/plugins/managed/$PLUGIN_NAME"

# ---------------------------------------------------------------------------
# Build devskills.zip (substitutes .env values into every SKILL.md), then
# extract it into a stable staging directory for Kimi Code to install from.
#
# Kimi Code copies local plugin installs into its managed plugin directory
# ($KIMI_CODE_HOME/plugins/managed/<id>/), so the plugin must be installed
# from a clean build output: the source tree's SKILL.md files still contain
# unsubstituted {{VARIABLE}} placeholders, and editing a directory after
# install has no effect anyway.
# ---------------------------------------------------------------------------
bash "$SCRIPT_DIR/package.sh"

mkdir -p "$STAGING_ROOT"
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR"
unzip -o -q "$OUTPUT" -d "$STAGING_DIR"

echo "Staged a clean copy of $PLUGIN_NAME at:"
echo "  $STAGING_DIR"
echo

# ---------------------------------------------------------------------------
# Print the TUI steps. There is no non-interactive CLI for plugin management;
# /plugins install inside Kimi Code performs the actual install (or update).
# ---------------------------------------------------------------------------
if [ -d "$MANAGED_DIR" ]; then
  echo "An installed copy already exists in Kimi Code's managed directory:"
  echo "  $MANAGED_DIR"
  echo "Kimi Code runs from that managed copy, so to pick up the re-staged"
  echo "version above reinstall the plugin, then reload:"
else
  echo "To install the plugin, run these inside Kimi Code (the TUI):"
fi

echo
echo "  /plugins install $STAGING_DIR"
echo "  /reload"
echo
echo "Keep the staging directory in place; do not delete it."
echo "After every edit here, re-run ./install-kimi.sh and repeat the two"
echo "commands above — reinstalling is how updates reach the managed copy."
