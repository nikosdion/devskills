# Deploying changes to each host

Per-host installer details moved from `AGENTS.md`.

Edits here are NOT live until installed. Choose the host you are deploying to:

- **Claude Code** — run `./install-claude.sh`. This rebuilds `devskills.zip` (substituting your `.env`
  values into every `SKILL.md`), replaces `~/.claude-plugins/devskills/`, registers the plugin in the
  local marketplace, and reinstalls it. Then run `/reload-plugins` in Claude Code (or restart it).
- **Codex** — run `./install-codex.sh`. This rebuilds `devskills.zip`, installs a clean copy under
  `~/plugins/devskills/`, registers it in the personal marketplace, and installs it via the Codex CLI.
  Start a new Codex conversation to load it.
- **Qwen Code** — run `./install-qwen.sh`. This rebuilds `devskills.zip`, extracts it into
  `~/.qwen-plugins/devskills/`, and links that directory via `qwen extensions link`. Restart Qwen Code
  to pick up the link.
- **Kimi Code** — run `./install-kimi.sh`. This rebuilds `devskills.zip` and extracts it into
  `~/.kimi-plugins/devskills/`. Finish the install — and every update — in the Kimi Code TUI with
  `/plugins install ~/.kimi-plugins/devskills` followed by `/reload`: Kimi Code copies local installs
  into its managed plugin directory, and has no non-interactive plugin CLI.

All four installers call `bash package.sh` internally, so `.env` must exist (copy it from
`env.sample` first) before any of them will succeed.

**Bump the version in every manifest for every content change.** The Claude cache is keyed by
`.claude-plugin/plugin.json`; the Codex install mirrors whatever sits in `.codex-plugin/plugin.json`;
the Qwen Code manifest in `qwen-extension.json` is informational but documents the loaded release; the
Kimi Code managed copy is built from whatever sits in `kimi.plugin.json` at stage time. If any of them
does not change, the corresponding host keeps serving the previous version.

Building the plugin ZIP without installing it anywhere (e.g. for Claude Desktop's Cowork custom plugin
upload) is still just `bash package.sh` — see the README for that flow.
