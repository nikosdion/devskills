# Local development skills

A small set of agentic AI skills I use for local development.

> [!WARNING]
> These skills are meant for **local development** only. They are NOT secure; quite the opposite.

These skills can be used as a **Claude plugin** — both with Claude Code (as local skills) and with Claude Desktop (via the Cowork feature).

## Skills and Usage Examples

### Infrastructure & Setup

#### `mysql`
Create or reset a local MySQL database and a matching local user with the same name and password.
- **Example:** "Create a local database named `mytest`"
- **Action:** Provisions database `mytest`, creates user `'mytest'@'localhost'` with password `mytest`, and grants all privileges.

#### `installjoomla`
Download and install a specific or the latest stable version of Joomla 5+ into a local directory.
- **Example:** "Install Joomla 5 in `~/Sites/joomlatest`"
- **Example:** "Install Joomla 6.0.2 in `mysite`" (will be installed in `~/Sites/mysite`)
- **Action:** Downloads Joomla, extracts it, provisions a matching database (if not provided), and runs the CLI installation.

#### `backup`
Take a backup of a local Joomla or WordPress site using Akeeba Backup.
- **Example:** "Take a backup of the site in `/var/www/html/mysite`"
- **Example:** "Run a backup for `~/Sites/joomlatest` using profile ID 2"
- **Action:** Detects the CMS, verifies Akeeba Backup, and runs the CLI backup command.

#### `restore`
Restore a Joomla or WordPress site from an Akeeba Backup archive using Akeeba Kickstart.
- **Example:** "Restore `site-backup.jpa` into `~/Sites/restoredsite`"
- **Action:** Extracts the archive using Kickstart, provisions a database (if not provided), and runs the restoration script.

#### `unblock`
Unblock localhost access (`127.0.0.1` and `::1`) in Admin Tools for Joomla or WordPress.
- **Example:** "Unblock me in `/var/www/html/mysite`"
- **Action:** Runs the Admin Tools CLI unblock commands for both IPv4 and IPv6 localhost addresses.

#### `japitoken`
Retrieve a valid Joomla API token from a local development site.
- **Example:** "Get a Joomla API token for `~/Sites/joomlatest`"
- **Action:** Safely executes a script on the local site to retrieve an active Super User's API token.

---

### Joomla Web Services API Skills

These skills use the Joomla Web Services API and are restricted to local development sites only.

#### `jconfig`
Manage Joomla's Global Configuration and component configurations.
- **Example:** "Get the global config for `~/Sites/mysite`"
- **Example:** "Update the debug setting on `~/Sites/mysite`"

#### `jcontent`
Manage Joomla content articles (list, get, create, update, delete).
- **Example:** "List all articles on `~/Sites/mysite`"

#### `jcontentcat`
Manage Joomla content categories.
- **Example:** "List content categories on `~/Sites/mysite`"

#### `jcontenthist`
Manage version history of Joomla content articles.
- **Example:** "Show version history for article 5 on `~/Sites/mysite`"

#### `jfields`
Manage Joomla custom fields.
- **Example:** "List custom fields for `com_content.article` on `~/Sites/mysite`"

#### `jfieldgroups`
Manage Joomla custom field groups.
- **Example:** "List field groups for `com_content.article` on `~/Sites/mysite`"

#### `jbanners`
Manage Joomla banners.
- **Example:** "List all banners on `~/Sites/mysite`"

#### `jbannerscat`
Manage Joomla banner categories.
- **Example:** "Create a banner category on `~/Sites/mysite`"

#### `jbannersclients`
Manage Joomla banner clients.
- **Example:** "List banner clients on `~/Sites/mysite`"

#### `jcontacts`
Manage Joomla contacts and submit contact forms.
- **Example:** "List contacts on `~/Sites/mysite`"

#### `jcontactscat`
Manage Joomla contacts categories.
- **Example:** "List contacts categories on `~/Sites/mysite`"

#### `jextensions`
List and inspect installed Joomla extensions.
- **Example:** "List all extensions on `~/Sites/mysite`"

#### `jplugins`
Manage Joomla plugins (list, get, enable, disable).
- **Example:** "List all plugins on `~/Sites/mysite`"

#### `joomlaupdate`
Manage Joomla core updates.
- **Example:** "Check for Joomla updates on `~/Sites/mysite`"
- **Example:** "Update Joomla on `~/Sites/mysite`"

#### `jlangcontent`
Manage Joomla content languages.
- **Example:** "List content languages on `~/Sites/mysite`"

#### `jlangoverrides`
Manage Joomla language string overrides.
- **Example:** "List language overrides for `en-GB` (site) on `~/Sites/mysite`"

#### `jlangpackages`
List and install Joomla language packages.
- **Example:** "Install the French language pack on `~/Sites/mysite`"

#### `jmedia`
Manage Joomla media files and folders.
- **Example:** "List media adapters on `~/Sites/mysite`"
- **Example:** "Upload a file to `~/Sites/mysite`"

#### `jmenussite`
Manage Joomla site menus.
- **Example:** "List site menus on `~/Sites/mysite`"

#### `jmenussiteitems`
Manage Joomla site menu items.
- **Example:** "List menu items in the main menu on `~/Sites/mysite`"

#### `jmenusadmin`
Manage Joomla administrator menus.
- **Example:** "List administrator menus on `~/Sites/mysite`"

