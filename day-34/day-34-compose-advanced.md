# Day 34 – Docker Compose: Real-World Multi-Container Apps

## TASK-1 
#### Steps :
1. I created a **"docker-compose.yml"** file for a 3-service app.
2. I create a container for web-app **"python:3.10-slim"**
3. I create a container for database **"mysql"**
4. I create a container for cache **"redis"**
5. I run this docker-compose.yml by using command `docker-compose up`

## TASK-2
#### Steps :
1. I added **"depends_on"** to my **"docker-compose.yml"** file so the app starts after the database.
2. After that i add a **"healthchecks:"** on the database service.
3. I use **"depends_on"** with **"condition:"** service_healthy so the app waits for the database to be truly ready.

#### Test: Bring everything down and up — does the app wait for the DB?
* **"YES!"** app waits for database.

## TASK-3
#### Steps :
1. I add **"restart: always"** in my database service of previous docker-compose.yml.
2. After that i manually killed the database container by using **"docker kill stack-data"** — does it come back?
    - **"YES!"** it come back after killing.
3. Try **"restart: on-failure"** — how is it different?
    - **"always"** it starts restart always no matter that database crashed or not.

#### When would you use each restart policy?
* I will use restart policy whenever there is chance of failure.

## TASK-4
1. Instead of using a pre-built image for my app, i use **"build: ."** in your compose file to build from a **"Dockerfile"**  that build just before updating the docker-compose.yml 
2. I make a code change in **"app.py"** file, where my app material is located.
3. Rebuild and restart with one command `docker-compose up --build`

## TASK-5 
1. Define explicit networks named **"networks: stacknet"**in my compose file instead of relying on the default.
2. Define named volumes **"volumes: stackapp-volume"** for database data
3. Add labels to your services for better organization
    * **labels:**
    - com.example.service: "web"
    - com.example.owner: "Alfaiz Mansoor"
    - com.example.description: "Flask frontend app"

## TASK-6
1. I tried scaling in my web app to 3 replicas using `docker-compose up --scale web=3`
2. What happens? What breaks?
    - At first it stops because i defined **"container_name"**, then it stops because i defined **"ports"**

#### Why doesn't simple scaling work with port mapping?
* The host port (6379) can only be used by one container at a time.
* If you scale (--scale cache=3), Docker tries to start 3 containers, but each one wants to grab host port 6379. The first succeeds, the others fail → port conflict error.
