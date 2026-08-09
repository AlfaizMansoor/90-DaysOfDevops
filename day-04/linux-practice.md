#  PRACTICE LINUX FUNDAMENTALS WITH REAL COMMANDS.

# ps:-

*  PID TTY       TIME CMD
   5117 pts/0    00:00:00 bash
   5904 pts/0    00:00:00 ps

# top:-

* top - 20:25:03 up 48 min,  1 user,  load average: 0.92, 1.00, 0.66
  Tasks: 244 total,   1 running, 243 sleeping,   0 stopped,   0 zombie
  %Cpu(s):  1.1 us,  3.3 sy,  0.0 ni, 95.3 id,  0.0 wa,  0.0 hi,  0.4 si,  0.0 st 
  MiB Mem :   9708.5 total,   5031.4 free,   2583.3 used,   2246.0 buff/cache     
  MiB Swap:   4096.0 total,   4096.0 free,      0.0 used.   7125.2 avail Mem 

# vmstat:-

* procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
  3  0      0 5118752  69428 2245996    0    0   550   110  586    5  3  6 91  0  0  0

# systemctl status:- 
<inpection os systemd service>


* devuqaab-VirtualBox
    State: running
    Units: 642 loaded (incl. loaded aliases)
     Jobs: 0 queued
   Failed: 0 units
    Since: Sun 2026-02-08 19:37:03 IST; 1h 12min ago
  systemd: 255.4-1ubuntu8.10
   CGroup: /
           ├─init.scope
           │ └─1 /sbin/init splash
           ├─system.slice
           │ ├─ModemManager.service
           │ │ └─1167 /usr/sbin/ModemManager
           │ ├─NetworkManager.service
           │ │ └─1104 /usr/sbin/NetworkManager --no-daemon
           │ ├─accounts-daemon.service
           │ │ └─1022 /usr/libexec/accounts-daemon
           │ ├─apache2.service
           │ │ ├─1677 /usr/sbin/apache2 -k start
           │ │ ├─1681 /usr/sbin/apache2 -k start
           │ │ └─1682 /usr/sbin/apache2 -k start
           │ ├─atop.service
           │ │ └─1198 /usr/bin/atop -w /var/log/atop/atop_20260208 600
           │ ├─atopacct.service
           │ │ └─1100 /usr/sbin/atopacctd
           │ ├─avahi-daemon.service
           │ │ ├─ 964 "avahi-daemon: running [devuqaab-VirtualBox.local]"
           │ │ └─1081 "avahi-daemon: chroot helper"
           │ ├─colord.service
           │ │ └─2122 /usr/libexec/colord
           │ ├─cron.service
           │ │ └─1024 /usr/sbin/cron -f -P
           │ ├─cups-browsed.service
           │ │ └─1724 /usr/sbin/cups-browsed
           │ ├─cups.service
           │ │ ├─1599 /usr/sbin/cupsd -l
           │ │ ├─1657 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1662 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1663 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1664 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1667 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1668 /usr/lib/cups/notifier/dbus dbus://
           │ │ ├─1669 /usr/lib/cups/notifier/dbus dbus://


# systemd-analyze:- 

* Startup finished in 7.306s (kernel) + 20.989s (userspace) = 28.296s 
  graphical.target reached after 20.947s in userspace.

# systemd-path:-

* temporary: /tmp
    temporary-large: /var/tmp
    system-binaries: /usr/bin
    system-include: /usr/include
    system-library-private: /usr/lib
    system-library-arch: /usr/lib/x86_64-linux-gnu
    system-shared: /usr/share
    system-configuration-factory: /usr/share/factory/etc
    system-state-factory: /usr/share/factory/var
    system-configuration: /etc
    system-runtime: /run
    system-runtime-logs: /run/log
    system-state-private: /var/lib
    system-state-logs: /var/log
    system-state-cache: /var/cache
    system-state-spool: /var/spool
    user-binaries: /home/devuqaab/.local/bin
    user-binaries: /home/devuqaab/.local/bin
    user-library-private: /home/devuqaab/.local/lib
    user-library-arch: /home/devuqaab/.local/lib/x86_64-linux-gnu
    user-shared: /home/devuqaab/.local/share
    user-configuration: /home/devuqaab/.config
    user-runtime: /run/user/1000
    user-state-cache: /home/devuqaab/.cache
    user: /home/devuqaab
    user-documents: /home/devuqaab/Documents
    user-music: /home/devuqaab/Music
    user-pictures: /home/devuqaab/Pictures
    user-videos: /home/devuqaab/Videos
    user-download: /home/devuqaab/Downloads
    user-public: /home/devuqaab/Public
    user-templates: /home/devuqaab/Templates
    user-desktop: /home/devuqaab/Desktop
    search-binaries: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin
    search-binaries-default: /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
    search-library-private: /home/devuqaab/.local/lib:/usr/local/lib:/usr/lib
    search-library-arch: /home/devuqaab/.local/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu
    search-shared: /home/devuqaab/.local/share:/usr/share/ubuntu:/usr/share/gnome:/usr/local/share/:/usr/share/:/var/lib/snapd/desktop
    search-configuration-factory: /usr/local/share/factory/etc:/usr/share/factory/etc
    search-state-factory: /usr/local/share/factory/var:/usr/share/factory/var
    search-configuration: /home/devuqaab/.config:/etc/xdg/xdg-ubuntu:/etc/xdg
    systemd-util: /usr/lib/systemd
    systemd-system-unit: /usr/lib/systemd/system
    systemd-system-preset: /usr/lib/systemd/system-preset
    systemd-system-conf: /etc/systemd/system

