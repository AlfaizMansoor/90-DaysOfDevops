#!/bin/bash

read -p "Enter file name " file_name
if [ -f "$file_name" ]
then
	echo "$file_name is already exists"
else
	echo "make a new file"
fi
