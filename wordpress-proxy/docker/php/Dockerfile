FROM php:8.4-fpm-alpine

# Copy Composer into the PHP development environment.
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install system dependencies required by WordPress and PHP extensions.
RUN apk add --no-cache \
	freetype-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libzip-dev \
	oniguruma-dev \
	icu-dev \
	mariadb-client

# Configure GD with JPEG and FreeType support.
RUN docker-php-ext-configure gd \
	--with-freetype \
	--with-jpeg

# Install PHP extensions commonly required by WordPress.
RUN docker-php-ext-install -j"$(nproc)" \
	gd \
	intl \
	mbstring \
	mysqli \
	opcache \
	zip

# Install build dependencies required to compile PECL extensions.
RUN apk add --no-cache --virtual .build-deps \
	$PHPIZE_DEPS \
	linux-headers

# Install Xdebug.
RUN pecl install xdebug \
	&& docker-php-ext-enable xdebug

# Remove build dependencies after compilation.
RUN apk del .build-deps

WORKDIR /var/www/html

EXPOSE 9000