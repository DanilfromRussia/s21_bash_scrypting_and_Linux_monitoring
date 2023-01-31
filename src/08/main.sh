#!/bin/bash
if [[ $@ > 0 ]]; then
    echo "Скрипт запускается без параметров."
else
    mkdir ~/www 2>/dev/null #подавление err
    mkdir ~/www/metrics 2>/dev/null #подавление err

    while true
    do
        echo "#HELP cpu CPU usage" > index.html # переписали при повторном запуске
        echo "#TYPE cpu gauge" >> index.html
        CPU_USED=`ps -aux --sort -pcpu | awk '{sum += $3} END {print sum}'`
        echo "cpu $CPU_USED" >> index.html

        echo "#HELP ram RAM usage" >> index.html
        echo "#TYPE ram gauge" >> index.html
        RAM_TOTAL=`cat /proc/meminfo | grep ^MemTotal: | awk '{print $2}'`
        RAM_FREE=`cat /proc/meminfo | grep ^MemFree: | awk '{print $2}'`
        RAM_BUFFERS=`cat /proc/meminfo | grep ^Buffers: | awk '{print $2}'`
        RAM_CACHED=`cat /proc/meminfo | grep ^Cached: | awk '{print $2}'`
        RAM_USED=$(( $RAM_TOTAL - $RAM_FREE - $RAM_BUFFERS - $RAM_CACHED ))
        echo "ram $RAM_USED" >> index.html

        echo "#HELP disk Space left on /" >> index.html
        echo "#TYPE disk gauge" >> index.html
        DISK_SPACE_LEFT=`df | grep "/$" | awk '{print $4}'`
        echo "disk $DISK_SPACE_LEFT" >> index.html

        cp index.html ~/www/metrics/
        sleep 4
    done
fi
