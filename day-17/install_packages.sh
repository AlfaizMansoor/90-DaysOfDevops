#!/bin/bash 

packages="nginx curl wget"
for package in $packages
do
	echo "Checking $package"

	if dpkg -s "$package" >/dev/null 2>&1
	then
		echo "$package is already installed, skipping"
	else
		echo "$package is not installed, installing..."
		sudo apt update
		sudo apt install -y "$package"
	fi
	echo "$package is ready for work"
done
