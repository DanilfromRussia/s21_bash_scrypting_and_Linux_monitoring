#!/bin/bash
source ./monitoring.sh

FILES="../04/*.log" # ../04/01.log ../04/02.log ../04/03.log ../04/04.log ../04/05.log

function check_input {
    if [ $# != 1 ] || ! [[ $1 =~ ^[1-4]$ ]]; then
        echo "Скрипт запускается с 1 параметром, который принимает значение 1, 2, 3 или 4."
        echo "В зависимости от значения параметра вывести:"
        echo "1. Все записи, отсортированные по коду ответа"
        echo "2. Все уникальные IP, встречающиеся в записях"
        echo "3. Все запросы с ошибками (код ответа - 4хх или 5хх)"
        echo "4. Все уникальные IP, которые встречаются среди ошибочных запросов"
        exit 1
    elif [[ $1 = 1 ]]; then
        sort_by_code $FILES
    elif [[ $1 = 2 ]]; then
        print_unic_ip $FILES
    elif [[ $1 = 3 ]]; then
        print_errors $FILES
    elif [[ $1 = 4 ]]; then
        print_unic_ip_of_errors $FILES
    fi
}
