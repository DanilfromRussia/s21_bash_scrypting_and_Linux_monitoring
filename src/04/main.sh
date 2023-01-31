#!/bin/bash
source ./generator.sh # source - аналог include

if [ $# != 0 ] # $# - число аргументов при запуске скрипта
then
    echo "Скрипт запускается без параметров!"
    exit 1
else
    TODAY=$(date -d "`date +%D`" +%s) # %s - число секунд с 1970-01-01 00:00:00 UTC
    				      # date +%D нужна как строка, для подстановки в "date -d"
    for (( num=1; num<=5; num++ ))
    do
        generate_log "0$num" $TODAY
        TODAY=$(( $TODAY - 86400 ))
    done
fi
