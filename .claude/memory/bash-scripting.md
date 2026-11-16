# Bash scripting: environment-specific command variants

When a bash command needs different flags depending on the environment (e.g. BSD vs GNU), store the command and its variant arguments in a bash array set once via an `if`/`else` block, then expand it with `"${ARRAY[@]}"` at the call site.

**Why:** This is how the operator writes environmental conditionals by hand. It avoids `eval`, keeps the call site clean, and is immediately readable to anyone who knows bash. Never use `perl` or other languages as a cross-platform workaround when bash itself can express the intent clearly.

**How to apply:** Any time a shell command in `package.sh`, the `install-*.sh` scripts or a skill requires different flags on macOS (BSD) vs Linux (GNU) — or any other environmental split — reach for this array pattern rather than duplicating the full command in each branch or switching to a different tool.
