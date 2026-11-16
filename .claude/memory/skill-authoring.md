# Skill authoring conventions

Moved from `AGENTS.md`.


- Keep each `SKILL.md` concise, deterministic, and task-focused.
- Keep YAML frontmatter limited to `name` and `description`.
- The `description` frontmatter field is the trigger — be precise. Too broad and the skill fires
  spuriously; too narrow and it misses.
- When updating a skill, preserve product names and CLI identifiers exactly as required by that
  product.
- `{{VARIABLE}}` placeholders in `SKILL.md` files are substituted from `.env` by `package.sh` at build
  time — see `env.sample` for the full list. Add new variables to both `env.sample` and `package.sh`
  together.
- After adding, removing, or renaming a skill, update the skill catalog above so it keeps matching
  `skills/`.
