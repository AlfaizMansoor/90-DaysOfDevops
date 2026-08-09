#!/bin/bash

set -euo pipefail
logs() {
	if [ $# -ne 1 ]
	then
		echo "use $0 "
	       exit 1
	fi


	directory="$1"
	if [ -d "$directory" ]
	then
		echo -e "Directory $directory is exists \n"
		echo -e "\n Copressing .log files from the path $directory of last 7 days; "
		count=$(find "$directory" -type f -name "*.log" -mtime +7 | wc -l)
		sudo find "$directory" -type f -name "*.log" -mtime +7 -exec gzip {} \; | wc -l
		echo -e "\n Deleting .gz files from the path $directory of files older then 30 day; "
		count=$(find "$directory" -type f -name "*.gz" -mtime +30 | wc -l)
		sudo find "$directory" -type f -name "*.gz" -mtime +30 -exec rm {} \; | wc -l
	else
		echo "ERROR...404!...SOMETHING WENT WRONG!!!"
		exit 1
	fi

}
logs /var/log
