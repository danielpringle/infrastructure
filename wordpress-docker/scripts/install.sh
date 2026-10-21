#!/usr/bin/env bash

set -euo pipefail

source .env

command -v docker >/dev/null 2>&1 || {
	echo "Error: Docker is required."
	exit 1
}

command -v mkcert >/dev/null 2>&1 || {
	echo "Error: mkcert is required."
	echo "Install it with: brew install mkcert"
	exit 1
}

echo "==> Checking /etc/hosts..."

if ! grep -qE "^[[:space:]]*127\.0\.0\.1[[:space:]]+.*${DOMAIN}([[:space:]]|$)" /etc/hosts; then
	echo
	echo "Add the following entry to /etc/hosts:"
	echo
	echo "127.0.0.1 ${DOMAIN}"
	echo
	read -r -p "Press Enter once this has been added..."
fi

echo "==> Generating local SSL certificate..."
./scripts/ssl.sh

echo "==> Starting Docker containers..."
docker compose up -d --build

echo "==> Installing WordPress..."
./scripts/wordpress.sh

echo
echo "Installation complete."
echo
echo "WordPress:  https://${DOMAIN}"
echo "phpMyAdmin: http://localhost:8180"
echo "Mailpit:    http://localhost:8025"