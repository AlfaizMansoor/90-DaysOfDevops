# Day 10 Challenge

## Files Created
- notes.txt
- devops.txt
- script.sh

## Permission Changes

# Before
- -rw-rw-r-- 1 devuqaab devuqaab 0 Mar  3 23:22 devops.txt
- -rw-rw-r-- 1 devuqaab devuqaab 0 Mar  3 23:22 notes.txt
- -rw-rw-r-- 1 devuqaab devuqaab 0 Mar  3 23:23 script.sh

# After
- -r-xr-xr-x 1 devuqaab devuqaab    0 Mar  3 23:22 devops.txt
- -rw-r----- 1 devuqaab devuqaab   12 Mar  3 23:33 notes.txt
- drwxr-xr-x 2 devuqaab devuqaab 4096 Mar  3 23:51 project
- -rwxr-xr-x 1 devuqaab devuqaab   20 Mar  3 23:34 script.sh

## Commands Used
- cat
- touch
- chmod
- ls -l
- cd
- vim
- head
- tail
- ./
- echo

## What I Learned
- how to make files and directories
- how to change file permissions
- i learned why file permission is important