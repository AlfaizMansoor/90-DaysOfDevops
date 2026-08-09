#!/bin/bash

read -p "enter a number for countdown" count
while [ $count -gt 0 ]
do
	echo "Countdown starts $count"
	((count-- ))
done
