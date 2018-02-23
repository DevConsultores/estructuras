FROM php:7-fpm

MAINTAINER contacto@devconsultores.com

ENV TERM		   xterm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	libmemcached-dev zlib1g-dev \
    && docker-php-ext-install -j$(nproc) mysqli json opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install memcached \
    && docker-php-ext-enable memcached
