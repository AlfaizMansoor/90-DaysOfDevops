#!/bin/bash

set -euo pipefail
health_check() {

	 echo -e  "\n =====Memory===== \n" 
	 free -h
	 echo -e "\n =====Uptime===== \n" 
	 uptime
         echo -e "\n =====Disk_Usage===== \n" 
         df -h 
	 echo -e "\n =====Disk_Statics===== \n"
      	 iostat -d 1 10
	 echo -e "\n =====Processes===== \n"
	 htop
	 echo -e "\n =====Network===== \n"
	 ping www.trainwithshubham.com 

}
health_check

