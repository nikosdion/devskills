---
name: jchildtemplate
description: Create a Joomla 5 Cassiopeia child template with optional auto dark/light mode CSS. Use when asked to "create a child template", "make a child theme", "create a Cassiopeia child", "add dark mode to Joomla", or "override Cassiopeia CSS".
argument-hint: [site_path] [template_name] [options]
---

# Joomla 5 Cassiopeia Child Template Creator

Create a Cassiopeia child template on a local Joomla 5 site, optionally with automatic OS-preference dark/light mode support.

## Inputs

- `site_path`: Absolute or relative path to the Joomla site root.
- `template_name`: Name for the child template (e.g. `cassiopeia_mytheme`). Must be lowercase, alphanumeric, underscores only.
- `dark_mode` (optional): `true` to add auto dark/light mode CSS to `user.css`. Default: `false`.
- `primary_color` (optional): Hex colour for the brand primary. Default: `#2a6496`.

## Prerequisites

- Joomla 5+ is installed at `site_path`.
- The Cassiopeia template is present (it ships with Joomla by default).
- The web server has write access to `<site_path>/media/templates/site/`.

---

## Step 1 — Confirm the Cassiopeia template exists

```bash
ls "<site_path>/templates/cassiopeia/templateDetails.xml"
```

Stop and report if the file is missing.

---

## Step 2 — Create the child template directory structure

```bash
CHILD="<site_path>/media/templates/site/<template_name>"
mkdir -p "$CHILD/css/global"
```

---

## Step 3 — Write templateDetails.xml

Create `<site_path>/media/templates/site/<template_name>/templateDetails.xml` with the content below. Substitute `<template_name>` literally:

```xml
<?xml version="1.0" encoding="utf-8"?>
<extension type="template" client="site">
    <name><template_name></name>
    <version>1.0.0</version>
    <creationDate>__TODAY__</creationDate>
    <author></author>
    <authorEmail></authorEmail>
    <authorUrl></authorUrl>
    <copyright></copyright>
    <license>GNU General Public License version 2 or later</license>
    <description></description>
    <inheritable>0</inheritable>
    <parent>cassiopeia</parent>
    <files>
        <filename>templateDetails.xml</filename>
    </files>
    <positions>
        <position>banner</position>
        <position>bottom-a</position>
        <position>bottom-b</position>
        <position>breadcrumbs</position>
        <position>debug</position>
        <position>footer</position>
        <position>menu</position>
        <position>sidebar-left</position>
        <position>sidebar-right</position>
        <position>search</position>
        <position>top-a</position>
        <position>top-b</position>
    </positions>
</extension>
```

Replace `__TODAY__` with today's date in `YYYY-MM-DD` format.

---

## Step 4 — Register the template in the Joomla database

Joomla discovers templates via the `#__extensions` table, not just the filesystem. Insert the extension record using the Joomla CLI:

```bash
cd "<site_path>"
php cli/joomla.php extension:discover
php cli/joomla.php extension:discover:install --eid="$(
  php -r "
    define('_JEXEC', 1);
    define('JPATH_BASE', realpath('.'));
    require_once 'libraries/bootstrap.php';
    \$app = \JFactory::getApplication('cli');
    \$db  = \JFactory::getDbo();
    \$q   = \$db->getQuery(true)
            ->select(\$db->quoteName('extension_id'))
            ->from(\$db->quoteName('#__extensions'))
            ->where(\$db->quoteName('element') . ' = ' . \$db->quote('<template_name>'))
            ->where(\$db->quoteName('type') . ' = ' . \$db->quote('template'));
    \$db->setQuery(\$q);
    echo \$db->loadResult();
  "
)"
```

> **Note:** If the CLI approach fails (e.g. CLI bootstrap not available), instruct the user to go to **System → Discover** in the Joomla Administrator and click **Discover**, then install the found template from the list.

---

## Step 5 — Set the child template as the default site style (optional)

Use the `jtemplates` skill to list site template styles:

```
jtemplates <site_path> site list --template=<template_name>
```

Then set the style as default:

```
jtemplates <site_path> site update --id=<id> --home=true
```

Only do this if the user explicitly asks to set it as default.

---

## Step 6 — Create user.css

Create `<site_path>/media/templates/site/<template_name>/css/user.css`.

Joomla automatically detects and loads this file — no registration needed.

### 6a — Base user.css (light mode only, always include)

Replace `<primary_color>` with the value provided (default `#2a6496`).

Derive `<hover_color>` by darkening `<primary_color>` by ~15% (e.g. `#2a6496` → `#1a4a76`).

```css
/* === Brand colours === */
:root {
  --my-color-primary: <primary_color>;
  --my-color-hover:   <hover_color>;
  --my-color-link:    <primary_color>;
}

/* === Light mode (default) === */
:root {
  --cassiopeia-color-primary:        var(--my-color-primary);
  --cassiopeia-color-link:           var(--my-color-link);
  --cassiopeia-color-hover:          var(--my-color-hover);
  --cassiopeia-color-gradient-start: var(--my-color-primary);
  --cassiopeia-color-gradient-end:   var(--my-color-hover);
}
```

### 6b — Dark mode block (append only when `dark_mode=true`)

```css
/* === Dark mode (automatic — follows OS/browser preference) === */
@media screen and (prefers-color-scheme: dark) {
  :root {
    --body-bg:    #1a1a2e;
    --body-color: #e0e0e0;
    --cassiopeia-color-primary:        #5a9fd4;
    --cassiopeia-color-link:           #5a9fd4;
    --cassiopeia-color-hover:          #7ab8e8;
    --cassiopeia-color-gradient-start: #5a9fd4;
    --cassiopeia-color-gradient-end:   #2a6496;
  }
  body {
    background-color: var(--body-bg);
    color: var(--body-color);
  }
  .container-header,
  .container-footer {
    background-color: #0f0f1a;
  }
  .card {
    background-color: #2a2a3e;
    border-color: #3a3a5e;
    color: var(--body-color);
  }
}
```

> **How it works:** `prefers-color-scheme` reads the user's OS/browser dark-mode preference. No JavaScript or plugin required. Joomla 5 ships no native frontend dark-mode toggle — a manual toggle requires additional JavaScript beyond this skill's scope.

---

## Key Cassiopeia CSS Variables Reference

| Variable | Purpose |
|---|---|
| `--cassiopeia-color-primary` | Primary accent colour |
| `--cassiopeia-color-link` | Link colour |
| `--cassiopeia-color-hover` | Hover state colour |
| `--cassiopeia-color-gradient-start` | Gradient start |
| `--cassiopeia-color-gradient-end` | Gradient end |
| `--body-bg` | Page background |
| `--body-color` | Body text colour |

---

## File Structure Summary

```
/media/templates/site/<template_name>/
├── templateDetails.xml         ← required; inherits from cassiopeia
└── css/
    ├── user.css                ← auto-loaded by Joomla; all overrides go here
    └── global/
        └── colors_standard.css ← optional; colour scheme selectable from Admin
```

Only create `css/global/colors_standard.css` if the user explicitly asks for a selectable colour scheme in the template style Advanced tab. Its contents follow the same CSS variable pattern as `user.css`.

---

## Constraints

- **Never edit** files under `/templates/cassiopeia/` or `/media/templates/site/cassiopeia/` — they are overwritten on Joomla updates.
- All customisations must go in the child template's own directory.
- `user.css` is the update-safe location for CSS overrides.
- The child template only needs to contain files it actually overrides; everything else is inherited from Cassiopeia.
- This skill creates only the child template scaffold. To install additional extensions or configure menus/modules, use the appropriate `jcli*` or `j*` API skills.
