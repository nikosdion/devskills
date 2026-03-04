# Local development skills

A small set of agentic AI skills I use for local development.

> [!WARNING]
> These skills are meant for **local development** only. They are NOT secure; quite the opposite.

These skills can be used as a **Claude plugin** — both with Claude Code (as local skills) and with Claude Desktop (via the Cowork feature).

## Skills and Usage Examples

### `mysql`
Create or reset a local MySQL database and a matching local user with the same name and password.
- **Example:** "Create a local database named `mytest`"
- **Action:** Provisions database `mytest`, creates user `'mytest'@'localhost'` with password `mytest`, and grants all privileges.

### `joomla`
Download and install a specific or the latest stable version of Joomla 5+ into a local directory.
- **Example:** "Install Joomla 5 in `~/Sites/joomlatest`"
- **Example:** "Install Joomla 6.0.2 in `mysite`" (will be installed in `~/Sites/mysite`)
- **Action:** Downloads Joomla, extracts it, provisions a matching database (if not provided), and runs the CLI installation.

### `backup`
Take a backup of a local Joomla or WordPress site using Akeeba Backup.
- **Example:** "Take a backup of the site in `/var/www/html/mysite`"
- **Example:** "Run a backup for `~/Sites/joomlatest` using profile ID 2"
- **Action:** Detects the CMS, verifies Akeeba Backup, and runs the CLI backup command.

### `restore`
Restore a Joomla or WordPress site from an Akeeba Backup archive using Akeeba Kickstart.
- **Example:** "Restore `site-backup.jpa` into `~/Sites/restoredsite`"
- **Action:** Extracts the archive using Kickstart, provisions a database (if not provided), and runs the restoration script.

### `unblock`
Unblock localhost access (`127.0.0.1` and `::1`) in Admin Tools for Joomla or WordPress.
- **Example:** "Unblock me in `/var/www/html/mysite`"
- **Action:** Runs the Admin Tools CLI unblock commands for both IPv4 and IPv6 localhost addresses.

### `japitoken`
Retrieve a valid Joomla API token from a local development site.
- **Example:** "Get a Joomla API token for `~/Sites/joomlatest`"
- **Action:** Safely executes a script on the local site to retrieve an active Super User's API token.

---

## Configuration: the `.env` file

Before building the plugin, copy `env.sample` to `.env` and fill in your own values:

```bash
cp env.sample .env
```

The `.env` file is used by `package.sh` to substitute placeholders in the skill definitions at build time, so the generated plugin contains your actual settings.

### `.env` variables

| Variable | Description |
| --- | --- |
| `MYSQL_ADMIN_USER` | Username for an admin-capable MySQL/MariaDB account used to create databases and users. This is usually (but not necessarily) the `root` account. |
| `MYSQL_ADMIN_PASSWORD` | Password for the admin-capable MySQL/MariaDB account above. |
| `AKEEBA_KS_DIR` | Path to the local Akeeba Kickstart source repository (`ks9`). Used by the `restore` skill to build Kickstart locally when no pre-built release is available. |
| `JOOMLA_SITES_DIR` | Path to the directory where local Joomla sites are created, e.g. `~/Sites`. Used as the default parent directory when installing Joomla or working with sites. |
| `JOOMLA_SITE_DOMAIN` | The local domain suffix for your development sites, e.g. `example.test`. Used to construct site URLs such as `http://mysite.example.test`. |
| `JOOMLA_ADMIN_NAME` | Full display name for the Joomla Super Administrator account created during installation, e.g. `Jane Doe`. |
| `JOOMLA_ADMIN_USERNAME` | Username for the Joomla Super Administrator account, e.g. `janedoe`. |
| `JOOMLA_ADMIN_PASSWORD` | Password for the Joomla Super Administrator account. |
| `JOOMLA_ADMIN_EMAIL` | Email address for the Joomla Super Administrator account. |

> [!NOTE]
> The `.env` file is listed in `.gitignore` and is never included in the built plugin ZIP. It stays local to your machine.

---

## Building the plugin

Prerequisites: `bash`, `rsync`, `zip`.

```bash
# 1. Configure your environment
cp env.sample .env
# Edit .env with your values

# 2. Build
bash package.sh
```

This produces `devskills.zip` in the project root. The build process:
1. Loads your `.env` values.
2. Copies the skill files into a temporary staging directory.
3. Substitutes all `{{VARIABLE}}` placeholders in each `SKILL.md` with your values.
4. Zips the result (excluding `.env`, `env.sample`, and other source-only files).

---

## Using with Claude Code

The skill files contain `{{VARIABLE}}` placeholders that must be substituted before use. Claude Code does not install plugins directly from ZIP files, so you need to extract the built ZIP and point Claude Code at the resulting directory.

1. Build the plugin ZIP (see [Building the plugin](#building-the-plugin) above).
2. Extract the ZIP into a directory of your choice:
   ```bash
   mkdir -p ~/claude-plugins/devskills
   unzip devskills.zip -d ~/claude-plugins/devskills
   ```
3. Add the extracted directory as a plugin marketplace and install the plugin:
   ```bash
   /plugin marketplace add ~/claude-plugins/devskills
   /plugin install devskills@devskills
   ```
   Or load it for a single session only:
   ```bash
   claude --plugin-dir ~/claude-plugins/devskills
   ```

---

## Using with Claude Desktop (Cowork / custom plugin)

Claude Desktop supports uploading a custom plugin ZIP via the **Cowork** feature.

1. Build the plugin ZIP:
   ```bash
   bash package.sh
   ```
2. Open **Claude Desktop**.
3. Navigate to **Cowork** (or the plugins/integrations settings panel).
4. Choose **Upload custom plugin** and select the `devskills.zip` file produced by the build step.
5. Claude will load the skills from the plugin and make them available in your conversations.

> [!WARNING]
> The built ZIP embeds your `.env` values (admin credentials, site paths, domain). Do not share the ZIP with others.
