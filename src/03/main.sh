#!/bin/bash
if [ -z $1 ]; then exit 1; fi
if [[ ! "$1" =~ ^[1-3]$ ]]; then exit 1; fi
if [ -z $(ls $2 | grep log.txt) ]; then exit 1; fi
#указываем путь до директории где лежит log.txt 2м параметром

function delFromLogs {
	ElemToDelForSed="${ElemToDel//\//\\/}" # экранировал '/', чтобы sed не ругался.
	sed -i "/$ElemToDelForSed/d" "$2/log.txt" # стер логи, связанные с $ElemToDel
}


if (( $1 == 1 )); then # этот спосоюб позволяет удалить директории, расположенные по 1 пути (после не более 1 запуска),
		       # однако для повторного удаления вам достаточно удалить строки в log.txt, связанные с прошлой директорией.
	PathToDel=$(cat "$2/log.txt" | grep "Path:" | awk '{ print $2 }' | awk '(NR==1)')
	echo "Вы собираетесь удалить $PathToDel. Вы уверены? "[Y/N]"";read yourStdin
	if [[ $yourStdin == 'y' || $yourStdin == 'Y' ]]; then
		rm -rf $PathToDel
		delFromLogs $PathToDel $2
	else
		exit 1
	fi
elif (( $1 == 2 )); then
	echo "Введите дату, вплоть до минут, с которой я начну удалять ранее созданные файлы в формате 12/15/22_00:39";read delStart
	echo "Теперь дату, до которой, согласно log.txt, я удалю файлы и директории в формате 12/15/22_00:40";read delEnd
	echo "Обратите внимание, что для счета секунд в промежутке используется "00". В случае с примером выше, удалятся файлы, созданные с 12/15/22_00:39:00 по 12/15/22_00:40:00. Хотите продолжить? "[Y/N]"";read yourStdin
	if [[ $yourStdin == 'y' || $yourStdin == 'Y' ]]; then
		SampleDel="${delStart%:*}:" # $delStart до ':'
		StartMinutes="${delStart#*:}" # $delStart после ':'
		if (( ${StartMinutes:0:1} == 0 )); then StartMinutes="${StartMinutes#*0}"; fi
		EndMinutes="${delEnd#*:}"  # $delEnd после ':'
		if (( ${EndMinutes:0:1} == 0 )); then EndMinutes="${EndMinutes#*0}"; fi
		
		for (( i=$StartMinutes; i<$EndMinutes; i++ ))
		    do
		    	while true
		    	    do
				ElemToDel=$(cat "$2/log.txt" | grep "$SampleDel$i" | awk '{ print $2 }' | awk "(NR==1)")
				if [ $ElemToDel ]; then
					echo "Вы собираетесь удалить $ElemToDel. Вы уверены? "[Y/N]"";read yourStdin
					if [[ $yourStdin == 'y' || $yourStdin == 'Y' ]]; then
						rm -rf $ElemToDel
						delFromLogs $ElemToDel $2
					else
						exit 1
					fi
				else
					break
				fi
			    done
		    done
	else
		exit 1
	fi

else # $1 = 3 100%
	echo "Выберите, что вы хотите удалить: file - 1, directory - 2";read yourStdin
	if (( $yourStdin == 1 )); then
		echo "Введите полное имя файла с расширением";read yourStdin
		StringNumber=$(grep -n $yourStdin "$2/log.txt" | awk '(NR==1)' | grep -o '^[^:]*')
		PathToDel=$(cat "$2/log.txt" | awk "(NR==$(($StringNumber + 2)))" | awk '{ print $2 }')
		echo "Вы собираетесь удалить "$PathToDel/$yourStdin". Вы уверены? "[Y/N]"";read yourWrite
		if [[ $yourWrite == 'y' || $yourWrite == 'Y' ]]; then
			rm -rf "$PathToDel/$yourStdin"
			sed -i "/$yourStdin/d" "$2/log.txt"
		else
			exit 1
		fi
	elif (( $yourStdin == 2 )); then
		echo "Введите имя директории, которую требуется удалить";read yourStdin
		PathToDel=$(cat "$2/log.txt" | grep $yourStdin | awk '{ print $2 }' | awk '(NR==1)')
		echo "Вы собираетесь удалить $PathToDel. Вы уверены? "[Y/N]"";read yourStdin
		if [[ $yourStdin == 'y' || $yourStdin == 'Y' ]]; then
			rm -rf $PathToDel
			delFromLogs $PathToDel $2
		else
			exit 1
		fi
	fi
fi
