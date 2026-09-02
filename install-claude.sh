#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="devskills"
OUTPUT="$SCRIPT_DIR/devskills.zip"
INSTALL_DIR="$HOME/.claude-plugins/$PLUGIN_NAME"

# ---------------------------------------------------------------------------
# Build devskills.zip (substitutes .env values into every SKILL.md).
# ---------------------------------------------------------------------------
bash "$SCRIPT_DIR/package.sh"

# ---------------------------------------------------------------------------
# Unzip into ~/.claude-plugins.
# ---------------------------------------------------------------------------
mkdir -p ~/.claude-plugins 2>/dev/null
rm -rf "$INSTALL_DIR" 2>/dev/null
# Note: do NOT pipe `yes` into unzip. When unzip exits, `yes` dies of SIGPIPE,
# which under `set -o pipefail` makes the pipeline return 141 and `set -e`
# aborts the script before the marketplace registration below ever runs.
unzip -o "$OUTPUT" -d "$INSTALL_DIR"

# ---------------------------------------------------------------------------
# Ensure ~/.claude-plugins/marketplace.json exists.
# ---------------------------------------------------------------------------
MARKETPLACE="$HOME/.claude-plugins/.claude-plugin/marketplace.json"

if [ ! -f "$MARKETPLACE" ]; then
  cat > "$MARKETPLACE" <<'EOF'
{
  "name": "local",
  "owner": { "name": "Niko" },
  "plugins": [
  ]
}
EOF
fi

# ---------------------------------------------------------------------------
# Ensure ~/.claude-plugins/marketplace.json contains this plugin.
# ---------------------------------------------------------------------------

php -r '
$path = getenv("HOME") . "/.claude-plugins/.claude-plugin/marketplace.json";
$data = json_decode(file_get_contents($path), true);

$entry = [
  "name"        => "devskills",
  "source"      => "./devskills",
  "description" => "Development skills for local Joomla and WordPress workflow automation",
];

$found = false;
foreach ($data["plugins"] as $plugin) {
  if ($plugin["name"] === $entry["name"]) {
    $found = true;
    break;
  }
}

if (!$found) {
  $data["plugins"][] = $entry;
  file_put_contents($path, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n");
  echo "Added devskills to marketplace.json\n";
} else {
  echo "devskills already present in marketplace.json\n";
}
'

# ---------------------------------------------------------------------------
# Remove and re-add the local marketplace.
#
# This works around a known bug in Claude Code which prevents it from
# updating local marketplaces.
# ---------------------------------------------------------------------------
claude plugin marketplace add ~/.claude-plugins
claude plugin marketplace update local
claude plugin install devskills@local
# `install` is a no-op once the plugin is installed, and the plugin cache is keyed
# by the version in .claude-plugin/plugin.json — so bump that version whenever you
# change plugin content, and let `update` pull the new version into the cache.
# Without this the cache keeps serving the previously installed version forever.
claude plugin update devskills@local

echo "Installed $PLUGIN_NAME for Claude Code. Run /reload-plugins or restart Claude Code."
