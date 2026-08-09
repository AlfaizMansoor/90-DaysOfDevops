# Networking Fundamentals & Hands-on Checks

# OSI layers (L1–L7) vs TCP/IP stack (Link, Internet, Transport, Application)

## OSI Model (7 Layers)

-    Physical (L1)         – Transmits raw bits over physical media (cables, signals).
-    Data Link (L2)        – Provides node-to-node data transfer, error detection (Ethernet, PPP).
-    Network (L3)          – Handles routing and addressing (IP).
-    Transport (L4)        – Ensures reliable delivery, flow control (TCP, UDP).
-    Session (L5)          – Manages sessions, dialog control.
-    Presentation (L6)     – Translates data formats, encryption, compression.
-    Application (L7)      – Interfaces directly with user applications (HTTP, FTP, SMTP).

##  TCP/IP Model (4 Layers)

-    Link (Network Access)      – Combines OSI’s Physical + Data Link (Ethernet, Wi-Fi).
-    Internet                   – Equivalent to OSI’s Network layer (IP, ICMP).
-    Transport                  – Same as OSI Transport (TCP, UDP).
-    Application                – Merges OSI’s Session, Presentation, and Application (HTTP, DNS, SMTP).

# Where IP, TCP/UDP, HTTP/HTTPS, DNS sit in the stack

- IP (Network (L3), Internet)                  - Provides addressing and routing of packets across networks
- TCP/UDP (Transport (L4), Transport)          - Ensures delivery (TCP: reliable, connection-oriented; UDP: fast, connectionless)
- HTTP/HTTPS (Application (L7), Application)   - Web communication protocols for transferring hypertext (HTTP) and secure encrypted traffic (HTTPS)
- DNS (Application (L7), Application)          - Resolves domain names into IP addresses.

# EXAMPLE: curl https://google.com 
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="https://www.google.com/">here</A>.
</BODY></HTML>

# Hands-on Checklist 
- hostname -I
10.0.2.15 fd17:625c:f037:2:7079:29b9:921f:542a fd17:625c:f037:2:a00:27ff:fe96:3a73 
- ping www.google.com
PING www.google.com (216.58.196.100) 56(84) bytes of data.
64 bytes from del11s05-in-f4.1e100.net (216.58.196.100): icmp_seq=1 ttl=255 time=40.4 ms
64 bytes from del11s05-in-f4.1e100.net (216.58.196.100): icmp_seq=2 ttl=255 time=48.9 ms
--- www.google.com ping statistics ---
20 packets transmitted, 20 received, 0% packet loss, time 19035ms
rtt min/avg/max/mdev = 34.592/42.798/57.228/5.583 ms
- traceroute www.google.com
traceroute to www.google.com (142.251.223.132), 30 hops max, 60 byte packets
 1  _gateway (10.0.2.2)  0.792 ms  0.651 ms  0.565 ms
- netstat -tulpn
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      -
- dig www.youtube.com
; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> www.youtube.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47178
;; flags: qr rd ra; QUERY: 1, ANSWER: 17, AUTHORITY: 0, ADDITIONAL: 1
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;www.youtube.com.		IN	A
;; ANSWER SECTION:
www.youtube.com.	173	IN	CNAME	youtube-ui.l.google.com.
youtube-ui.l.google.com. 153	IN	A	142.250.194.238
- curl -I https://google.com
HTTP/2 301 
location: https://www.google.com/
content-type: text/html; charset=UTF-8
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-x96K1IgIkTLZIzjTdAfyZA' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https: http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
- netstat -an | head
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
tcp        0      0 10.0.2.15:50468         34.107.243.93:443       ESTABLISHED
- ss -tulpn
Netid   State     Recv-Q    Send-Q       Local Address:Port        Peer Address:Port   Process   
udp     UNCONN    0         0                  0.0.0.0:34965            0.0.0.0:*                
udp     UNCONN    0         0                  0.0.0.0:5353             0.0.0.0:*
- nc -zv localhost 22
Connection to localhost (127.0.0.1) 22 port [tcp/ssh] succeeded!
