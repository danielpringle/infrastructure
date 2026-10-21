#!/usr/bin/env bash

set -euo pipefail

source .env

CERT_DIR="docker/nginx/ssl"

# mkcert creates locally trusted certificates for development.
command -v mkcert >/dev/null 2>&1 || {
	echo "Error: mkcert is required."
	echo "Install it with: brew install mkcert"
	exit 1
}

mkdir -p "${CERT_DIR}"

# Don't regenerate certificates unnecessarily.
if [[ -f "${CERT_DIR}/${DOMAIN}.crt" && -f "${CERT_DIR}/${DOMAIN}.key" ]]; then
	echo "==> SSL certificate already exists."
	exit 0
fi

echo "==> Creating SSL certificate for ${DOMAIN}..."

mkcert \
	-cert-file "${CERT_DIR}/${DOMAIN}.crt" \
	-key-file "${CERT_DIR}/${DOMAIN}.key" \
	"${DOMAIN}"

echo "==> SSL certificate created."