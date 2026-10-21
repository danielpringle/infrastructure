.PHONY: help start stop restart status logs setup wp wp-shell php composer dev test browser mail database

# ---------------------------------------------------------------------------
# Help
# ---------------------------------------------------------------------------

help: ## Show available commands
	@echo ""
	@echo "WordPress Docker Environment"
	@echo "============================"
	@echo ""
	@echo "Environment:"
	@echo "  make up                    Start the Docker environment"
	@echo "  make down                  Stop and remove the Docker environment"
	@echo "  make start                 Start existing stopped containers"
	@echo "  make stop                  Stop containers without removing them"
	@echo "  make restart               Restart the Docker environment"
	@echo "  make status                Show container status"
	@echo "  make logs                  Show container logs"
	@echo ""
	@echo "WordPress:"
	@echo "  make setup                  Install WordPress"
	@echo "  make wp CMD=\"...\"            Run a WP-CLI command"
	@echo "  make wp-shell               Open a shell in the WP-CLI container"
	@echo ""
	@echo "PHP:"
	@echo "  make php                    Open a shell in the PHP container"
	@echo "  make composer CMD=\"...\"      Run a Composer command"
	@echo ""
	@echo "Development:"
	@echo "  make dev                    Open iTerm with development panes"
	@echo "  make test                   Run project tests"
	@echo "  make browser                Open the site in Chrome"
	@echo "  make mail                   Open Mailpit in Chrome"
	@echo "  make database               Open phpMyAdmin in Chrome"
	@echo ""
	@echo "Services:"
	@echo "  WordPress                   https://$${DOMAIN}"
	@echo "  phpMyAdmin                  http://localhost:8180"
	@echo "  Mailpit                     http://localhost:8025"
	@echo ""

# ---------------------------------------------------------------------------
# Environment
# ---------------------------------------------------------------------------

up: ## Start the Docker environment
	docker compose up -d

down: ## Stop and remove the Docker environment
	docker compose down

start: ## Start existing stopped containers
	docker compose start

stop: ## Stop containers without removing them
	docker compose stop

restart: ## Restart the Docker environment
	docker compose down
	docker compose up -d

status: ## Show container status
	docker compose ps

logs: ## Show Docker logs
	docker compose logs -f

# ---------------------------------------------------------------------------
# WordPress
# ---------------------------------------------------------------------------

setup: ## Install WordPress
	./scripts/wordpress.sh

wp: ## Run a WP-CLI command: make wp CMD="plugin list"
	docker compose run --rm wp $(CMD)

wp-shell: ## Open a shell in the WP-CLI container
	docker compose run --rm --entrypoint /bin/sh wp

# ---------------------------------------------------------------------------
# PHP
# ---------------------------------------------------------------------------

php: ## Open a shell in the PHP container
	docker compose exec php sh

composer: ## Run a Composer command: make composer CMD="install"
	docker compose exec php composer $(CMD)

# ---------------------------------------------------------------------------
# Development
# ---------------------------------------------------------------------------

dev: ## Open iTerm with three development panes
	osascript scripts/macos/dev-terminal.applescript

test: ## Run project tests
	./scripts/test.sh

browser: ## Open the site in Chrome
	open -a "Google Chrome" "https://$(DOMAIN)"

network-admin:
	open -a "Google Chrome" "https://$(DOMAIN)/wp-admin/network/"

mail: ## Open Mailpit in Chrome
	open -a "Google Chrome" "http://localhost:8025"

database: ## Open phpMyAdmin in Chrome
	open -a "Google Chrome" "http://localhost:8180"