#!/bin/bash

local_var() {
	local NUM=100
	echo "the number is $NUM"
}

local_var
echo "the number is $NUM"

echo -e "\n $NUM is local variable, its doesn't show the value of variable outside the function."

regular_var() {
	num=400
	echo "the number is $num"
}

regular_var
echo "the number is $num"

echo -e "\n $num is regular variable so it allows to display the value of regular variable"

