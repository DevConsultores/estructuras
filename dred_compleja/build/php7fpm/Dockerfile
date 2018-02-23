FROM php:7-fpm

MAINTAINER contacto@devconsultores.com

ENV TERM		   xterm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	libmemcached-dev zlib1g-dev zip \
    && docker-php-ext-install -j$(nproc) mysqli pdo_mysql json opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require drush/drush
RUN export PATH="$HOME/.composer/vendor/bin:$PATH"
RUN echo "date.timezone = America/Mexico_City" > /usr/local/etc/php/conf.d/timezone.ini
