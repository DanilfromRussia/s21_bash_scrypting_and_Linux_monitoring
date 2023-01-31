#!/bin/bash
if [ -z $3 ]; then exit 1; fi
if (( ${#1} > 7 )); then exit 1; fi
if [[ `echo $1 | tr -d [:alpha:]` ]]; then exit 1; fi
behindDot=$(echo $2 | grep -o '^[^.]*') # если точки не будет - аргумент целиком
afterDot=${2:${#behindDot}} # индексирование
timeformat=$(date +"%d%m%Y")
logPath=$(pwd | sed 's/$/\/log.txt/')
sizeNum=$(echo $3 | grep -o '^[^M]*')
if [[ `echo $behindDot | tr -d [:alpha:]` ]]; then exit 1; fi
if [[ `echo $afterDot | tr -d [:alpha:]` != "." ]]; then exit 1; fi
if [[ `echo $3 | sed 's/.*b//'` ]]; then exit 1; fi
if (( $sizeNum < 1 || $sizeNum > 100 )); then exit 1; fi

pathTo=$(./dirGen.sh)
cd $pathTo # перешли в рандомную папку, с этого момента все операции там

function getName {
	ZeroSymb=$(echo ${1:0:1})
	returnable=$1
	if (( ${#1} < 4 )); then
		returnable=$(echo $1 | sed -n "s/$ZeroSymb/$ZeroSymb$ZeroSymb$ZeroSymb$ZeroSymb/p")
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
		echo "Filesize: $sizeNum Mb">>$logPath
	fi
	echo "Path: $(pwd)">>$logPath
	echo "Created: $(date +"%D %H:%M:%S")">>$logPath
	echo "__________________________________________">>$logPath
}

subfoldersNum=$(($RANDOM % 101))

nameDir=$1
nameFile=$behindDot
	for (( i=0; i<$subfoldersNum; i++ ))
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
		fileNum=$(($RANDOM % 101))
		for (( j=0; j<$fileNum; j++ ))
		do
			if (( $j == 0 )); then
				nameFile=$(getName $nameFile yes)
				# 2 args mean, that we need timeformat in the end
				nameFile=$(echo $nameFile | sed "s/$/$afterDot/")

			else
				nameFile=$(getName $nameFile)
			fi

			fallocate -l $3 $nameFile
			logCreating $nameFile
			if [[ ! $(df -h | grep /dev/sda | awk '{print $4}' | grep G) ]]; then
				echo "Clear the memory."
				exit 1
			fi
		done
	done

