# LINUX TROUBLESHOOTING DRILL: CPU, MEMORY, AND LOGS.

# uname -a

* Linux devuqaab-VirtualBox 6.14.0-37-generic #37~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Nov 20 10:25:38 UTC 2 x86_64 x86_64 x86_64 GNU/Linux

- Troubleshooting:- not found
- What i saw:- Operating system :- (Linux devuqaab-VirtualBox) | IPv4 IP address :- (#37.24.04.1)| date :- (Nov 20) | time :- (10:25:38)|port :- (UTC 2 x86_64 x86_64 x86_64 GNU/Linux)
- What if any error occurs:- recheck the command, read the manual by using <man uname>, re-enter the command check the troubleshoot.

# lsb_release -a

*   No LSB modules are available.
    Distributor ID:	Ubuntu
    Description:	Ubuntu 24.04.3 LTS
    Release:	24.04
    Codename:	noble

- Troubleshooting:- No LSB modules are available.
- What i saw:- user ID :- (Ubuntu) | Ubuntu version :- (Ubuntu 24.04.3 LTS) | codename :- (noble)
- What if any error occurs:- install the lsb-release by using <sudo apt update && upgrade -y, sudo apt install lsb-relese>

# mkdir /tmp/runbook-demo

* make directory with path /tmp/runbook-demo

# cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo

* total 4
-rw-r--r-- 1 devuqaab devuqaab 234 Feb 10 00:50 hosts-copy

# CPU/Memory

* top - 00:56:25 up  2:10,  1 user,  load average: 0.45, 0.30, 0.21
Tasks: 236 total,   1 running, 235 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.7 us,  1.0 sy,  0.0 ni, 97.9 id,  0.0 wa,  0.0 hi,  0.3 si,  0.0 st 
MiB Mem :   9708.5 total,   5439.3 free,   2321.1 used,   2209.7 buff/cache     
MiB Swap:   4096.0 total,   4096.0 free,      0.0 used.   7387.5 avail Mem

- Troubleshooting:- not found
- What i saw:- 236 total,   1 running, 235 sleeping,   0 stopped,   0 zombie, 
  MiB Mem :   9708.5 total,   5439.3 free,   2321.1 used,   2209.7 buff/cache     
  MiB Swap:   4096.0 total,   4096.0 free,      0.0 used.   7387.5 avail Mem

# free -h

*                total       used        free      shared     buff/cache   available
  Mem:           9.5Gi       2.4Gi       5.1Gi       134Mi       2.3Gi       7.1Gi
  Swap:          4.0Gi          0B       4.0Gi

- Troubleshooting:- not found
- What i saw:- CPU & SWAP Memory 
- What if any error occurs:- check the storage, removes unused files and clear cache 

# df -h

* Filesystem      Size  Used Avail Use% Mounted on
  tmpfs           971M  2.1M  969M   1% /run
  /dev/sda2        98G   37G   56G  40% /
  tmpfs           4.8G   36M  4.8G   1% /dev/shm
  tmpfs           5.0M  8.0K  5.0M   1% /run/lock
  tmpfs           971M  148K  971M   1% /run/user/1000
  /dev/sr0         51M   51M     0 100% /media/devuqaab/VBox_GAs_7.2.4

- Troubleshooting:- not found
- What i saw:- Disk Memory
- What if any error occurs:- check the disk storage, remove unused files or directories

# vmstat

* procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
  2  0      0 5271856  83264 2315672    0    0   258    57  431    3  1  3 96  0  0  0

- Troubleshooting:- not found
- What i saw:- Virtual Memory
- What if any error occurs:- Check Installation, Run as Root, 

# ss -tulpn

* Netid           State            Recv-Q           Send-Q                       Local Address:Port                        Peer Address:Port           Process           
udp             UNCONN           0                0                                  0.0.0.0:46051                            0.0.0.0:*                                
udp             UNCONN           0                0                                  0.0.0.0:5353                             0.0.0.0:*                                
udp             UNCONN           0                0                               127.0.0.54:53                               0.0.0.0:*                                
udp             UNCONN           0                0                            127.0.0.53%lo:53                               0.0.0.0:*                                
udp             UNCONN           0                0                                     [::]:37517                               [::]:*                                
udp             UNCONN           0                0                                     [::]:5353                                [::]:*                                
tcp             LISTEN           0                4096                         127.0.0.53%lo:53                               0.0.0.0:*                                
tcp             LISTEN           0                4096                             127.0.0.1:631                              0.0.0.0:*                                
tcp             LISTEN           0                4096                            127.0.0.54:53                               0.0.0.0:*                                
tcp             LISTEN           0                4096                                 [::1]:631                                 [::]:*                                
tcp             LISTEN           0                511                                      *:80                                     *:* 
