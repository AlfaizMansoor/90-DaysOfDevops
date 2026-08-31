# Day 37 – Docker Revision & Cheat Sheet
## Docker Cheat Sheet
* Container commands :
    - `docker run` : is used to run a container
    - `docker ps` : to list all the running containers
    - `docker stop` : is used to stop a running container
    - `docker rm` : to remove a container permanently
    - `docker exec` : to run specific commands in a running container 
    - `docker logs` : to show the logs of a conatainer
    
* Image commands :
    - `docker build` : used to build a custom image from **"Dockerfile"**
    - `docker pull` : it is used to pull/fetch an image from docker hub
    - `docker push` : it is used to push/upload an image to docker hub
    - `docker tag` : it used to tag image by it's specific version
    - `docker ls` : it shows list of iamges in local
    - `docker rmi` : it is used to remove an image permanently 

* Volume commands : 
    - `docker volume create` : used to create a new custom volume
    - `docker volume ls` : it's used to list all the volumes  
    - `docker inspect` : it used inspect a specific volume
    - `docker rm` : it used remove volume permanently
    
* Network commands 
    - `docker create network` : it is used create a custom network
    - `docker network ls` : to list all the networks 
    - `docker inspect` : used to inspect a specific network
    - `docker network connect` : used to connect a network to a container

* Compose commands : 
    - `docker-compose up` : it is used to building and staring containers  from **"docker-compose.yml"** 
    - `docker-compose down` : it is used stopping and removing containers permanently.
    - `docker ps` : it list all the running containers
    - `docker logs` : used to show logs of container
    - `docker-compose up --build` : it is used build image from **"docker-compose.yml"** which takes image from **"Dockerfile"** by using command `build: .`
* Cleanup commands :
    - `docker system prune` : it removes all unused or stopped containers
    - `docker system df` : it is used to show the disk space, docker using for image, networks, volumes, and build-caches

* Dockerfile instructions : 
    - `FROM` : pulling local or remote image
    - `RUN` : it runs commands and installing dependencies during building image
    - `COPY` : copies files or directories from one to another path
    - `WORKDIR` : defines working directory in the container
    - `EXPOSE` : defines port on which the service is running 
    - `CMD` : running the service during building image
    - `ENTRYPOINT` : sets the main process (harder to override, ensures predictable startup).