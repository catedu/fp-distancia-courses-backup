#!/bin/bash
# Se recorre el listado de cursos y para cada curso se obtiene su ID y su shortname 
# Los cursos se exportan como shortname.mbz 
# La ruta donde se dejan las copias de seguridad se indica en donde se ejecuta course-backup TO-DO:Convertir en parámetro
#
# Código en github: https://github.com/catedu/fp-distancia-courses-backup
#

#
LOCALROOT=$(pwd)
DATE=$( date -u +"%Y%m%d" )
DESTINO="${LOCALROOT}/zz_mbzs_${DATE}"
FECHA_HORA_INI=$( date -u +"%Y/%m/%d %H:%M:%S" )

echo "${DESTINO}"
echo "$DESTINO"

# Creo la ruta donde dejaté los ficheros
[ ! -d ${DESTINO} ] && sudo mkdir -p ${DESTINO}

# Se obtiene el listado de cursos quitando la 1era línea
CURSOS=`moosh -n -p /var/www/html course-list | tail -n +2`

# Para cada curso previamente obtenido
while IFS= read -r linea; do
  echo "Procesando la línea:"
  echo "-> $linea <-";
  # Obtengo el ID procesando la línea

  ID=`echo $linea | cut -d , -f 1`
  # Obtengo el shortname procesando la línea
  SHORTNAME=`echo $linea | cut -d , -f 3`

  # Al ID le quito aquello que sobra
  # echo "ID: $ID"
  ID=`echo "$ID" | sed 's/^.//;s/.$//'`
  # echo "ID: $ID"

  # Al shortname le quito aquello que sobra
  #echo "Shortname: $SHORTNAME"
  SHORTNAME=`echo "$SHORTNAME" | sed 's/^.//;s/.$//'`

  # Creo el nombre del fichero
  NOMBRE=`echo ${SHORTNAME}.mbz`
  #echo "NOMBRE: $NOMBRE"
  
  # Realizo la exportanción del curso de id $ID en la ruta indicada con el nombre $NOMBRE creado
  # siempre que no exista ya un fichero con ese nombre
  NOW=$( date -u +"%Y/%m/%d %H:%M:%S" )
  echo "${NOW} Exportando el curso ${SHORTNAME} (id $ID)... (se paciente, hay cursos de gran tamaño)"
  [ ! -f ${DESTINO}/$NOMBRE ] && moosh -n -p /var/www/html course-backup -F -f ${DESTINO}/$NOMBRE $ID
done <<< "$CURSOS"

FECHA_HORA_FIN=$( date -u +"%Y/%m/%d %H:%M:%S" )

echo "Empezó ${FECHA_HORA_INI}"
echo "Terminó ${FECHA_HORA_FIN}"
echo "Proceso terminado"