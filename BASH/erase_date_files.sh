#! /bin/bash

read -p "¿Cual es la antigüedad de los ficheros a eliminar? (ej: 30 (para elimar ficheros de más de 30 días)): " dias

for archivo in `find ./ -ctime +$dias`;
do
  rm $archivo
done
