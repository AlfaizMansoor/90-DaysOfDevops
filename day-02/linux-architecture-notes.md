# Kernel
-->Core/Heart of linux, kernel is a computer program which is understable by machine 

# User Space
-->while user space is a separate, unprivileged memory area where applications and services run. 

# init
-->The very first user-space process the kernel starts during the boot process, always assigned a Process ID (PID) of 1.

# How Processes are Created and Managed
--> A process is a running instance of a program. The Linux kernel handles their lifecycle from creation to termination. 

#    Process Creation (fork/exec): In Linux, processes are typically created using a two-step mechanism:

*        Fork(): The parent process creates a child process by duplicating itself. The child inherits memory, file descriptors, and environment from the parent but gets a unique Process ID (PID).

*        exec(): The child process uses the exec family of system calls to replace its memory space with a new program, loading the desired executable.

*        Copy-on-Write (COW): To save memory, fork() does not immediately copy all data. Instead, the child shares the parent's memory pages until one of them modifies a page, at which point the kernel copies only the affected pages.

# States of Process
* In Linux, a process is an instance of executing a program or command. While these processes exist, they’ll be in one of the five possible states:

#    Running or Runnable (R)
#    Uninterruptible Sleep (D)
#    Interruptable Sleep (S)
#    Stopped (T)
#    Zombie (Z)



# What system does and why it matters
-->Systemd is the default, modern system and service manager for the vast majority of Linux distributions (including Ubuntu, Debian, Fedora, Red Hat, and Arch). Running as the very first process (PID 1) upon boot, it is responsible for initializing the system, managing services (daemons), and controlling resources. 

It acts as the "conductor" for the system, bringing the Linux host to an operational state by starting services in parallel, making it faster and more efficient than older systems like SysVinit. 

# What Systemd Does?
Systemd is a large suite of tools, not just a single init process, and handles numerous tasks: 

*    System Initialization: Boots the system and manages the startup sequence.
*    Service Management: Uses systemctl to start, stop, enable, disable, and monitor services (daemons).
*    Parallel Execution: Starts services simultaneously rather than sequentially, significantly reducing boot times.
*    Dependency Tracking: Understands that some services require others to be running first (e.g., waiting for networking before starting a web server).
*    Centralized Logging (Journald): Gathers logs from the kernel, services, and applications into a binary, searchable format, accessible via journalctl.
*    Device Management (Udev): Handles device hotplugging and user space actions.
*    Resource Management (Cgroups): Uses Linux kernel control groups to manage and restrict resources (CPU, memory) for services, ensuring daemons cannot "escape" and continue running after being stopped.
*    Alternative Daemons: Replaces traditional tools like cron (with systemd-timers), inetd, and syslog. 



# Why Systemd Matters
Systemd is a critical component in modern Linux for several reasons: 

*    Standardization: It provides a unified, consistent way to manage services, networking, and devices across different Linux distributions.
*    Faster Boot Times: By starting services in parallel and on-demand (using socket activation), modern Linux boots much faster.
*    Improved Reliability: Services are better tracked, and if they crash, systemd can automatically restart them.
*    Advanced Troubleshooting: Centralized logging via journalctl allows administrators to easily filter, search, and view logs, simplifying the debugging process.
*    Modern Infrastructure Compatibility: It is designed to handle the demands of modern computing, including containerization and dynamic cloud environment

# cd :- to change directory
# ls :- to showing the list
# ps :- to check the process in running state
# sudo :- permission to perform tasks like: installation, Adding profile, Removing profile etc.
# pwd :- to check the path of the file, directory or folder