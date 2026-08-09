#!/bin/bash

read -p "write a number = " number
if [ $number -eq 0 ]
then
	echo "$number is equal to 0"
elif [ $number -lt 0 ]
then
	echo "$number is negative (-)"
elif [ $number -gt 0 ]
then
	echo "$number is positive (+)"
else
	echo "given data is irrelevant"
fi
