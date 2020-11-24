# Dockerfile para crear la imagen del servicio WEB con Dolibarr

FROM php:7.4-apache

LABEL maintainer="McArce <jmcarce@XXXXXXX.XXX>"

ENV DOLIBARR_INSTALL_AUTO 1

# ARG para usar las variables de entorno definidas en el archivo .env
ARG DOLIBARR_DB_HOST
ARG DOLIBARR_DB_USER
ARG DOLIBARR_DB_PASSWORD
ARG DOLIBARR_DB_NAME

ARG DOLIBARR_ADMIN_LOGIN
ARG DOLIBARR_ADMIN_PASSWORD

ARG DOLIBARR_URL_ROOT

# Variables de entorno para la imagen
ENV DOLIBARR_NOCSRFCHECK 0

ENV WWW_USER_ID 33
ENV WWW_GROUP_ID 33

ENV PHP_INI_DATE_TIMEZONE 'Europe/Madrid'
ENV PHP_INI_MEMORY_LIMIT 256M
ENV PHP_INI_DIR /usr/local/etc/php

# Instalar librerias de PHP
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

# Copiar archivo comprimido de Dolibarr en directorio /tmp/ de la imagen
ENV DOLIBARR_VERSION 12.0.2
COPY dolibarr-${DOLIBARR_VERSION}.zip /tmp/dolibarr.zip

# Extraer los archivos del archivo dolibarr.zip en /tmp/dolibarr y copiarlos en el servidor apache
RUN unzip -q -UU /tmp/dolibarr.zip -d /tmp/dolibarr/ \
	&& cp -r /tmp/dolibarr/dolibarr-${DOLIBARR_VERSION}/htdocs/* /var/www/html/ \
	&& ln -s /var/www/html /var/www/htdocs \
	&& cp -r /tmp/dolibarr/dolibarr-${DOLIBARR_VERSION}/scripts /var/www/ \
	&& rm -rf /tmp/* \
	&& mkdir -p /var/www/documents \
	&& chown -R www-data:www-data /var/www

# El servidor apache abre el puerto 80 para comunicarse
EXPOSE 80

# Se crea el volumen dolibarrvolume para los documentos (iconos, fotografias...)
# VOLUME dolibarrvolume:/var/www/documents

# Copiar en la imagen el archivo de arranque para el contenedor docker-run.sh
COPY docker-run.sh /usr/local/bin/

# Iniciar por defecto el contenedor con el archivo docker-run.sh
ENTRYPOINT ["/usr/local/bin/docker-run.sh"]