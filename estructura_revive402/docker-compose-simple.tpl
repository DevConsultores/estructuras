################################################################################
# Docker compose Drupal full dev stack.
#
# A single Docker compose file that try to simply and quickly setup a full
# Drupal development environment.
#
# Project page:
#   https://github.com/Mogtofu33/docker-compose-drupal
#
# Quick set-up:
#  Copy this file, rename to docker-compose.yml, comment or remove services
#  definition based on your needs.
#  Copy and rename default.env to .env
#  Launch:
#    docker-compose up
#
# You can check your config after editing this file with:
#   docker-compose config
#
# Services settings are in config folder, check and adapt to your needs.
#
# For more information on docker compose file structure:
# @see https://docs.docker.com/compose/
#
################################################################################
version: '2'
services:
  ## Optionnal Docker ui, uncomment to enable.
  nginx:
    image: mogtofu33/nginx-dev
    container_name: nginxd7stack
    networks:
      - proxy-tier
    expose:
      - "80"
      - "443"
    links:
      ## Choose database.
       - mysql
      # - pgsql
      ## Choose optionnal services.
      # - memcache
      # - solr
      # - mailhog
       - phpfpm
    volumes:
      - ${HOST_WEB_ROOT}:/www
      - ./config/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ${HOST_LOGS_ROOT}:/var/log/nginx
      - ./config/drush:/etc/drush
    env_file: .env
    environment:
      - CONTAINER_NAME=nginxd7stack
      - VIRTUAL_HOST=urologo.devconsultores.com
      - VIRTUAL_PORT=80
      - VIRTUAL_NETWORK=nginx-proxy
    restart: always
  phpfpm:
    image: mogtofu33/phpfpm:1.${PHP_VERSION}
    networks:
      - proxy-tier
    expose:
      - "9000"
    links:
      ## Choose database.
       - mysql
      # - pgsql
      ## Choose optionnal services.
      # - memcache
      # - solr
      #- mailhog
    volumes:
      - ${HOST_WEB_ROOT}:/www
      - ./config/php${PHP_VERSION}/php-fpm.conf:/etc/php/php-fpm.conf
      - ./config/php${PHP_VERSION}/conf.d:/etc/php/conf.d
      - ${HOST_LOGS_ROOT}:/var/log/php
    env_file: .env
    environment:
      - CONTAINER_NAME=phpfpm
    restart: always
  mysql:
    image: mogtofu33/mariadb:latest
    networks:
      - proxy-tier
    expose:
      - "3306"
    volumes:
      - ${HOST_LOGS_ROOT}:/var/log/mysql
      ## Comment these two lines on Windows system, permissions issue.
      - ${HOST_DATABASE_MYSQL}:/var/lib/mysql
      - ./config/mysql:/etc/mysql
    env_file: .env
    environment:
      - CONTAINER_NAME=mysql
    restart: always
  #pgsql:
    #image: mogtofu33/postgres:latest
    #expose:
    #  - "5432"
    ## Comment these two lines on Windows system, permissions issue.
    #volumes:
    #  - ${HOST_DATABASE_POSTGRES}:/var/lib/postgresql/data
    #env_file: .env
    #environment:
    #  - CONTAINER_NAME=pgsql
    #restart: always
  #mailhog:
    #image: diyan/mailhog:latest
    #expose:
    #  - "1025"
    #ports:
    #  - "${MAILHOG_HOST_PORT}:8025"
    #env_file: .env
    #environment:
    #  - CONTAINER_NAME=mailhog
    #restart: always
  #memcache:
    #image: bpressure/alpine-memcached:latest
    #expose:
    #  - "11211"
    #environment:
    #  - CONTAINER_NAME=memcache
    #restart: always
  #solr:
    #image: mogtofu33/solr:latest
    #ports:
    #  - "${SOLR_HOST_PORT}:8983"
    #volumes:
    #  - ${HOST_LOGS_ROOT}:/var/log/solr
    #env_file: .env
    #environment:
    #  - CONTAINER_NAME=solr
    #restart: always
  # varnish:
    # build: ./build/varnish
    # ports:
      # - "${VARNISH_HOST_PORT}:80"
      # - "${VARNISH_HOST_TERMINAL_PORT}:6082"
    # links:
      # - apache
    # volumes:
      # - ${HOST_LOGS_ROOT}:/var/log/varnish
    # env_file: .env
    # environment:
      # - CONTAINER_NAME=varnish
    # restart: always
  # ldap:
    # image: osixia/openldap:latest
    # ports:
      # - "${LDAP_HOST_PORT}:389"
    # restart: always
    # env_file: .env
    # environment:
      # - CONTAINER_NAME=ldap
    # restart: always
  # ldapadmin:
    # image: osixia/phpldapadmin:latest
    # links:
      # - ldap
    # ports:
      # - "${PHPLDAPADMIN_HOST_PORT}:443"
    # env_file: .env
    # environment:
      # - CONTAINER_NAME=ldapadmin
    # restart: always
networks:
  proxy-tier:
    external:
      name: nginx-proxy
