# Networking Concepts: DNS, IP, Subnets & Ports

# Google.com 
- when i searched for 'google.com' a page appears called google search engine, in which we can search for web pages, websites by their domain name.

# What are these record types?
- A record → Maps a domain name to an IPv4 address.
- AAAA record → Maps a domain name to an IPv6 address.
- CNAME record → Creates an alias from one domain name to another.
- MX record → Specifies the mail servers responsible for receiving email for a domain.
- NS record → Defines the authoritative name servers for a domain.

# dig google.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.2-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 33663
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.			IN	A
;; ANSWER SECTION:
google.com.		93	IN	A	142.250.76.78
;; Query time: 44 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Sat Mar 14 18:01:14 IST 2026
;; MSG SIZE  rcvd: 55

# IPv4 Address
- An IPv4 address is a 32‑bit numerical identifier written in dotted‑decimal format (e.g., 192.168.1.15), structured into four octets (0–255) that represent the network and host portions of the address.

# Difference between private and public IP

## Public IP → An address assigned to your device/server that is accessible over the internet. It’s globally unique and routable.
- Example: 54.224.97.14 (like the EC2 instance you were testing with).

## Private IP → An address used within local/private networks (LANs). It’s not routable on the internet and is reserved for internal communication.
- Example: 192.168.1.10 (a typical home Wi‑Fi device address).

# Private IP Ranges
## The private IP address ranges are defined by [RFC 1918] and reserved for use inside local/private networks (not routable on the public internet). They are:

-   10.0.0.0 – 10.255.255.255  
    → Entire 10.x.x.x block (Class A private range).

-   172.16.0.0 – 172.31.255.255  
    → Subset of the 172.x.x.x block (Class B private range).

-   192.168.0.0 – 192.168.255.255  
    → Entire 192.168.x.x block (Class C private range).

# 192.168.1.0/24
- 255.255.255.0  - Netmask
- 192.168.1.0    - CIDR Base IP
- 192.168.1.255  - Broadcast IP
- 256            - Count
- 192.168.1.1    - First Usable IP
- 192.168.1.254  - Last Usable IP

# Usable hosts for private IP 192.168.1.0
- 192.168.1.0/24 - 256
- 192.168.1.0/28 - 16
- 192.168.1.0/16 - 65,536

# Why do we subnet?
- we divide network in subnet which Enhanced its security, Improves Performance, simplifies the management of IP's, Scalability.

# CIDR      	Subnet Mask 	  Total IPs 	        Usable Hosts
/24            255.255.255.0         256 	      192.168.1.1 - 192.168.1.254
/16 	      255.255.255.240       65,536         192.168.1.1 - 192.168.1.14
/28 	        255.255.0.0	          16 	      192.168.0.1 - 192.168.255.254

# What is a port? Why do we need them?
- A port is a logical endpoint in networking that helps distinguish different types of traffic on the same IP address. 

##  Why we need ports
-   Service differentiation → Multiple applications (web server, mail server, FTP, etc.) can run on the same IP, each   identified by a unique port number.
-   Efficient communication → Ports allow the operating system to direct incoming data to the correct application.
-   Standardization → Well-known ports (like 80 for HTTP, 443 for HTTPS, 25 for SMTP) make it easy for clients to know where to connect.
-   Security & control → Firewalls and access rules often operate at the port level, allowing fine-grained control over traffic.

# Common Ports
  Port	  Service	
- 22        SSH 
- 80	    HTTP	
- 443	    HTTPS	
- 53	    DNS	
- 3306	    MySQL	
- 6379	    Redis	
- 27017	    MongoDB

# ss -tulpn
ss -tulpn
Netid    State     Recv-Q    Send-Q       Local Address:Port        Peer Address:Port    Process    
udp      UNCONN    0         0                  0.0.0.0:5353             0.0.0.0:*                  
udp      UNCONN    0         0               127.0.0.54:53               0.0.0.0:*                  
udp      UNCONN    0         0            127.0.0.53%lo:53               0.0.0.0:*                  
udp      UNCONN    0         0                  0.0.0.0:52550            0.0.0.0:*                  
udp      UNCONN    0         0                     [::]:5353                [::]:*                  
udp      UNCONN    0         0                     [::]:49397               [::]:*                  
tcp      LISTEN    0         4096            127.0.0.54:53               0.0.0.0:*                  
tcp      LISTEN    0         4096         127.0.0.53%lo:53               0.0.0.0:*                  
tcp      LISTEN    0         4096               0.0.0.0:22               0.0.0.0:*                  
tcp      LISTEN    0         4096             127.0.0.1:631              0.0.0.0:*                  
tcp      LISTEN    0         4096                 [::1]:631                 [::]:*                  
tcp      LISTEN    0         511                      *:80                     *:*                  
tcp      LISTEN    0         4096                  [::]:22                  [::]:* 

