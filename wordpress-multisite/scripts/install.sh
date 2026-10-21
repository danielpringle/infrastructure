```bash
#!/usr/bin/env bash

set -euo pipefail

source .env

echo "==> Checking /etc/hosts..."

if ! grep -qE "^[[:space:]]*127\.0\.0\.1[[:space:]]+.*${DOMAIN}([[:space:]]|$)" /etc/hosts; then
	echo
	echo "Add the following entry to /etc/hosts:"
	echo
	echo "127.0.0.1 ${DOMAIN}"
	echo
	read -r -p "Press Enter once this has been added..."
fi

echo "==> Starting Docker containers..."
docker compose up -d --build

echo "==> Installing WordPress..."
./scripts/wordpress.sh

echo
echo "Installation complete."
echo
echo "WordPress:  https://${DOMAIN}"
echo "Network:    https://${DOMAIN}/wp-admin/network/"
echo "phpMyAdmin: https://db.${DOMAIN}"
echo "Mailpit:    https://mail.${DOMAIN}"
```
