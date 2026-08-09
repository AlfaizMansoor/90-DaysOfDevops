#!/bin/bash

if [ "$1"="$STRING" ]
then
	echo "Hello, $1"
elif [ "$1"="" ]
then
	echo "Usage:./greet.sh"
else
	echo "Something went wrong"
fi
