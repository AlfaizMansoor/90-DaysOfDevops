# Day 35 – Multi-Stage Builds & Docker Hub
## TASK-1
#### Steps :
1. I created a **"app.js"** app
2. Later i created a **"Dockerfile"** to run app.js app in a sngle stage
    - **Size of single stage image** - 
        - node-app:latest        |       8fa781bbd665    |   1.58GB     |     397MB 

## TASK-2
#### Steps :
1. I rewrite the previous **"Dockerfile"** using multi-stage build:
    - Stage 1: Build the app (install dependencies, compile)
    - Stage 2: Copy only the built artifact into a minimal base image (alpine, distroless, or scratch)
2. Build the image and check its size again
    - **Size of multi-stage image** -
        - node-app2:latest       |     55d4b75e82ca     |    186MB     |   45.6MB 

### let us Compare the two sizes
#### Why is the multi-stage image so much smaller?
* Multi-stage image is smaller than Single stage image in size because in single stage image i pulled the whole image in remote at once, but in multi-stage file i pulled whole image in 1st stage then i removes unused services and only usable services is there which decreases its size in stage 2nd, only necessary data is stored.

## TASK-3
#### Steps :
1. Create a free account on Docker Hub (if you don't have one)
    - I created a **Docker Hub** account
2. Log in from your terminal
    - I logged in my Docker hub account through terminal by using command `docker login`
3. Tag your image properly: yourusername/image-name:tag
    - I tagged my image by using command `docker tag node-app2 devuqaab/node-app2:1.0`
4. Push it to Docker Hub
    - I push my image by using command `docker push devuqaab/node-app2:1.0`
5. Pull it on a different machine (or after removing locally) to verify
    - I pull my image locally after removing it from remote by using command `docker pull devuqaab/node-app2:1.0`

## TASK-4
#### Steps :
1. Go to Docker Hub and check your pushed image
    - I go to docker hub check my pushed image
2. Add a description to the repository
    - Later i added description in my nimage on docker hub **"This is a multi-stage dockerfile for nodejs app stage 1: builder stage 2: runner"**
3. I Explore the tags tab — understand how versioning works
4. Pull a specific tag vs latest — what happens?
    - I pull a tagged image from docker hub by using `docker pull devuqaab/node-app2:1.0`
    - I pull a latest image from docker hub by using `docker pull devuqaab/node-app:latest`

## TASK-5
#### Steps :
1. I use a minimal base image (alpine vs ubuntu — compare sizes)
2. Don't run as root — add a non-root USER in your Dockerfile
    - I add a non root user throgh `RUN adduser -S appuser && chown -R appuser /app`
3. Combine RUN commands to reduce layers
4. Use specific tags for base images (not latest)
    - I tagged my image using specific tag by using `docker tag node-app3 devuqaab/node-app2:3.0`

#### Check the size before and after.
##### Before :
* alpine:latest        |        28bd5fe8b56d     |   9.07MB      |    3.93MB
* ubuntu:latest        |        2260313b31c8     |   115MB       |    45.3MB 

##### After :
* alpine:latest        |        28bd5fe8b56d     |    13MB       |    3.93MB
* ubuntu:latest        |        2260313b31c8     |   160MB       |    45.3MB    U