#!/usr/bin/env bash

set -euo pipefail

source .env

WP="docker compose run --rm wp"

echo "==> Testing WordPress Docker Environment"
echo

# -------------------------------------------------------------------
# Docker Compose
# -------------------------------------------------------------------

echo "==> Checking Docker Compose configuration..."

docker compose config --quiet

echo "✓ Docker Compose configuration"
echo


# -------------------------------------------------------------------
# Services
# -------------------------------------------------------------------

echo "==> Checking services..."

docker compose ps

echo


# -------------------------------------------------------------------
# MySQL
# -------------------------------------------------------------------

echo "==> Checking MySQL..."

if docker compose exec -T mysql \
	mysqladmin ping \
		-u root \
		-p"${MYSQL_ROOT_PASSWORD}" \
		--silent >/dev/null 2>&1; then
	echo "✓ MySQL is responding"
else
	echo "✗ MySQL is not responding"
	exit 1
fi

echo


# -------------------------------------------------------------------
# PHP
# -------------------------------------------------------------------

echo "==> Checking PHP..."

PHP_VERSION="$(docker compose exec -T php php -r 'echo PHP_VERSION;')"

echo "✓ PHP ${PHP_VERSION}"

echo


# -------------------------------------------------------------------
# Xdebug
# -------------------------------------------------------------------

echo "==> Checking Xdebug..."

if docker compose exec -T php php -m | grep -qi '^xdebug$'; then
	echo "✓ Xdebug is loaded"
else
	echo "✗ Xdebug is not loaded"
	exit 1
fi

echo


# -------------------------------------------------------------------
# Composer
# -------------------------------------------------------------------

echo "==> Checking Composer..."

COMPOSER_VERSION="$(
	docker compose exec -T php composer --version --no-ansi
)"

echo "✓ ${COMPOSER_VERSION}"

echo


# -------------------------------------------------------------------
# WP-CLI
# -------------------------------------------------------------------

echo "==> Checking WP-CLI..."

WP_VERSION="$(${WP} cli version --format=plain)"

echo "✓ ${WP_VERSION}"

echo


# -------------------------------------------------------------------
# WordPress
# -------------------------------------------------------------------

echo "==> Checking WordPress..."

if ${WP} core is-installed >/dev/null 2>&1; then
	echo "✓ WordPress is installed"
else
	echo "✗ WordPress is not installed"
	exit 1
fi

echo


# -------------------------------------------------------------------
# WordPress database
# -------------------------------------------------------------------

echo "==> Checking WordPress database..."

if ${WP} db check >/dev/null 2>&1; then
	echo "✓ WordPress database is healthy"
else
	echo "✗ WordPress database check failed"
	exit 1
fi

echo


# -------------------------------------------------------------------
# Nginx / HTTPS
# -------------------------------------------------------------------

echo "==> Checking HTTPS..."

if curl --silent --show-error --insecure \
	--output /dev/null \
	--head \
	"https://${DOMAIN}"; then
	echo "✓ HTTPS is responding"
else
	echo "✗ HTTPS is not responding"
	exit 1
fi

echo


# -------------------------------------------------------------------
# Mailpit
# -------------------------------------------------------------------

echo "==> Checking Mailpit..."

if curl --silent --show-error \
	--output /dev/null \
	"http://localhost:8025"; then
	echo "✓ Mailpit is responding"
else
	echo "✗ Mailpit is not responding"
	exit 1
fi

echo


# -------------------------------------------------------------------
# phpMyAdmin
# -------------------------------------------------------------------

echo "==> Checking phpMyAdmin..."

if curl --silent --show-error \
	--output /dev/null \
	"http://localhost:8180"; then
	echo "✓ phpMyAdmin is responding"
else
	echo "✗ phpMyAdmin is not responding"
	exit 1
fi

echo

echo "========================================"
echo "✓ WordPress Docker Environment OK"
echo "========================================"