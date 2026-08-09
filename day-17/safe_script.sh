#!/bin/bash
set -e

mkdir /tmp/devops-test || echo "file already exists"
cd /tmp/devops-test
touch file.txt
echo "done!!!"
