#!/bin/bash

check_disk() {
	df -h 
}

check_memory() {
	free -h
}

check_disk
echo -e "this is disk memory \n"
check_memory
echo -e "this is free memory \n"
