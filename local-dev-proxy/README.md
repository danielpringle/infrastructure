# Nginx Reverse Proxy

Nginx reverse proxy for the local WordPress development environment.

It provides a **single HTTPS entry point** and routes requests to the appropriate application container.

## Purpose

The proxy allows multiple services to appear under a single local domain.

For example:

```text
https://mylocalproject.local/
        │
        ▼
      Nginx
        │
        ├── /wp-admin/    → WordPress
        ├── /wp-json/     → WordPress
        ├── /wp-content/  → WordPress
        │
        └── /             → Frontend
```

This is particularly useful for **headless WordPress**, where WordPress provides the CMS/API and a separate frontend such as Next.js handles the public website.

## Routing

The default configuration routes:

| Path | Destination |
|---|---|
| `/wp-admin/` | WordPress |
| `/wp-json/` | WordPress |
| `/wp-content/` | WordPress |
| `/` | Frontend |

The exact routes are defined in:

```text
docker/nginx/default.conf.template
```

## HTTPS

Local HTTPS is provided using **mkcert**.

Certificates are generated for the domain configured in `.env`:

```env
DOMAIN=mylocalproject.local
```

Generate or regenerate the certificate with:

```bash
make ssl
```

Certificates are mounted into the Nginx container and are not committed to Git.

## Configuration

The Nginx configuration is generated from:

```text
docker/nginx/default.conf.template
```

The domain is supplied through the Docker environment:

```text
${DOMAIN}
```

This allows the same proxy configuration to be reused across projects without changing the configuration manually.

## Docker

Nginx runs as part of the Docker Compose environment and acts as the external entry point.

```text
Browser
   │
   │ HTTPS :443
   ▼
 Nginx
   │
   ├── WordPress/PHP
   │
   └── Frontend
```

Internal services communicate over the Docker network rather than through published host ports.

## Local Development

Start the environment:

```bash
make up
```

Check the proxy:

```bash
docker compose ps nginx
```

View Nginx logs:

```bash
docker compose logs -f nginx
```

Test the site:

```bash
curl -I https://${DOMAIN}
```

## Project Structure

```text
docker/nginx/
├── Dockerfile
├── default.conf.template
└── ssl/
```

The `ssl/` directory contains local development certificates and should be excluded from Git.

## Scope

This component is intended for **local development**.

It is not intended to be a production reverse-proxy configuration.