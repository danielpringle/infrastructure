```bash
#!/usr/bin/env bash

set -euo pipefail

source .env

WP=(docker compose run --rm wp)

DUMP="${DUMP:-}"
SOURCE_URL="${SOURCE_URL:-}"

if [[ -z "${DUMP}" ]]; then
    echo "ERROR: Database dump is required."
    echo "Usage: make import-site DUMP=site.sql SOURCE_URL=https://example.com"
    exit 1
fi

if [[ ! -f "imports/${DUMP}" ]]; then
    echo "ERROR: Database dump not found: imports/${DUMP}"
    exit 1
fi

if [[ -z "${SOURCE_URL}" ]]; then
    echo "ERROR: SOURCE_URL is required."
    exit 1
fi

echo "==> Checking WordPress configuration..."

if [[ ! -f app/wp-config.php ]]; then
    echo "==> Creating wp-config.php..."

    "${WP[@]}" config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST:-mysql}" \
        --skip-check
else
    echo "ERROR: app/wp-config.php already exists."
    echo "Check the existing configuration before importing."
    exit 1
fi

echo "==> Checking database..."

TABLES=$(docker compose exec -T \
    -e MYSQL_PWD="${DB_ROOT_PASSWORD}" \
    mysql mysql -u root "${DB_NAME}" -Nse "SHOW TABLES;")

if [[ -n "${TABLES}" ]]; then
    echo "ERROR: Database is not empty. Import cancelled."
    exit 1
fi

echo "==> Downloading WordPress core if necessary..."

if [[ ! -f app/wp-includes/version.php ]]; then
    "${WP[@]}" core download
fi

echo "==> Importing database directly into MySQL..."

docker compose exec -T \
    -e MYSQL_PWD="${DB_ROOT_PASSWORD}" \
    mysql mysql -u root "${DB_NAME}" < "imports/${DUMP}"

echo "==> Configuring local development..."

"${WP[@]}" config set WP_ENVIRONMENT_TYPE local
"${WP[@]}" config set WP_DEBUG true --raw
"${WP[@]}" config set WP_DEBUG_LOG true --raw
"${WP[@]}" config set WP_DEBUG_DISPLAY false --raw
"${WP[@]}" config set SCRIPT_DEBUG true --raw
"${WP[@]}" config set SAVEQUERIES true --raw
"${WP[@]}" config set WP_DEVELOPMENT_MODE all

echo "==> Updating site URL..."

"${WP[@]}" search-replace \
    "${SOURCE_URL}" \
    "https://${DOMAIN}" \
    --skip-columns=guid \
    --all-tables-with-prefix

echo "==> Flushing rewrite rules..."

"${WP[@]}" rewrite flush

echo "==> Site import complete."
echo "==> Remember to copy the site's wp-content files into app/wp-content."
```
