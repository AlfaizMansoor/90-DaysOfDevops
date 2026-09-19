# Day 45 – Docker Build & Push in GitHub Actions
## TASK-1
1. I create a simple Dockerfile
2. Add the Dockerfile to your github-actions-practice 
3. I make sure DOCKER_USERNAME and DOCKER_TOKEN secrets are set from Day 44

## TASK-2

1. I create .github/workflows/docker-publish.yml that:
    - Triggers on push to main
    - Checks out the code
    - Builds the Docker image and tags it
    ```yml
    steps:
            - name: image build
              uses: actions/checkout@v4

            - name: docker build
              run: |
                docker build -t my-app .
                docker run -d -p 5000:5000 --name my-app my-app
                docker tag my-app my-app:latest

            - name: check running images
              run: docker ps
    ```
#### Verify: Check the build step logs — does the image build successfully?
* **YES!** image successfully build

## TASK-3

1. Add steps to:
    - Log in to Docker Hub using your secrets
    - Tag the image as username/repo:latest and also username repo:sha-<short-commit-hash>
    - Push both tags
    ```yml
    steps:
        - name: Checkout code
          uses: actions/checkout@v4

        - name: docker login
          uses: docker/login-action@v3
          with:
            username: ${{secrets.DOCKER_USERNAME}}
            password: ${{secrets.DOCKER_TOKEN}}

        - name: docker build and push
          uses: docker/build-push-action@v5
          with:
            context: .
            push: true
            tags: |
              ${{secrets.DOCKER_USERNAME}}/github-actions-practices:latest
              ${{secrets.DOCKER_USERNAME}}/github-actions-practices:${{ github.sha }}
    ```

#### Verify: Go to Docker Hub — is your image there with both tags?
* **YES!** i went to Docker Hub and i found that my both images with tags is present there

## TASK-4
1. I add a condition so the push step only runs on the main branch — not on feature branches or PRs.

2. I push to a feature branch and verify the image is built but NOT pushed.

## TASK-5
1. Get the badge URL for my docker-publish workflow from the Actions tab
2. Add it to your README.md
    - URL to README.md :- <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/README.md>
3. I push the badge and shows green mark

## TASK-6
1. On my local machine, i pull the image you just pushed, Run it and Confirm it works
![alt text](<Screenshot From 2026-09-19 18-08-14.png>)
![alt text](<Screenshot From 2026-09-19 18-08-28.png>)
![alt text](<Screenshot From 2026-09-19 18-10-09.png>)

### What is the full journey from git push to a running container?
```bash
My Journey From Git Push to Running a Container

First I created my project and worked on it locally. After completing my changes, I checked my files and then initialized Git in my project.

I added my files using:

"git add ."

Then I committed my changes:

"git commit -m "first commit""

After that I connected my local project with my GitHub repository and pushed my code:

"git push origin main"

Now my code was available on GitHub.

After GitHub, I started working with Docker. First I created a "Dockerfile" in my project. In the Dockerfile I defined what my application needs to run, like the base image, working directory, files, dependencies and the command to start the application.

Then I built a Docker image from my project:

"docker build -t myapp ."

Here, "myapp" is the name of my image and "." means Docker should use the Dockerfile from the current directory.

After building the image, I checked whether the image was created:

"docker images"

Then I created and started a container from that image:

"docker run -d -p 5000:5000 --name mycontainer myapp"

Here:

- "-d" runs the container in the background.
- "-p 5000:5000" maps my host port 5000 to the container port 5000.
- "--name mycontainer" gives my container a name.
- "myapp" is the image from which the container is created.

After running the container, I checked it using:

"docker ps"

If the container was running, I could access my application through the mapped port.

So basically my complete flow was:

My Code
   ↓
git add .
   ↓
git commit
   ↓
git push
   ↓
GitHub
   ↓
Dockerfile
   ↓
docker build
   ↓
Docker Image
   ↓
docker run
   ↓
Docker Container
   ↓
My Application Running

This is how I went from simply pushing my code to GitHub to actually packaging my application into a Docker image and running it inside a container.

For me, the important thing I learned was that an image is the package/template, and the container is the running instance of that image.

```

```bash
My DevOps Journey — From Git Push to Running a Container

My DevOps journey started with Git and GitHub.

At first, I was just learning how to manage my project using Git. I learned how to initialize a repository, add files, commit changes, and finally push my code to GitHub.

My basic flow was:

"git add ."
"git commit -m "my changes""
"git push origin main"

At that time, I was mainly focused on getting my code properly uploaded to GitHub.

After that, I started exploring more DevOps tools. I learned about Linux and started working on Ubuntu. I practiced basic Linux commands, file management, permissions, processes, networking and shell scripting.

Then I moved towards Docker.

At first, Docker was confusing for me. I had to understand the difference between an image and a container. Slowly I understood that a Docker image is like a ready package, while a container is the running instance of that image.

I started with simple Docker commands like:

"docker pull nginx"

Then I learned how to run an image:

"docker run nginx"

After that I learned how to run it in the background and expose ports:

"docker run -d -p 8080:80 nginx"

Then I started creating my own Docker images using a "Dockerfile".

The process became:

My Project
   ↓
Git
   ↓
GitHub
   ↓
Dockerfile
   ↓
docker build
   ↓
Docker Image
   ↓
docker run
   ↓
Docker Container
   ↓
Application Running

I also learned how to check my running containers:

"docker ps"

and check all containers:

"docker ps -a"

I learned how to check Docker images:

"docker images"

and how to see container logs:

"docker logs <container-name>"

Then I started experimenting with Docker networking, ports, volumes and containers communicating with each other.

I also worked with Docker Compose, where instead of running everything separately, I could define my services in a YAML file and start them together.

This journey started from something as simple as:

"git push"

and slowly moved towards:

"docker build"
"docker run"

The biggest thing I learned is that DevOps is not just about knowing commands. It is about understanding the complete flow — code, version control, build, deployment and running the application.

I am still learning, but this was one of the first points where I felt that I was actually doing DevOps instead of just studying it.
```