# tail -f /var/log/syslog:-

* 2026-02-08T22:21:42.215468+05:30 devuqaab-VirtualBox systemd[1]: bluetooth.service - 
bluetooth service was skipped because of an unmet condition check (ConditionPathIsDirectory=/sys/class/bluetooth).
  2026-02-08T22:21:42.240187+05:30 devuqaab-VirtualBox systemd[9379]: Started app-org.chromium.Chromium-11679.scope.
  2026-02-08T22:21:42.322607+05:30 devuqaab-VirtualBox code.desktop[11720]: VMware: No 3D enabled (0, Success).
  2026-02-08T22:21:42.380581+05:30 devuqaab-VirtualBox code.desktop[11720]: VMware: No 3D enabled (0, Success).
  2026-02-08T22:21:42.401195+05:30 devuqaab-VirtualBox code.desktop[11720]: [11720:0208/222142.400721:ERROR:media/gpu/vaapi/vaapi_wrapper.cc:1631] vaInitialize failed: unknown libva error
  2026-02-08T22:21:42.625631+05:30 devuqaab-VirtualBox code.desktop[11679]: #033[90m[main 2026-02-08T16:51:42.619Z]#033[0m update#setState idle
  2026-02-08T22:21:42.739719+05:30 devuqaab-VirtualBox code.desktop[11762]: [11762:0208/222142.738949:ERROR:gpu/ipc/client/command_buffer_proxy_impl.cc:128] ContextResult::kTransientFailure: Failed to send GpuControl.CreateCommandBuffer.
  2026-02-08T22:21:42.908647+05:30 devuqaab-VirtualBox gnome-shell[9639]: Invalid sequence for VSYNC frame info
  2026-02-08T22:21:45.812937+05:30 devuqaab-VirtualBox kernel: audit: type=1400 audit(1770569505.811:449): apparmor="DENIED" operation="open" class="file" profile="snap.firefox.firefox" name="/proc/pressure/memory" pid=10402 comm="MemoryPoller" requested_mask="r" denied_mask="r" fsuid=1000 ouid=0
  2026-02-08T22:21:46.856211+05:30 devuqaab-VirtualBox gnome-keyring-d[9408]: asked to register item /org/freedesktop/secrets/collection/login/1, but it's already registered
  2026-02-08T22:22:12.627939+05:30 devuqaab-VirtualBox code.desktop[11679]: #033[90m[main 2026-02-08T16:52:12.627Z]#033[0m update#setState checking for updates
  2026-02-08T22:22:12.816576+05:30 devuqaab-VirtualBox code.desktop[11679]: #033[90m[main 2026-02-08T16:52:12.815Z]#033[0m update#setState available for download

# logname:-

* devuqaab
# ssh:- usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface] [-b bind_address]
           [-c cipher_spec] [-D [bind_address:]port] [-E log_file]
           [-e escape_char] [-F configfile] [-I pkcs11] [-i identity_file]
           [-J destination] [-L address] [-l login_name] [-m mac_spec]
           [-O ctl_cmd] [-o option] [-P tag] [-p port] [-R address]
           [-S ctl_path] [-W host:port] [-w local_tun[:remote_tun]]
           destination [command [argument ...]]
       ssh [-Q query_option]

# Running processes:- 1 running
# Troubleshooting:- 

* nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Sun 2026-02-08 23:19:57 IST; 2min 31s ago
       Docs: man:nginx(8)
    Process: 13648 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 13649 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=1/FAILURE)
        CPU: 34ms

Feb 08 23:19:56 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
Feb 08 23:19:56 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
Feb 08 23:19:56 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
Feb 08 23:19:56 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
Feb 08 23:19:57 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)
Feb 08 23:19:57 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] bind() to [::]:80 failed (98: Address already in use)
Feb 08 23:19:57 devuqaab-VirtualBox nginx[13649]: nginx: [emerg] still could not bind()
Feb 08 23:19:57 devuqaab-VirtualBox systemd[1]: nginx.service: Control process exited, code=exited, status=1/FAILURE
Feb 08 23:19:57 devuqaab-VirtualBox systemd[1]: nginx.service: Failed with result 'exit-code'.
Feb 08 23:19:57 devuqaab-VirtualBox systemd[1]: Failed to start nginx.service - A high performance web server and a reverse proxy server.