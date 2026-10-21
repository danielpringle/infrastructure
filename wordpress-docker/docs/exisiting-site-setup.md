# Setting Up an Existing WordPress Site

This guide explains how to use the Docker environment with an existing WordPress site when you have:

* An existing WordPress database export.
* The site's `wp-content` directory.
* Access to the site's required plugins and themes.

This process is separate from the standard `make setup` workflow.

> **Important:** Do not run `make setup` when importing an existing site. `make setup` is intended to create a new WordPress installation.

## 1. Create the Local Environment

Clone the Docker environment:

```bash
git clone <repository-url>
cd wordpress-docker
```

Create the local environment configuration:

```bash
cp .env.example .env
```

Update `.env` with the settings for the site.

For example:

```env
DOMAIN=example.local
WP_TITLE="Example Site"
```

Add the local domain to your hosts file:

```text
127.0.0.1 example.local
```

Generate the local SSL certificate:

```bash
./scripts/ssl.sh
```

Start the environment:

```bash
make start
```

Check that the containers are running:

```bash
make status
```

## 2. Add the Existing `wp-content`

The Docker environment mounts:

```text
./app:/var/www/html
```

Copy the existing site's `wp-content` directory into `app`:

```text
wordpress-docker/
└── app/
    └── wp-content/
        ├── plugins/
        ├── themes/
        ├── uploads/
        └── ...
```

Do not copy the production `wp-config.php`.

The local environment should generate its own configuration.

## 3. Install WordPress Core

The existing site's WordPress core does not need to be copied from production.

If you know the site's WordPress version, install that version:

```bash
make wp CMD="core download --version=<version>"
```

For example:

```bash
make wp CMD="core download --version=6.8.2"
```

If the exact version is not important, the current version can be installed:

```bash
make wp CMD="core download"
```

The WordPress core files will be placed in:

```text
app/
```

The existing `wp-content` directory is preserved.

## 4. Create `wp-config.php`

Create a local `wp-config.php` using the Docker database credentials:

```bash
make wp CMD="config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=${WORDPRESS_DB_HOST:-mysql} --skip-check"
```

Alternatively, use the values from `.env` explicitly if preferred.

Do not copy the production `wp-config.php` because it may contain:

* Production database credentials.
* Production salts.
* Production-specific configuration.
* Hosting-specific settings.
* Environment-specific paths.

Local development configuration should be managed by this environment.

## 5. Import the Database

Import the database export:

```bash
make wp CMD="db import /path/to/database.sql"
```

For example:

```bash
make wp CMD="db import /tmp/example.sql"
```

Check the database:

```bash
make wp CMD="db check"
```

## 6. Configure the Local URL

The imported database will normally contain the production site's URL.

Update the WordPress URLs:

```bash
make wp CMD="option update home 'https://example.local'"
make wp CMD="option update siteurl 'https://example.local'"
```

## 7. Search and Replace the Production URL

Replace the production URL throughout the database:

```bash
make wp CMD="search-replace 'https://www.example.com' 'https://example.local' --all-tables"
```

Use the actual production and local URLs for the site.

WP-CLI's `search-replace` command should be preferred over raw SQL because WordPress data can contain serialized PHP data.

Before making a large replacement, it can be useful to run:

```bash
make wp CMD="search-replace 'https://www.example.com' 'https://example.local' --all-tables --dry-run"
```

Review the output before running the real replacement.

## 8. Configure Development Settings

The local environment should use development settings rather than production settings.

These may include:

* `WP_DEBUG`
* `WP_DEBUG_LOG`
* `SCRIPT_DEBUG`
* `SAVEQUERIES`
* `WP_DEVELOPMENT_MODE`
* `WP_ENVIRONMENT_TYPE`

Check the current values:

```bash
make wp CMD="config get WP_ENVIRONMENT_TYPE"
make wp CMD="config get WP_DEBUG"
make wp CMD="config get WP_DEVELOPMENT_MODE"
```

The expected environment type is:

```text
local
```

## 9. Configure Permalinks

Flush the rewrite rules:

```bash
make wp CMD="rewrite flush"
```

If the site uses the standard post-name permalink structure:

```bash
make wp CMD="rewrite structure '/%postname%/'"
make wp CMD="rewrite flush"
```

Use the site's existing permalink structure where possible rather than changing it unnecessarily.

## 10. Configure the Site Timezone and Language

If necessary, check the existing settings:

```bash
make wp CMD="option get timezone_string"
make wp CMD="language core list --status=active"
```

Update the timezone if required:

```bash
make wp CMD="option update timezone_string 'Europe/London'"
```

Install and activate the required language if it is not already available:

```bash
make wp CMD="core language install en_GB --activate"
```

Do not change these settings unless they are required by the project.

## 11. Install Missing Plugins

The site's `wp-content/plugins` directory should contain plugins that are tracked as part of the project.

For plugins that are not included in the supplied `wp-content`, install them manually with WP-CLI:

```bash
make wp CMD="plugin install <plugin-slug> --activate"
```

For example:

```bash
make wp CMD="plugin install woocommerce --activate"
```

Development-only plugins such as Query Monitor are managed separately through:

```text
config/dev-plugins.txt
```

These are environment tooling rather than project dependencies.

## 12. Check Themes

List installed themes:

```bash
make wp CMD="theme list"
```

Activate the required theme if necessary:

```bash
make wp CMD="theme activate <theme-slug>"
```

The theme should normally come from the project's `wp-content/themes` directory rather than the Docker environment.

## 13. Check the Site

Run the environment health check:

```bash
make test
```

Check WordPress:

```bash
make wp CMD="core version"
make wp CMD="core is-installed"
```

Check the database:

```bash
make wp CMD="db check"
```

Check plugins:

```bash
make wp CMD="plugin list"
```

Check themes:

```bash
make wp CMD="theme list"
```

## 14. Test the Site

Open:

```text
https://example.local
```

Check:

* Frontend pages.
* WordPress admin.
* Plugins.
* Theme functionality.
* Media and uploads.
* Navigation and permalinks.
* Forms.
* REST API endpoints.
* Scheduled tasks.
* Email through Mailpit.
* Any external API integrations.

Mail sent by the local site should be available through Mailpit:

```text
http://localhost:8025
```

## Existing Site Workflow

The complete process is:

```text
Existing database + wp-content
             ↓
        Configure .env
             ↓
        Start Docker
             ↓
      Copy wp-content
             ↓
       Download core
             ↓
    Create local wp-config.php
             ↓
       Import database
             ↓
       Update local URLs
             ↓
     Search/replace URLs
             ↓
      Flush permalinks
             ↓
      Configure local env
             ↓
       Install missing
          plugins
             ↓
         make test
             ↓
       Test the site
```

## Important Considerations

### Do not use production credentials

Never copy production database credentials or other production secrets into the local Docker environment.

Use `.env` for local configuration and keep `.env` out of Git.

### Do not blindly copy production configuration

The production `wp-config.php` may contain configuration that is inappropriate for local development.

Generate a new local configuration instead.

### Be careful with database search and replace

Always use `--dry-run` first when replacing URLs across an existing database.

Prefer WP-CLI's `search-replace` over SQL because it handles serialized WordPress data correctly.

### Keep project and environment concerns separate

The Docker repository provides the development environment.

The WordPress project repository should contain project-specific code and dependencies.

For example:

```text
wordpress-docker/
    Development environment

my-wordpress-project/
    WordPress project
    ├── wp-content/
    ├── composer.json
    └── composer.lock
```

This allows the same Docker environment to be reused across multiple WordPress projects.
