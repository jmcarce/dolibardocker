#!/usr/bin/env bash

# Versión de Dolibarr que se va a instalar, comprobar la misma en "web/Dockerfile"
DOLI_VERSION="12.0.3"

# Descargar desde github los archivos del proyecto


# Crear la carpeta 'data' en ./maria/ db para usarla como bind mount de la base de datos
if [[ ! -d ./mariadb/data ]]; then
    echo "[INIT] => crear carpeta para volume ./mariadb/data ..."
    mkdir -p ./mariadb/data
fi

# Crear la carpeta 'documents' en ./web/ db para usarla como bind mount de documentos de dolibarr
if [[ ! -d ./web/documents ]]; then
    echo "[INIT] => crear carpeta para volume ./web/documents ..."
    mkdir -p ./web/documents
fi

# Descargar el archivo fuente de Dolibarr .zip utlizado para crear la imagen Docker
if [[ ! -f ./web/dolibarr-$DOLI_VERSION.zip ]]; then
wget -O./web/dolibarr-$DOLI_VERSION.zip https://github.com/Dolibarr/dolibarr/archive/$DOLI_VERSION.zip 
fi

# Si no existe '.env', utilizar example.env como archivo de variables para contenedor web
if [[ ! -f ./web/.env ]]; then
    ln -s example.env ./web/.env
fi

# Si no existe '.env', utilizar example.env como archivo de variables para contenedor mariadb
if [[ ! -f ./maria/.env ]]; then
    ln -s example.env ./mariadb/.env
fi

docker-compose up