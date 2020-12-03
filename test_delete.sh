#!/usr/bin/env bash

if [[ -d ~/test ]];then
    echo "*** Borrando directorio existente ~/test ***"
    rm -r ~/test
fi

#borrar todos los contenedores
docker rm $(docker ps -a -q) -f

#borrar todos los volumes
docker volume prune -f

#borrar imagen test_web:latest anterior
docker rmi test_web:latest

#Comprobar que todo se ha borrado
echo "*** CONTENEDORES ACTUALES ***"
docker ps -a
echo "*** IMAGENES ACTUALES ***"
docker images
echo "*** VOLUMENES ACTUALES ***"
docker volume ls
