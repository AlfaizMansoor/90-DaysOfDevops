# TASK-1

## What is a container and why do we need them?
-  lightweight, standalone, and isolated package that bundles an application together with all its code, libraries, and dependencies.

#### Why do we need them?
- Consistency
- Isolated
- Portability
- Speed
- Efficiency

## Containers vs Virtual Machines — what's the real difference?
- containers are lightweight, single HOST OS needed for different working environments, isolated packages that runs an application with its code, libraries, and dependencies. 
- Virtual machines can runs different OS it needs differnet OS for different workspace, very heavy, takes more space. 

## What is the Docker architecture? (daemon, client, images, containers, registry)  
#### Docker Architecture
- Docker Client (The Waiter): This is you typing commands on your keyboard. You tell the waiter what you want (e.g., "Bring me an order of Ubuntu!"). The client passes your order to the kitchen.
- Docker Daemon (The Head Chef): This is a background program (dockerd) running on your computer. It listens to the waiter, manages the kitchen resources, and actually builds or runs your software.
- Docker Image (The Recipe Blueprint): This is a locked, read-only instruction manual. It contains everything needed to make your app run (code, tools, and settings). It never changes.
- Docker Container (The Cooked Meal): This is the live, active app running on your computer. It is created directly from the image recipe. If you need three identical apps running, you just make three containers from the same image.
- Docker Registry (The Cookbook Store): This is a giant warehouse (like Docker Hub) where thousands of pre-made recipes (images) are stored. You can download recipes from here or upload your own to share.

# TASK-2

## Run the hello-world container, Read the output carefully — it explains what just happened
- Hello from Docker!
This message shows that your installation appears to be working correctly.

# TASK-3 

#### Nginx container
- bf3ce77a5d0b  car-demo   "/docker-entrypoint.…"   11 hours ago    Up 5 minutes   0.0.0.0:80->80/tcp, [::]:80->80/tcp   car-demo
- Runs on http://localhost/car.html

#### Ubuntu container in interactive mode
- `docker run -itd ubuntu bash`

##### In interactive mode
- `docker run -it ubuntu bash`
- `root@af9e60a15c59:/#`

## List all running containers
- `docker ps` - lists all running containers.

## List all containers (including stopped ones)
- `docker ps -a` - lists all containers running or stopped both.

## Stop and remove a container
- `docker stop bf3ce77a5d0` - it stops the running container.
- `docker rm bf3ce77a5d0` - it removes the container.

# TASK-4

## Run a container in detached mode
- `docker run -d ubuntu:latest` creates a ubuntu image in detached mode.
- 0c5438f03c3   ubuntu:latest

## Give a container a custom name
- `docker run -d --name my_ubuntu ubuntu:latest` gives ubuntu image a custom name.

## Map a port from the container to your host
- `docker run -d -p 8080:80 nginx` it runs nginx on port 8080

## check logs of container
- `docker logs my_ubuntu` checks the logs of container my_ubuntu

## Run a command inside a running container
- `docker exec -it my_ubuntu bash` it opens a interactive mode of ubuntu so i can run commands inside a container.
- `systemctl status nginx`
