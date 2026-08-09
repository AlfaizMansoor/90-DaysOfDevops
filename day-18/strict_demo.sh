#!/bin/bash
set -euo pipefail

echo "$name"
#set -u stops the process of undefined variable

ls /ggg.txt
#set -e stops script because command failure

cat ggg.txt | grep linux
#set -o pipefail: stops the script because of command failure in pipe 
