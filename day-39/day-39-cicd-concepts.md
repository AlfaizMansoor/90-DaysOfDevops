# Day 39 – What is CI/CD?
## TASK-1
### Scenerio -
**"Think about a team of 5 developers all pushing code to the same repo manually deploying to production."**

### Questions rises -
#### 1. What can go wrong?
* Deploying manually is time taking and make cause security risks, failure in deploying, server issues, tesing fail, delaying in deploying, etc.
* 5 developers deploying different codes at same time it may cause merge conflicts and deploying fails, deploying different codes by different developers may cause the code conjused, and hard to understand.

#### 2. What does "it works on my machine" mean and why is it a real problem?
* It means that a app working on some specific environments and dependencies that is not installed or setup on clients server.
* **NO!** this is not real problem, we can fix this issue by making **"Dockerfile"** and **"docker-compose.yml"** files after that our code/web/app can easily run on client server by following a few steps

#### 3. How many times a day can a team safely deploy manually?
* It doesn't fix because of security that many times errors occurs and too much time require to fix it those errors and bugs, so count of safely deploying production is can be one or two. 

## TASK-2: 

#### 1.Continuous Integration — what happens, how often, what it catches.
* Developers merge code into a shared repo several times a day, automate builds and est run to validate changes.
* Every commit, push or pull request triggers CI.
* It catches integration bugs, broken builds, failed tests, dependency conflicts, lint issues.

#### 2. Continuous Delivery — how it's different from CI, what "delivery" means
* When CI extends, it automaticallly packaging and prepare builds for release.
* Delivery means a software which is tested successfully and ready to deploy, can be pushed to production state any time.

#### 3. Continuous Deployment — how it differs from Delivery, when teams use it.
* Delivery means a code ready to deploy at any time build, tested and ready to deploy, where Deployment means a code is build, test a automatically deploys to the production.
* High‑performing teams with strong test coverage, monitoring, and rollback strategies.


## TASK-3: 
1. **Trigger** — It starts/triggers the pipeline and run the pipeline, we can trigger pipeline by push, commit, pull request and manually.

2. Stage — a pipeline is build of a few stages which ensures that a project is safe, secure and ready to deploy.

3. Job — it is a unit of works inside a stage that ensures that every job is done layer by layer.

4. Step — it a or a few actions in job which can be done step by step
    
5. Runner — it a virtual machine that executes the steps of the job inside the machine.

6. Artifact — after execution of the pipeline we can easily see the artifacts which is output produced 

## TASK-4
**A developer pushes code to GitHub. The app is tested, built into a Docker image, and deployed to a staging server.**

- Include at least 3 stages. Hand-drawn and photographed is perfectly fine.

![alt text](<WhatsApp Image 2026-09-08 at 00.50.43.jpeg>)

## TASK-5 
1. Open any popular open-source repo on GitHub (Kubernetes, React, FastAPI — pick one you know)
    * **FASTAPI** - <https://github.com/fastapi/full-stack-fastapi-template/blob/master/.github/workflows/playwright.yml>

2. Find their **".github/workflows/"** folder.

3. Open one workflow YAML file
    * i open  **.github/workflows/playwright.yml**

4. Write in your notes:
    - What triggers it?
    ```yaml
        - on:
            push:
                branches:
                    - master
            pull_request:
            workflow_dispatch:
    ```
    - How many jobs does it have?
        - It has total 4 jobs

    - What does it do? (best guess)
        - It do Playywright tests and ensures that the file is being ready to deploy.

