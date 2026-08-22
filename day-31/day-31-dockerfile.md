# DAY-31

## TASK-1
#### Steps :
1. I created a folder named `my-first-image`
2. Then i created a file named `Dockerfile`
    - Uses ubuntu as the base image
    - Installs curl
    - Sets a default command to print "Hello from my custom image!"
3. Then i build and run a image by using `docker build -t my-ubuntu:v1 .` && `docker run -it my-ubuntu:v1 my-ubuntu:v1`
4. I verified the message that it prints is **"Hello from my custom image"**

## TASK-2 
#### Steps :
1. I created a folder named `second-dockerfile`
2. Then i created a file named `Dockerfile` and i make sure that it contains all these following instructions:
    - `FROM`    — base image
    - `RUN`     — execute commands during build
    - `COPY`    — copy files from host to image
    - `WORKDIR` — set working directory
    - `EXPOSE`  — document the port
    - `CMD`     — default command
3. I analyses and understands what each line does.
    - `FROM`    - this command pulls image from remote(Docker Hub) or locally.
    - `WORKDIR` - this command creates a eorking directory.
    - `RUN`     - this command run a image based commands during building a container.
    - `COPY`    - this command copies a file from source destination to final destination.
    - `CMD`     - this command runs command immidietly after  building a container.
    - `EXPOSE` - this commands defines that on which port container is running on. 


## TASK-3
#### Steps :
1. I created a folder named `third-dockerfile`
2. Then i created files named `Dockerfile` & `Docker.version1` in which i use `CMD` for running commands after building container.
    - i give `echo ------` command in Dockerfile for `CMD`
    - then i give `ls` command in Dockerfile.version1 for `CMD`
3. Then i created files named `Dockerfile` & `Docker.version1` in which i use `CMD` for running commands after building container.
    - I give `echo "Hello this is my dockerfile"` command in Dockerfile for `ENTRYPOINT`
    - Then i give `echo ____ ` this command is used for write with the container building command in Dockerfile.version1 for `ENTRYPOINT`
4. Check every Docker file by running commands

## TASK-4
#### Steps :
1. I created a folder named `second-dockerfile`
2. I created a `index.html` file and written basic webpage material.
3. Then i created a file named `Dockerfile` 
    - Uses nginx as base image
    - Copy `index.html` file in index.html in nginx web directory
    - Exposes Port 80
4. Build and tag `my-website:v1` on port 80

## TASK-5
#### Steps :
1. I created a folder named `third-dockerfile`
2. Then i created files named `.dockerignore` in the folder
    - Add entries of `node_modules`, `*.md`, `.git`, `.env` in `.dockerignore`
    - verifies that ignore files is not included
3. Build ubuntu inage to verify.

## TASK-6
#### Steps :
1. I created a folder named `fifth-dockerfile`
2. Then i created a file named `Dockerfile` and `Dockerfile.reorder`
3. Run both containers and they both uses diffrent cache 

- Layer order matters for Docker build speed because once a layer’s cache is invalidated, every subsequent layer must be rebuilt. By placing stable instructions first and frequently changing ones last, you maximize cache reuse and avoid unnecessary rebuilds.
