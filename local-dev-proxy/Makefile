.PHONY: help up down restart logs ssl clean

DOMAIN ?= mylocalwild.local

help:
	@echo "Available commands:"
	@echo "  make up       Start the proxy"
	@echo "  make down     Stop the proxy"
	@echo "  make restart  Restart the proxy"
	@echo "  make logs     Show proxy logs"
	@echo "  make ssl      Generate local SSL certificate"
	@echo "  make clean    Remove generated certificates"

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
	docker compose logs -f nginx

ssl:
	mkdir -p certs
	mkcert \
		-cert-file certs/$(DOMAIN).pem \
		-key-file certs/$(DOMAIN)-key.pem \
		$(DOMAIN)

clean:
	rm -rf certs/*


# docker compose up -d --build --force-recreate