#!/bin/bash
# Se recorre el listado de cursos y para cada curso se obtiene su ID y su shortname 
# Los cursos se exportan como shortname.mbz 
# La ruta donde se dejan las copias de seguridad se indica en donde se ejecuta course-backup TO-DO:Convertir en parámetro
#
# Código en github: https://github.com/catedu/fp-distancia-courses-backup
#


# Se obtiene el listado de cursos
CURSOS=`moosh -n -p /var/www/html course-list`

# Para cada curso previamente obtenido
while IFS= read -r linea; do
  echo "-> $linea <-";
  # Obtengo el ID procesando la línea

  ID=`echo $linea | cut -d , -f 1`
  # Obtengo el shortname procesando la línea
  SHORTNAME=`echo $linea | cut -d , -f 3`

  # Al ID le quito aquello que sobra
  echo "ID: $ID"
  ID=`echo "$ID" | sed 's/^.//;s/.$//'`
  echo "ID: $ID"

  # Al shortname le quito aquello que sobra
  echo "Shortname: $SHORTNAME"
  SHORTNAME=`echo "$SHORTNAME" | sed 's/^.//;s/.$//'`

  # Creo el nombre del fichero
  NOMBRE=`echo ${SHORTNAME}.mbz`
  echo "NOMBRE: $NOMBRE"

  # Realizo la exportanción del curso de id $ID en la ruta indicada con el nombre $NOMBRE creado
  moosh -n -p /var/www/html course-backup -F -f /var/www/html/zz_mbzs_20210920/$NOMBRE $ID
done <<< "$CURSOS"
