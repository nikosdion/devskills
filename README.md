# Local development skills

A small set of agentic AI skills I use for local development.

> [!WARNING]
> These skills are meant for **local development** only. They are NOT secure; quite the opposite.

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

