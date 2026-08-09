# LINUX FILE SYSTEM HIERARCHY & SCENARIO-BASED PRACTICE

# /  
* root directory is top level directory in linux file system
- I would use this when i want to explores all directory from scratch
* total 4194404
lrwxrwxrwx   1 root root          7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x   2 root root       4096 Feb 26  2024 bin.usr-is-merg


# /home
* directory in Linux serves as the storage location for user-specific data, holding individual subdirectories for each user
- drwxr-x--- 25 devuqaab devuqaab 4096 Feb 11 18:53 <devuqaab>
- drwxr-x---  2 uqaab    uqaab    4096 Feb 15 14:59 <uqaab>
- I would use this when i want to check users


# /root
* root directory is the home directory for the root user (system administrator), acting as their personal, secure workspace rather than using /home/root
- total 4
drwx------ 8 root root 4096 Feb  4 03:24 <snap>


# /etc
* etc directory in Linux is the central repository for host-specific system-wide configuration files and startup scripts
- drwxr-xr-x  3 root                 root                  4096 Aug  5  2025 alsa
- drwxr-xr-x  2 root                 root                  4096 Feb 11 15:34 alternatives



# /var/logs
* Linux stores system-wide log files, containing records of system activity, service messages, and application events
- -rw-r--r--  1 root              root                5632 Feb 11 15:34 alternatives.log
- -rw-r--r--  1 root              root               31387 Jan  6 13:05 alternatives.log.1


# /tmp 
* in Linux stores temporary files and directories created by system processes and running applications.
- total 64
drwxrwxr-x 3 devuqaab devuqaab 4096 Feb 26 15:10 node-compile-cache
drwx------ 5 root     root     4096 Feb 26 15:09 snap-private-tmp


# The largest log file in /var/log
* command used:- du -sh /var/log/* 2>/dev/null | sort -h | tail -5
- 683M	/var/log/journal

# Look at a config file in /etc
* command used:- cat /etc/hostname
- devuqaab-VirtualBox

# Check your home directory
* command used:- ls -la
- drwxr-xr-x  23 root root       4096 Jan  5 17:36 .
- drwxr-xr-x  23 root root       4096 Jan  5 17:36 ..

# Question: How do i check if the 'nginx' service is running?


* systemctl status myapp.service
- It show you the current state of your service.

* journalctl -u myapp.service -xe
- Displays error messages and stack traces from the service startup attempt.

* journalctl -u myapp.service -f
- Streams logs in real time as you retry starting the service.

- Feb 27 00:54:00 devuqaab-VirtualBox systemd[1]: myapp.service: Scheduled restart job, restart counter is at 970.
Feb 27 00:54:00 devuqaab-VirtualBox systemd[1]: Started myapp.service - My Application Service.
Feb 27 00:54:00 devuqaab-VirtualBox (myapp)[9710]: myapp.service: Failed to determine user credentials: No such process
Feb 27 00:54:00 devuqaab-VirtualBox systemd[1]: myapp.service: Main process exited, code=exited, status=217/USER

* systemctl restart myapp.service
- Restarting the service with

# High CPU Usage

* command used:- top
- Check overall CPU usage and top processes

* command used:- ps aux --sort=-%cpu | head -10
- Displays the top CPU-consuming processes with their PID and command
- PID :- 6611

# Finding Service Logs

* command used:- systemctl status ssh
- to check status of the service
-  ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/usr/lib/systemd/system/ssh.service; disabled; preset: enabled)
     Active: inactive (dead)
TriggeredBy: ● ssh.socket
       Docs: man:sshd(8)
             man:sshd_config(5)

* command used:- journalctl -u ssh -n 50
- Streams logs in real time as you retry starting the service

# File Permissions

* command used:- ls -l /home/devuqaab/devops_devuqaab/scripts/backup.sh
- -rw-r-xr-x

* command used:- chmod 755 /home/devuqaab/devops_devuqaab/scripts/backup.sh
- file permissions is changed

* command used:- ls -l /home/devuqaab/devops_devuqaab/scripts/backup.sh
- -rwxr-xr-x

* command used:- ./backup.sh
- now the file is executable