---
name: mysql
description: Create or reset a local MySQL database and matching localhost user for development/testing.
argument-hint: [database]
---

# MySQL Local Database Bootstrap

Create a local MySQL database and a matching local user from a single input name.

## Input

- `db_name`: Database name to create (example: `example`)

## Behavior

1. Treat `db_name` as:
- Database name
- MySQL username (`'db_name'@'localhost'`)
- MySQL password
2. Drop existing database and user if they already exist.
3. Recreate database with:
- Character set: `utf8mb4`
- Collation: `utf8mb4_unicode_ci`
4. Recreate local user and grant all privileges on that database.
5. Apply privilege changes with `FLUSH PRIVILEGES`.

## Execution

Run MySQL as an admin-capable account (for example root) and execute:

```sql
DROP DATABASE IF EXISTS `example`;
DROP USER IF EXISTS 'example'@'localhost';

CREATE DATABASE `example`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER 'example'@'localhost' IDENTIFIED BY 'example';
GRANT ALL PRIVILEGES ON `example`.* TO 'example'@'localhost';
FLUSH PRIVILEGES;
```

Replace `example` everywhere with the provided `db_name`.

## Verification

Use a quick check after provisioning:

```sql
SHOW DATABASES LIKE 'example';
SHOW GRANTS FOR 'example'@'localhost';
```

## Scope and Safety

- Use only for local development/testing on `localhost`.
- Do not use for production or shared environments.
- This workflow is destructive for the target database/user because it drops and recreates them.
