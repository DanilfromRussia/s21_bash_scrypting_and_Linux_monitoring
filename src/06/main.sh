#!/bin/bash

if [ $# != 0 ]
then
    echo "Скрипт запускается без параметров."
    exit 1
else
    goaccess ../04/*.log --log-format=COMBINED > index.html
    mkdir ~/www 2>/dev/null # "2>/dev/null" подавление вывода сообщений об ошибках.
    mkdir ~/www/goaccess 2>/dev/null
    cp ./index.html ~/www/goaccess
fi

# Доступ с локалки:
# 1. В файле nginx.conf в пунтк server { root } добавить значение "/home/coruscan/www/;"
# 2. Пробросить порты VirtualBox (см. здесь https://losst.pro/probros-portov-virtualbox).
