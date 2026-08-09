#!/bin/bash

set -euo pipefail
main() {
	host_os() {
		echo -e "\n Hostname"
		hostname -i
		echo -e "\n OS"
		uname -r
	}
	

	uptime_func() {
		echo -e "\n time :"; uptime
	}
	

	disk_usage() {
		echo -e "\n disk usage:  "
		df -h | sort -hr | head -n 5
	}		
	

	memory_usage() {
		echo -e "\nmemory usage:"
		free -h
	}
	

	process() {
		echo -e "\n processes; "
		top | sort -hr | head n -3
	}
	}
main
host_os
uptime_func
disk_usage
memory_usage
process
