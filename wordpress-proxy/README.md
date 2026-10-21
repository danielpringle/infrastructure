# WordPress Proxy Development Environment

Reusable local Docker environment for WordPress development with **Nginx as a reverse proxy**.

The environment is designed to support WordPress projects with a separate frontend, such as Next.js, while keeping the infrastructure separate from the project code.

## Stack

- WordPress
- PHP 8.4
- MySQL 8
- Nginx
- WP-CLI
- Composer
- Xdebug
- phpMyAdmin
- Mailpit
- mkcert HTTPS

## Requirements

- Docker Desktop
- Git
- `make`
- macOS recommended

## Setup

Clone the repository:

```bash
git clone <repository-url>
cd wordpress-proxy-environment
```

Create the environment file:

```bash
cp .env.example .env
```

Set your local domain in `.env`:

```env
DOMAIN=mylocalproject.local
```

Generate the local SSL certificate:

```bash
make ssl
```

Start the environment:

```bash
make up
```

Open:

```text
https://mylocalproject.local
```

WordPress admin:

```text
https://mylocalproject.local/wp-admin/
```

## Common Commands

```bash
make help
make up
make down
make start
make stop
make restart
make status
make logs
```

### WordPress

```bash
make setup
make wp CMD="core version"
make wp-shell
```

### PHP / Composer

```bash
make php
make composer CMD="install"
```

## Services

| Service | URL |
|---|---|
| Website | `https://<domain>` |
| WordPress Admin | `https://<domain>/wp-admin/` |
| phpMyAdmin | `http://localhost:8180` |
| Mailpit | `http://localhost:8025` |

## Reverse Proxy

Nginx provides a single HTTPS entry point and routes requests to the appropriate service.

For example:

```text
https://mylocalproject.local/
        │
        ▼
      Nginx
        │
        ├── /wp-admin/  → WordPress
        ├── /wp-json/   → WordPress
        ├── /wp-content/ → WordPress
        │
        └── /            → Frontend
```

This allows a WordPress backend and separate frontend application to run under the same local domain.

## Project Structure

```text
.
├── docker/
│   ├── nginx/
│   ├── php/
│   └── wp-cli/
├── docker-compose.yml
├── Makefile
├── .env
└── ...
```

This repository contains the **development infrastructure**, not the WordPress project itself.

It is intended to be copied or reused when starting a new project.## Import an existing WordPress site

1. Copy the database dump (`.sql`) into the project's `imports/` directory.
2. Copy the source site's `wp-content` files into `app/wp-content/`.
3. Run the import command, replacing the filename and source URL:

   ```bash
   make import-site DUMP=site.sql SOURCE_URL=https://example.com
   ```

The script creates `wp-config.php`, checks that the database is empty, imports the database directly through the MySQL container, configures local development settings and replaces the source URL with your local domain.

**Important:** The import expects a fresh project with no existing `app/wp-config.php` and an empty database. Back up your dump before importing.

### What the import script does

- The make import-site script automates importing an existing WordPress site into the local development environment.

- Validates inputs — checks the database dump and source URL.

- Creates configuration — generates wp-config.php using the project's database settings.

- Checks the database — stops if the database is not empty.

- Downloads WordPress core — if it is not already present.

- Imports the database — imports the SQL dump directly through the MySQL container.

- Configures local development — enables debugging and other development settings.

- Updates URLs — replaces the source site's URL with the local domain.

- Flushes rewrite rules — refreshes WordPress permalinks.

Note: Copy the source site's wp-content files into app/wp-content/ separately.