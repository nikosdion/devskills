#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_NAME="devskills"
OUTPUT="$SCRIPT_DIR/devskills.zip"
INSTALL_ROOT="$HOME/plugins"
INSTALL_DIR="$INSTALL_ROOT/$PLUGIN_NAME"
MARKETPLACE="$HOME/.agents/plugins/marketplace.json"

# ---------------------------------------------------------------------------
# Build devskills.zip (substitutes .env values into every SKILL.md).
# ---------------------------------------------------------------------------
bash "$SCRIPT_DIR/package.sh"

# ---------------------------------------------------------------------------
# Unzip into ~/plugins/devskills.
# ---------------------------------------------------------------------------
mkdir -p "$INSTALL_ROOT" "$(dirname "$MARKETPLACE")"
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
unzip -o "$OUTPUT" -d "$INSTALL_DIR"

MARKETPLACE="$MARKETPLACE" php -r '
$path = getenv("MARKETPLACE");
$data = file_exists($path)
    ? json_decode(file_get_contents($path), true, 512, JSON_THROW_ON_ERROR)
    : [
        "name" => "personal",
        "interface" => ["displayName" => "Personal"],
        "plugins" => [],
    ];

$entry = [
    "name" => "devskills",
    "source" => [
        "source" => "local",
        "path" => "./plugins/devskills",
    ],
    "policy" => [
        "installation" => "AVAILABLE",
        "authentication" => "ON_INSTALL",
    ],
    "category" => "Developer Tools",
];

$found = false;
foreach ($data["plugins"] as $index => $plugin) {
    if (($plugin["name"] ?? null) === $entry["name"]) {
        $data["plugins"][$index] = $entry;
        $found = true;
        break;
    }
}

if (!$found) {
    $data["plugins"][] = $entry;
}

file_put_contents(
    $path,
    json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES | JSON_THROW_ON_ERROR) . "\n"
);
'

codex plugin add "$PLUGIN_NAME@personal"

echo "Installed $PLUGIN_NAME for Codex. Start a new conversation to load it."
