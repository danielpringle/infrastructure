# WordPress Docker Environment

A reusable local Docker environment for WordPress development.

The environment provides:

* WordPress
* PHP 8.4
* Nginx
* MySQL 8
* WP-CLI
* Composer
* Xdebug
* phpMyAdmin
* Mailpit
* Local HTTPS via `mkcert`

The goal is to provide a consistent, reproducible development environment that can be reused across WordPress projects.

## Requirements

* Docker Desktop
* Git
* `mkcert`
* macOS/Linux shell
* iTerm2 for the optional `make dev` command

## Getting Started

Clone the repository:

```bash
git clone <repository-url>
cd wordpress-docker
```

Create your environment configuration:

```bash
cp .env.example .env
```

Update `.env` with the settings for your project.

Add the local domain to your hosts file:

```text
127.0.0.1 dpuk-env.local
```

Make sure the setup scripts are executable:

```bash
chmod +x scripts/*.sh
```

Generate the local SSL certificate:

```bash
./scripts/ssl.sh
```

Start the environment:

```bash
make start
```

Install WordPress:

```bash
make setup
```

WordPress will then be available at:

```text
https://dpuk-env.local
```

## Make Commands

Run:

```bash
make help
```

to see the available commands.

Common commands:

```bash
make start
make stop
make restart
make status
make logs
```

### WordPress

Run WP-CLI commands with:

```bash
make wp CMD="plugin list"
make wp CMD="theme list"
make wp CMD="core version"
make wp CMD="db check"
```

Open a WP-CLI shell:

```bash
make wp-shell
```

### PHP

Open a shell in the PHP container:

```bash
make php
```

Check PHP:

```bash
docker compose exec php php -v
```

Check Composer:

```bash
make composer CMD="--version"
```

Run Composer commands:

```bash
make composer CMD="install"
make composer CMD="update"
```

## Development Services

### WordPress

```text
https://dpuk-env.local
```

### phpMyAdmin

```text
http://localhost:8180
```

### Mailpit

```text
http://localhost:8025
```

Mail sent by WordPress can be routed to Mailpit during local development.

## Docker Services

The environment consists of:

| Service      | Purpose                          |
| ------------ | -------------------------------- |
| `nginx`      | Web server and HTTPS termination |
| `php`        | PHP-FPM and development tooling  |
| `mysql`      | WordPress database               |
| `wp`         | WP-CLI                           |
| `phpmyadmin` | Database administration          |
| `mailpit`    | Local email testing              |

## Testing the Environment

After starting the environment, check the containers:

```bash
docker compose ps
```

MySQL should report:

```text
healthy
```

Validate the Compose configuration:

```bash
docker compose config
```

Check PHP:

```bash
docker compose exec php php -v
```

Check Composer:

```bash
docker compose exec php composer --version
```

Check Xdebug:

```bash
docker compose exec php php -m | grep xdebug
```

Check WP-CLI:

```bash
make wp CMD="cli version"
```

Check WordPress:

```bash
make wp CMD="core is-installed"
make wp CMD="core version"
```

Check the database:

```bash
make wp CMD="db check"
```

## Stopping the Environment

Stop the containers:

```bash
make stop
```

This stops the environment without removing the persistent database volume.

To start it again:

```bash
make start
```

## Project Structure

```text
wordpress-docker/
├── app/
├── docker/
│   ├── nginx/
│   ├── php/
│   └── wp-cli/
├── docs/
│   └── docker-commands.md
├── scripts/
│   ├── install.sh
│   ├── ssl.sh
│   └── wordpress.sh
├── .env
├── .gitignore
├── compose.yml
├── composer.json
└── Makefile
```

## Using the Environment for a WordPress Project

This repository is intended to provide the development environment rather than be the WordPress project itself.

A typical workflow is:

1. Clone this repository.
2. Configure `.env`.
3. Generate local SSL certificates.
4. Start Docker.
5. Install WordPress.
6. Create a separate Git repository for the WordPress project.
7. Develop the project's `wp-content` within the environment.

The Docker environment can therefore be reused across multiple WordPress projects.

## Troubleshooting

Docker commands and common problems are documented in:

[`docs/docker-commands.md`](docs/docker-commands.md)

Useful first checks are:

```bash
docker compose config
docker compose ps
docker compose logs nginx
docker compose logs php
```

If a port is already in use on macOS:

```bash
lsof -i :80
lsof -i :443
```

## Local SSL

Local HTTPS certificates are generated using `mkcert`.

Generate or regenerate the certificate with:

```bash
./scripts/ssl.sh
```

The certificates are stored locally under:

```text
docker/nginx/ssl/
```

They should not be committed to Git.

## Development Plugins

Common WordPress development plugins can be defined in:

```text
config/dev-plugins.txt
```

These plugins are automatically installed and activated when running:
```bash
make setup
```

The file is intended for plugins that are useful across most local WordPress projects.

Project-specific plugins should be managed by the individual WordPress project rather than added to this environment.

## Releases

Releases

This project uses Semantic Versioning for releases.

Versions follow:

MAJOR.MINOR.PATCH

For example:

v1.0.0
v1.1.0
v2.0.0

MAJOR — breaking changes that require changes to the development environment or project workflow.
MINOR — new backwards-compatible features or services.
PATCH — backwards-compatible bug fixes and minor corrections.

Stable releases are identified using Git tags.

For example:
```bash
git checkout v1.0.0
```
The master branch contains the current development version. Stable tags provide known, reproducible versions of the environment for use with WordPress projects.

## Notes

This environment is intended for **local development only**.

It is not intended to be used as a production WordPress hosting environment.

Development settings such as PHP memory limits, error reporting, Xdebug and local SSL are deliberately configured for developer productivity and debugging.
