# QWEN.md

This file provides guidance to Qwen Code when working with code in this repository.

## Deploying changes

Edits here are NOT live until Qwen Code is restarted. Run:

```bash
./install-qwen.sh
```

This rebuilds `devskills.zip` (substituting your `.env` values into every `SKILL.md`), extracts it into
`~/.qwen-plugins/devskills/`, and links that directory into Qwen Code's extensions via
`qwen extensions link`. Because the linked directory is a build output rather than this source tree,
you must rerun `./install-qwen.sh` after every edit — plain `qwen extensions link` on the repo itself
would expose the raw unsubstituted `{{VARIABLE}}` placeholders.

**Bump `version` in `qwen-extension.json` for every content change.** The version is informational
metadata that documents which release of the plugin is loaded; it does not gate caching.

Requires `.env` to exist first (`cp env.sample .env`, then fill in your values) — `install-qwen.sh`
calls `bash package.sh`, which fails without it.

## Skill authoring conventions

See `CLAUDE.md` for the full skill catalog and authoring conventions (frontmatter rules, `{{VARIABLE}}`
placeholder substitution, `jcli*` vs `j*` skill selection). They apply identically here.
