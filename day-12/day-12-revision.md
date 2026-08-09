# Breather & Revision (Days 01–11)

# Changes in plan day_01
- today the date is 4 march 2026 and i'm doing my assignment mumber 12 i'm very late to start it
- so i decided to do 2 assignments in a day to recover all of the burden and backlogs

# Rerunning of commands of the day 04 and 05
* Commands used
- systemctl status nginx
-> × nginx.service - A high performance web server and a reverse proxy server
     Loaded: <loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Wed 2026-03-04 21:44:33 IST; 38min ago
       Docs: man:nginx(8)
    Process: 1592 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited,>
    Process: 1626 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=1>
        CPU: 72ms
- ifconfig
-> ifconfig
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fd17:625c:f037:2:c904:5018:2fc:4bbf  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::a00:27ff:fe96:3a73  prefixlen 64  scopeid 0x20<link>
        inet6 fd17:625c:f037:2:a00:27ff:fe96:3a73  prefixlen 64  scopeid 0x0<global>
        ether 08:00:27:96:3a:73  txqueuelen 1000  (Ethernet)
        RX packets 6824  bytes 7274180 (7.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4929  bytes 1169137 (1.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
- ps
-> PID TTY          TIME CMD
   5912 pts/0    00:00:00 bash
   5995 pts/0    00:00:00 ps
- vmstat
-> procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
    r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
    3  0      0 3732632  75336 3926340    0    0  1088   124  790    7  4  8 88  0  0  0
- uname -a 
->Linux devuqaab-VirtualBox 6.17.0-14-generic #14~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Jan 15 15:52:10 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

# File skills
- echo "Definition of Devops" >> devops-file.txt
->  DevOps is collaboration between developer and operational teams, a devops engineers main task is automating developer and operational task which makes it easier. Cloud engineering is an IT discipline focused on designing, building, implementing, and managing cloud-based systems and infrastructure, such as AWS, Azure, or Google Cloud. Cloud engineers migrate, maintain, and optimize virtual servers, storage, and networks, enabling organizations to improve efficiency, scalability, and security.
- sudo chmod 755 devops-file.txt
-> file permissions before :-  -rw-rw-r-- 1 tokyo devuqaab 497 Mar  4 22:50 devops-file.tx, file permissions after :- -rwxr-xr-x 1 tokyo devuqaab 497 Mar  4 22:50 devops-file.txt
- chgrp planers devops-file.txt
-> before :- -rwxr-xr-x 1 tokyo     devuqaab    497 Mar  4 22:50 devops-file.txt
after:- -rwxr-xr-x 1 tokyo     planners    497 Mar  4 22:50 devops-file.txt

# Cheat sheet refresh
- dig domain:- to display DNS for domain
- ssh user@access:- to securely log into and manage a remote computer or server over an unsecured network
- cp:- to copy file or a directory
- mv:- to move a file or directory in another file or directory
- chgrp group [file]:- to change the group of file

# User/group sanity
- creates a user using sudo useradd -m user3
- change it's ownership using sudo chown user3 devops-file.txt
- checking ownership using ls -l devops-file.txt :- -rwxr-xr-x 1 user3     planners    497 Mar  4 22:50 devops-file.txt