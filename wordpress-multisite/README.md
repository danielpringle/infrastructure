# WordPress Proxy Development Environment

Reusable local Docker environment for WordPress development with **Nginx as a reverse proxy**.

Supports both standard WordPress installations and **WordPress Multisite**, with optional support for a separate frontend such as Next.js.

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

For a standard WordPress installation:

```text
https://mylocalproject.local/
        │
        ▼
      Nginx
        │
        ├── /wp-admin/   → WordPress
        ├── /wp-json/    → WordPress
        ├── /wp-content/ → WordPress
        │
        └── /            → WordPress or frontend
```

This allows WordPress and a separate frontend application to run under the same local domain.

## WordPress Multisite

The environment can also be used for WordPress Multisite.

### Subdirectory Multisite

For a subdirectory installation:

```text
https://mylocalproject.local/
https://mylocalproject.local/site1/
https://mylocalproject.local/site2/
```

### Subdomain Multisite

For a subdomain installation:

```text
https://mylocalproject.local/
https://site1.mylocalproject.local/
https://site2.mylocalproject.local/
```

Subdomain Multisite requires the local domains to resolve correctly and Nginx/SSL to support the additional hostnames.

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

It is intended to be copied or reused when starting a new WordPress project.

## Notes

The environment is intended for **local development** and is not a production deployment configuration.