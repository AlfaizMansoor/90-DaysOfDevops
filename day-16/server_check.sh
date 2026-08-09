#!/bin/bash

service="nginx"
read -p "do you want to check service? (y/n)" reply
if [ "$reply" = "y" ]
then 
	systemctl status $service
	exit
elif [ "$reply" = "n" ]
then
	echo "Skipped"
else 
	echo "irrelevant reply"
fi
