# Day 37 – Docker Revision & Cheat Sheet
## Self-Assessment Checklist

Mark yourself honestly — can do, shaky, or haven't done:

- [x] Run a container from Docker Hub (interactive + detached)
- [x] List, stop, remove containers and images
- [x] Explain image layers and how caching works
- [x] Write a Dockerfile from scratch with FROM, RUN, COPY, WORKDIR, CMD
- [x] Explain CMD vs ENTRYPOINT
- [x] Build and tag a custom image
- [x] Create and use named volumes
- [x] Use bind mounts
- [x] Create custom networks and connect containers
- [x] Write a docker-compose.yml for a multi-container app
- [x] Use environment variables and .env files in Compose
- [x] Write a multi-stage Dockerfile
- [x] Push an image to Docker Hub
- [x] Use healthchecks and depends_on

## Quick-Fire Questions
### What is the difference between an image and a container?
* A Docker image is a read‑only template. Think of it as the blueprint: it contains your application code, libraries, dependencies, and instructions (from the Dockerfile). Images are immutable — once built, they don’t change. You can share them via registries like Docker Hub.

* A Docker container is a running instance of that image. When you run docker run <image>, Docker creates a container by adding a writable layer on top of the image. 

### What happens to data inside a container when you remove it?
* Data also removes with the container except except if we save data in custom volume created by us.

### How do two containers on the same custom network communicate?
* Two containers communicate through the a custom bridge network connected to both containers

### What does docker compose down -v do differently from docker compose down?
* `docker-compose down -v` it removes volumes and data also with the contaners
* `docker-compose down` it removes containers, build cache, and networks are gone but volumes and logs remains there.

### Why are multi-stage builds useful?
* Multi-stage builds reduces the image size and saves disk space and allows only needed space to a container

### What is the difference between COPY and ADD?
* `COPY` it copies the files and folders from local in the image
* `ADD` it extract compressed archives (e.g. .tar) automatically and can download files from URLs

### What does -p 8080:80 mean?
* It means that container port is `80` but host is running on port `8080`

### How do you check how much disk space Docker is using?
* `docker system df` is used to check that how much disk space is containers using
