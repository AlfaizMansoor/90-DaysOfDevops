#!/bin/bash

greet() {
	read -p "Enter your good name: " name
	echo "Hello, $name"
}

greet

add() {
	read -p "Enter first number: " n1
	read -p "Enter second number: " n2
	sum=$((n1 + n2))
	echo "total is : $sum"
}

add 
