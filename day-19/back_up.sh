#!/bin/bash

set -euo pipefail
back_up() {
	Source="$1"
	Destination="$2"
	if [ $# -ne 2 ]
	then
		echo "use $0 "
	       exit 1
	fi

	
	if [ -z "$Source" ] || [ -z "$Destination" ]
	then 
		echo "Error: Missing arguments!"
		echo "Usage: $0 <source_directory> <backup_destination>"
        	exit 1
	fi

	if [ -d "$Source" ]
	then
		echo -e "\n $Source diirectory exists!!! \n"
		TIMESTAMP=$(date +%Y-%m-%d)
		tar -czf ${Destination}_${TIMESTAMP}.tar.gz $Source
		echo -e "\n printing name and size \n"
		du -h "${Destination}_${TIMESTAMP}.tar.gz"
		find "${Destination}_${TIMESTAMP}.tar.gz" -type f -name "*.tar.gz" -exec ls -lh {} \; | wc -l
		echo -e \n "Deleting 14 DAYS OLD backup!"
		find "$Destination" -type f -name "*.tar.gz" -mtime +14 -print -delete | wc -l
	elif [ ! -d "$Source" ]
	then
		echo -e "\n Something went wrong!!!"
		exit 1
	fi

}

back_up "$1" "$2"
