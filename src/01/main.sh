#!/bin/bash
if [[ ! $6 ]]; then exit 1
fi
cd $1
behindDot=$(echo $5 | grep -o '^[^.]*')
afterDot=${5:${#behindDot}} # ${#behindDot} является индексом, с которого начинается строка.
sizeNum=$(echo $6 | grep -o '^[^k]*')
timeformat=$(date +"%d%m%Y")
logPath=$(echo $1 | sed 's/$/\/log.txt/')
if (( `echo $?`> 0 )) || (( ${#3} > 7 )); then # $? - код возврата ошибки последней команды.
					 # Если оператор > использовать внутри [[….]], он рассматривается как оператор сравнения строк, а не чисел. Поэтому операторам > и < для сравнения чисел лучше заключить в круглые скобки.
	exit 1
elif [[ `echo $3 | tr -d [:alpha:]` ]]; then # tr -d удаляет из выражения набор [:alpha:].
	exit 1
elif (( ${#behindDot} > 7 )) || [[ ${#afterDot} > 4 ]]; then
	exit 1
elif [[ `echo $5 | tr -d [:alpha:]` != "." ]]; then
	exit 1
elif [[ `echo $2 | tr -d [:digit:]` || `echo $4 | tr -d [:digit:]` ]]; then
	exit 1
elif (( $sizeNum > 100 || $sizeNum < 1 )); then
	exit 1
elif [[ `echo $6 | sed 's/.*b//'` ]]; then # замени часть от начала строки до символа b на ничего.
	exit 1
else
	if [[ `df -h | grep /dev/sda | awk '{print $4}' | grep G` ]]; then
	# если есть место (в GB) на одном из накопителей, которые обозначаются /dev/sda{1,2,3...}

	function getName {
		ZeroSymb=$(echo ${1:0:1})
		returnable=$1
		if (( ${#1} < 3 )); then
			returnable=$(echo $1 | sed -n "s/$ZeroSymb/$ZeroSymb$ZeroSymb$ZeroSymb/p")
			#tripling the first character to guarantee the required string length
		fi
		returnable=$(echo $returnable | sed -n "s/$ZeroSymb/$ZeroSymb$ZeroSymb/p")

		if [[ $2 ]]; then
			echo $returnable | sed "s/$/_$timeformat/"
		else
			echo $returnable
		fi
	}


	function logCreating {
		if [[ $1 ]]; then
			echo "Filename: $1">>$logPath
			echo "Filesize: $sizeNum kb">>$logPath
		fi
		echo "Path: $(pwd)">>$logPath
		echo "Created: $(date +"%D %H:%M:%S")">>$logPath
		echo "__________________________________________">>$logPath
	}

		nameDir=$3
		nameFile=$behindDot
		for (( i=0; i<$2; i++ ))
		do
			if (( $i == 0 )); then
				nameDir=$(getName $nameDir yes)
				# 2 args mean, that we need timeformat in the end
			else
				nameDir=$(getName $nameDir)
			fi

			mkdir $nameDir
			cd $nameDir
			logCreating
			for (( j=0; j<$4; j++ ))
			do
				if (( $j == 0 )); then
					nameFile=$(getName $nameFile yes)
					# 2 args mean, that we need timeformat in the end
					nameFile=$(echo $nameFile | sed "s/$/$afterDot/")

				else
					nameFile=$(getName $nameFile)
				fi

				fallocate -l $6 $nameFile
				logCreating $nameFile
				if [[ ! $(df -h | grep /dev/sda | awk '{print $4}' | grep G) ]]; then
					echo "Clear the memory."
					exit 1
				fi
			done
		done
	else
		echo "Clear the memory."
		exit 1
	fi
fi

#Test case:
#скрипт запущен с 6 аргументами
#путь существует
#длина третьего аргумента меньше 8
#3 аргумент состоит из букв англ алфавита
#5 аргумент до точки меньше 8, после точки меньше 5
#при удалении англ из 5 аргумента остается точка
#аргумент 2 и аргумент 4 состоят только из цифр
#при отделении до буквы k мы имеем число от 1 до 100 и после буквы b нет ничего
#При переполнении памяти высвечивается сообщение и скрипт перестает работать

