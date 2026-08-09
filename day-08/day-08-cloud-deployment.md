![alt text][def]

[def]: <Screenshot from 2026-03-01 22-11-52.png>


# Cloud Server Setup: Docker, Nginx & Web Deployment

# ssh connect
- Commands used

* cd Downloads:- to locate the file 'devuqaab.pem' in Downloads
* chmod 400 "devuqaab.pem" :- to change the file permissions
* ssh -i "devuqaab.pem" ubuntu@ec2-52-201-214-223.compute-1.amazonaws.com :- to connect EC2 instance

# Installation of nginx

* sudo apt update :- to update the linux
* sudo apt install nginx :- installing nginx in linux

# running nginx server

* http://52.201.214.223 :- check the nginx web server is running or not properly

- i face issue in running web server because of security group :- i added a inbound rule in securitu group with http with cidr 0.0.0.0