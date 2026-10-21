#!/usr/bin/env bash

set -euo pipefail

source .env

WP="docker compose run --rm wp"
DEV_PLUGINS="config/dev-plugins.txt"

echo "==> Checking WordPress installation..."

if ${WP} core is-installed >/dev/null 2>&1; then
	echo "==> WordPress is already installed."
	exit 0
fi

echo "==> Downloading WordPress..."

${WP} core download

echo "==> Creating wp-config.php..."

${WP} config create \
	--dbname="${DB_NAME}" \
	--dbuser="${DB_USER}" \
	--dbpass="${DB_PASSWORD}" \
	--dbhost="${WORDPRESS_DB_HOST:-mysql}" \
	--skip-check

echo "==> Configuring WordPress for local development..."

${WP} config set WP_ENVIRONMENT_TYPE local
${WP} config set WP_DEBUG true --raw
${WP} config set WP_DEBUG_LOG true --raw
${WP} config set WP_DEBUG_DISPLAY false --raw
${WP} config set SCRIPT_DEBUG true --raw
${WP} config set SAVEQUERIES true --raw
${WP} config set WP_DEVELOPMENT_MODE all

echo "==> Installing WordPress..."

${WP} core install \
	--url="https://${DOMAIN}" \
	--title="${WP_TITLE}" \
	--admin_user="${WP_ADMIN_USER}" \
	--admin_password="${WP_ADMIN_PASSWORD}" \
	--admin_email="${WP_ADMIN_EMAIL}" \
	--skip-email

echo "==> Configuring permalinks..."

${WP} rewrite structure '/%postname%/'
${WP} rewrite flush

echo "==> Configuring timezone..."

${WP} option update timezone_string "${WP_TIMEZONE}"

echo "==> Configuring site language..."

${WP} core language install "${WP_LOCALE}" --activate

echo "==> Installing development plugins..."

if [[ ! -f "${DEV_PLUGINS}" ]]; then
	echo "ERROR: ${DEV_PLUGINS} not found."
	exit 1
fi

if [[ ! -f "${DEV_PLUGINS}" ]]; then
	echo "ERROR: Development plugin file not found: ${DEV_PLUGINS}"
	exit 1
fi

while IFS= read -r plugin || [[ -n "${plugin}" ]]; do
	# Ignore blank lines and comments.
	if [[ -z "${plugin}" || "${plugin}" == \#* ]]; then
		continue
	fi

	if ${WP} plugin is-installed "${plugin}" >/dev/null 2>&1; then
		echo "    ${plugin} already installed."
	else
		echo "    Installing ${plugin}..."
		${WP} plugin install "${plugin}" --activate
	fi
done < "${DEV_PLUGINS}"

echo "==> WordPress installation complete."