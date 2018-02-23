FROM php:5-fpm

MAINTAINER contacto@devconsultores.com

ENV TERM		   xterm

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	libmemcached-dev zlib1g-dev libssl-dev zip \
    && docker-php-ext-install -j$(nproc) mysqli json opcache mysql pdo pdo_mysql calendar \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd 
RUN pecl install redis \
   && docker-php-ext-enable redis
RUN pecl install mongo \
   && docker-php-ext-enable mongo
RUN pecl install mongodb \
   && docker-php-ext-enable mongodb
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN export PATH="$HOME/.composer/vendor/bin:$PATH"
RUN composer global require drush/drush
RUN echo "date.timezone = America/Mexico_City" > /usr/local/etc/php/conf.d/timezone.ini
