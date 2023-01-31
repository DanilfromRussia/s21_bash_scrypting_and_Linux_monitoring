#!/bin/bash
function sort_by_code {
    awk '{print $0}' $@ | sort -k9 -n
    # сортировка по нумерации(-n) в 9 столбце(-k9),
    # $@ служит строками входных файлов, к каждой применяется регулярка
}

function print_unic_ip {
    awk '{print $0}' $@ | sort -k1,1 -u
    # In awk, $0 is the whole line of arguments
    # (-u = unique)
}

function print_errors {
    awk '$9 ~/[4,5]../{print}' $@ | sort -k9 -n
    # "~/[4,5]../" --> должно начинаться(/) с СОДЕРЖАНИЯ(~) цифры 4 или 5
}

function print_unic_ip_of_errors {
    print_errors $@ | sort -k1,1 -u
    # вызывается функция, затем результат сортируется только по первому полю, уникальности
}
