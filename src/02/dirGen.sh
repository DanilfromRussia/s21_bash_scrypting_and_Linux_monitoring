#!/bin/bash
startDir='/home'
maxPathRange=10
endPath=$startDir

for (( i=1; i<=$((1 + RANDOM % $maxPathRange)); i++ )); do
    directory=$(find "$endPath" -maxdepth 1 -type d ! -path "$endPath" -printf "%f\n" | sort -R | head -n 1)
    # ищи внутри "$endPath" не глубже, чем на 1 директорию(-maxdepth 1) только директории(-type d),
    # каждую итерацию к "$directory" НЕ(!) должен конкатенироваться "$endPath"(-path "$endPath"),
    # выводить нужно только имя ("%f"), без пути(-printf "%f\n"). sort -R указывает на рандомную директорию
    # из найденных, head -n показывает заданное количество строк(1).
    if [[ -z $directory ]]; then
    #если после итерации не удалось найти директорию(пустая строка) - остановка.
      break 1
    elif [[ $directory == "bin" || $directory == "sbin" ]]; then
      break 1
    else
      endPath=$endPath/$directory
    fi
done
cd "$endPath" && pwd
