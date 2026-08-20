# TASK-1 

## The nginx, ubuntu, and alpine images from Docker Hub
- 932b04dd2838   alpine 
- 7286b4202e18   ubuntu 
- 11dac66d477a   nginx

## List all images on your machine — note the sizes
- alpine:latest   28bd5fe8b56d         13MB         3.93MB     
- nginx:latest    8f029c543423        241MB         66.2MB     
- ubuntu:latest   2260313b31c8        160MB         45.3MB

## Compare alpine vs ubuntu
- alpine is smaller than ubuntu

## Inspect of an docker image
- [
    {
        "Id": "sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b",
        "RepoTags": [
            "alpine:latest"
        ],
        "RepoDigests": [
            "alpine@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b"
        ],
        "Comment": "buildkit.dockerfile.v0",
        "Created": "2026-06-16T00:01:29.967161902Z",
        "Config": {
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "/bin/sh"
            ],
            "WorkingDir": "/"
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 3857242,
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:34884abbe92863fce933ed7c39c0e045631af0ed86d5cc0dfbdf9fdca426ce3c"
            ]
        },
        "Metadata": {
            "LastTagTime": "2026-08-20T06:34:02.129030617Z"
        },
        "Descriptor": {
            "mediaType": "application/vnd.oci.image.index.v1+json",
            "digest": "sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b",
            "size": 9218
        }
    }
]

## Remove an image
- docker rmi alpine:latest
Untagged: alpine:latest
Deleted: sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

# TASK-2

## Run docker image history nginx — what do you see?
- `docker image history nginx`- it shows image history when it was created, who creates, files in it, size, and comment

## Each line is a layer. Note how some layers show sizes and some show 0B
- some files and folders contains some memory/size because of non-empty files located in docker entryponts
- some files and folders didn't contains any memory/size because of empty files.

## What are layers and why does Docker use them?
#### These layers are componenets/commands used to make a docker file docker use these layers for build a container
- `CMD` 
- `TOPSIGNAL SIGQUIT`
- `EXPOSE`
- `ENTRYPOINT`
- `COPY`
- `RUN`
- `ENV`
- `LABEL`

# TASK-3 

#### Create a container (without starting it) 
- `docker create --name nginx-devops nginx`

#### Start the container
- `docker start c55d51a2c995`
####  Pause it and check status
- `docker pause c55d51a2c995`
#### Unpause it
- `docker unpause c55d51a2c995`
#### Stop it
- `docker stop c55d51a2c995`
#### Restart it
- `docker restart c55d51a2c995`
#### Kill it
- `docker kill c55d51a2c995`
#### Remove it
- `docker rm c55d51a2c995`

# TASK-4

### Run an Nginx container in detached mode
- `docker run -d nginx`
### View its logs
- `docker logs 19ba5fe3df65`
### View real-time logs (follow mode)
- `docker logs -f 19ba5fe3df65`
### Exec into the container and look around the filesystem
- `docker exec -it 19ba5fe3df65 sh`
### Run a single command inside the container without entering it
- `docker exec 19ba5fe3df65 ls`
### Inspect the container — find its IP address, port mappings, and mounts
- `docker inspect 19ba5fe3df65`
- "IPAddress": "172.17.0.2"
- "Mounts": []
- "Ports": {
                "80/tcp": null
            }

# TASK-5

## Stop all running containers in one command
- `docker stop $(docker ps -q)`
## Remove all stopped containers in one command
- `docker rm $(docker ps -a)`
## Remove unused images
- `docker system prune`
## Check how much disk space Docker is using
- `docker system df -v`