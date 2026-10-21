# Docker Commands

## Docker Compose — everyday

```bash
# Start the environment
docker compose up -d

# Stop the environment
docker compose down

# Restart
docker compose restart

# See running containers
docker compose ps

# Start/recreate after configuration changes
docker compose up -d

# Follow logs
docker compose logs -f

# Follow logs for one service
docker compose logs -f nginx
docker compose logs -f php
docker compose logs -f mysql
```

## Debugging

```bash
# Validate the Compose file
docker compose config

# See logs from a service
docker compose logs nginx

# See the last 100 lines
docker compose logs --tail=100 nginx

# See container status
docker compose ps

# Inspect a container
docker inspect wordpress-docker-nginx-1

# See processes inside a container
docker compose top nginx

# See resource usage
docker stats
```

### Check what's using a port

This was particularly useful when port 80 was already occupied:

```bash
lsof -i :80
```

Or:

```bash
lsof -i :443
```

You can then identify what's listening:

```bash
lsof -nP -iTCP:80 -sTCP:LISTEN
```

---

## Building images

```bash
# Build everything
docker compose build

# Build one service
docker compose build php

# Rebuild without cache
docker compose build --no-cache php

# Build and start
docker compose up -d --build
```

If something strange is happening during an image build, `--no-cache` is useful for ruling out stale build layers.

---

## Getting inside containers

```bash
# PHP container
docker compose exec php sh

# Nginx container
docker compose exec nginx sh

# MySQL container
docker compose exec mysql sh
```

For your WP-CLI container, because `wp` is the entrypoint, we used:

```bash
docker compose run --rm --entrypoint /bin/sh wp
```

That's an important distinction:

* `exec` → enter an **already running** container
* `run` → create a **temporary container** from the service

---

## Testing PHP

```bash
docker compose exec php php -v

docker compose exec php php -m

docker compose exec php php -i
```

Check a specific PHP setting:

```bash
docker compose exec php php -i | grep memory_limit
```

Check Composer:

```bash
docker compose exec php composer --version
```

Check Xdebug:

```bash
docker compose exec php php -m | grep xdebug
```

---

## Testing WordPress / WP-CLI

Your Makefile makes these nicer:

```bash
make wp CMD="core version"
make wp CMD="core is-installed"
make wp CMD="plugin list"
make wp CMD="theme list"
make wp CMD="db check"
```

But the underlying Docker command is:

```bash
docker compose run --rm wp core version
```

The `--rm` is useful because the temporary WP-CLI container is removed afterwards.

---

## Database

Check MySQL is healthy:

```bash
docker compose ps
```

You should see:

```text
healthy
```

You can also enter MySQL:

```bash
docker compose exec mysql mysql -uwordpress -pwordpress wordpress
```

Although for normal WordPress development I'd generally use WP-CLI:

```bash
make wp CMD="db check"
```

---

## Inspecting volumes

List volumes:

```bash
docker volume ls
```

Inspect your database volume:

```bash
docker volume inspect wordpress-docker_dbdata
```

This is useful when you're trying to understand **where persistent data actually lives**.

---

## Networks

```bash
# List Docker networks
docker network ls

# Inspect your Compose network
docker network inspect wordpress-docker_wordpress
```

This becomes particularly useful when debugging things like:

```text
PHP can't connect to MySQL
Nginx can't connect to PHP
WordPress can't resolve mysql
```

Remember that containers communicate using **service names**, so:

```text
mysql
```

is the database hostname from another container.

---

## Clean-up

Useful, but be careful with these.

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused Docker resources
docker system prune
```

**Don't casually use `docker volume prune`** with development environments. Volumes can contain your database.

And:

```bash
docker compose down -v
```

is particularly destructive for this project because it removes the Compose volumes — meaning **your WordPress database will be deleted**.

---

# The small set I'd actually remember

You don't need to memorise all of those. I'd remember these:

```bash
docker compose up -d
docker compose down
docker compose ps
docker compose logs -f nginx
docker compose logs -f php
docker compose config
docker compose exec php sh
docker compose exec php php -v
docker compose build
docker compose up -d --build
docker compose run --rm wp core version
```

And on your Mac:

```bash
lsof -i :80
lsof -i :443
```