#### `jmenusadminitems`
Manage Joomla administrator menu items.
- **Example:** "List admin menu items on `~/Sites/mysite`"

#### `jmessages`
Manage Joomla private messages between users.
- **Example:** "List private messages on `~/Sites/mysite`"

#### `jmodulessite`
Manage Joomla site modules.
- **Example:** "List site modules on `~/Sites/mysite`"

#### `jmodulesadmin`
Manage Joomla administrator modules.
- **Example:** "List admin modules on `~/Sites/mysite`"

#### `jnewsfeeds`
Manage Joomla newsfeeds.
- **Example:** "List newsfeeds on `~/Sites/mysite`"

#### `jnewsfeedscat`
Manage Joomla newsfeed categories.
- **Example:** "List newsfeed categories on `~/Sites/mysite`"

#### `jtags`
Manage Joomla tags.
- **Example:** "List tags on `~/Sites/mysite`"

#### `jprivacy`
Manage Joomla privacy (GDPR) requests and user consent records.
- **Example:** "List privacy requests on `~/Sites/mysite`"
- **Example:** "Export request 3 on `~/Sites/mysite`"

#### `jredirects`
Manage Joomla URL redirects.
- **Example:** "List redirects on `~/Sites/mysite`"

#### `jtemplates`
Manage Joomla template styles.
- **Example:** "List site template styles on `~/Sites/mysite`"

#### `jusers`
Manage Joomla users, user groups, and viewing access levels.
- **Example:** "List users on `~/Sites/mysite`"
- **Example:** "Create a user group on `~/Sites/mysite`"

---

### Joomla CLI Skills

These skills use the Joomla CLI (`cli/joomla.php`) and are preferred over API skills when working on local sites.

#### `jclisite`
Manage a local Joomla site via CLI — take it online/offline, clean cache, rebuild Smart Search index, check the database, and run session garbage collection.
- **Example:** "Take `~/Sites/mysite` offline"
- **Example:** "Clear the cache for `~/Sites/mysite`"

#### `jcliconfig`
Read or set Joomla Global Configuration options via the Joomla CLI.
- **Example:** "Get the config for `~/Sites/mysite`"
- **Example:** "Enable debug mode on `~/Sites/mysite`"

#### `jclicore`
Manage Joomla core updates via the CLI — check for updates, set update channel, perform update, and manage the automated update service registration.
- **Example:** "Check for Joomla updates on `~/Sites/mysite`"
- **Example:** "Update Joomla on `~/Sites/mysite`"

#### `jclidb`
Export or import the Joomla database via the CLI (SQL files or ZIP archive).
- **Example:** "Export the database of `~/Sites/mysite` to `backup.sql`"
- **Example:** "Import `backup.sql` into `~/Sites/mysite`"

#### `jcliext`
Manage Joomla extensions via the CLI — list, install from path or URL, remove, discover, and install discovered extensions.
- **Example:** "List extensions on `~/Sites/mysite`"
- **Example:** "Install `/tmp/myextension.zip` on `~/Sites/mysite`"

#### `jcliuser`
Manage Joomla users via the CLI — list, add, delete, reset passwords, and manage groups.
- **Example:** "Add user `john` to `~/Sites/mysite`"
- **Example:** "Reset password for `admin` on `~/Sites/mysite`"

#### `jclischeduler`
Manage and run Joomla scheduled tasks via the CLI — list tasks, run due tasks, and enable/disable/trash tasks.
- **Example:** "Run due scheduled tasks on `~/Sites/mysite`"
- **Example:** "List all scheduled tasks on `~/Sites/mysite`"

---

### Third-Party Extension CLI Skills

These skills use the Joomla CLI to manage specific third-party Akeeba extensions.

#### `jclipanopticon`
Retrieve or reset the Akeeba Panopticon API connection token for a Joomla Super User.
- **Example:** "Get the Panopticon token for `admin` on `~/Sites/mysite`"
- **Example:** "Reset the Panopticon token for `admin` on `~/Sites/mysite`"

#### `jclidocimport`
Regenerate Akeeba DocImport category content from DocBook 5+ XML sources.
- **Example:** "Regenerate all DocImport categories on `~/Sites/mysite`"
- **Example:** "Force-regenerate DocImport category 3 on `~/Sites/mysite`"

#### `jcliats`
Manage Akeeba Ticket System (ATS) — view/change config and run CRON tasks.
- **Example:** "Show ATS config on `~/Sites/mysite`"
- **Example:** "Run ATS CRON tasks on `~/Sites/mysite`"

#### `jclidatacompliance`
Manage GDPR-compliant user account deletion and lifecycle notifications via Akeeba DataCompliance.
- **Example:** "Delete user `john` from `~/Sites/mysite` in compliance with GDPR"
- **Example:** "Send lifecycle notifications on `~/Sites/mysite`"

#### `jcliadmintools`
Manage Admin Tools for Joomla — WAF config, IP block/allow lists, bad words, server config file generation, and security scanning.
- **Example:** "Run a security scan on `~/Sites/mysite`"
- **Example:** "Show the WAF rules for `~/Sites/mysite`"

#### `jcliakeeba`
Manage Akeeba Backup for Joomla — take backups, manage backup records, profiles, filters, logs, and settings. Preferred over the `backup` skill for local Joomla sites.
- **Example:** "Take a backup of `~/Sites/mysite`"
- **Example:** "List backup records for `~/Sites/mysite`"

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
