# Dockerfile para crear la imagen del servicio WEB con Dolibarr

FROM php:7.4-apache

MAINTAINER McArce <jmcarce@XXXXXXX.XXX>

ENV DOLIBARR_INSTALL_AUTO 1

ENV DOLIBARR_DB_HOST mariadb
ENV DOLIBARR_DB_USER dolibarr_user
ENV DOLIBARR_DB_PASSWORD dolibarr_user_password
ENV DOLIBARR_DB_NAME dolibarr_db

ENV DOLIBARR_ADMIN_LOGIN admin
ENV DOLIBARR_ADMIN_PASSWORD admin
ENV DOLIBARR_URL_ROOT 'http://localhost'
ENV DOLIBARR_NOCSRFCHECK 0

ENV WWW_USER_ID 33
ENV WWW_GROUP_ID 33

ENV PHP_INI_DATE_TIMEZONE 'Europe/Madrid'
ENV PHP_INI_MEMORY_LIMIT 256M
ENV PHP_INI_DIR /usr/local/etc/php

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libldap2-dev \
        libxml2-dev \
        libzip-dev \
        default-mysql-client \
        unzip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) calendar intl mysqli pdo_mysql gd soap zip \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) ldap && \
    mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

ENV DOLIBARR_VERSION 12.0.2

COPY dolibarr-${DOLIBARR_VERSION}.zip /tmp/dolibarr.zip

RUN unzip -q -UU /tmp/dolibarr.zip -d /tmp/dolibarr/ \
	&& cp -r /tmp/dolibarr/dolibarr-${DOLIBARR_VERSION}/htdocs/* /var/www/html/ \
	&& ln -s /var/www/html /var/www/htdocs \
	&& cp -r /tmp/dolibarr/dolibarr-${DOLIBARR_VERSION}/scripts /var/www/ \
	&& rm -rf /tmp/* \
	&& mkdir -p /var/www/documents \
	&& chown -R www-data:www-data /var/www

EXPOSE 80
VOLUME /var/www/documents

COPY docker-run.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-run.sh"]