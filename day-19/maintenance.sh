#!/bin/bash

set -euo pipefail
maintenance_logs() {
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
	logs /var/log/sssd
	
	back_up "$1" "$3"


	echo "$(date): log file" >> /var/log/maintenance.log

}
maintenance_logs 

# Script to automate adding a task
#(crontab -l 2>/dev/null; echo "* 1 * * * /devops_devuqaab/day_19/maintenance.sh") | crontab -


{
    echo "=== MAINTENANCE TASK STARTED ==="
    rotate_logs
    run_backup
    echo "=== MAINTENANCE TASK COMPLETED ==="
} 2>&1 | awk '{print "["strftime("%Y-%m-%d %H:%M:%S")"]", $0; fflush()}' >> /var/log/maintenance.log
