# Day 42 – Runners: GitHub-Hosted & Self-Hosted
## TASK-1
1. I create a workflow with 3 jobs, each on a different OS:
    - **ubuntu-latest**
    - **windows-latest**
    - **macos-latest**
2. In each job, i print:
    - **The OS name**
    - **The runner's hostname**
    - **The current user running the job**

#### What is a GitHub-hosted runner? Who manages it?
* **GitHub-Hosted runner** :- It is a virtual "Operating System" provided by Github org so we can run pipeline-based applications on different OS, It manages by Github org

## TASK-2
1. On the ubuntu-latest runner, run a step that prints: Docker version, Python version, Node version, Git version
    ```yml
    - name: Versions check
              run: |
                docker --version
                python3 --version
                node --version
                git --version

    ```
2. I look up the GitHub docs for the full list of pre-installed software on ubuntu-latest

#### Why does it matter that runners come with tools pre-installed?
* It matters because it doesn't need any space on device and it reduce time required for installing necessary tools and dependencies 

## TASK-3
1. I went to my GitHub repo → Settings → Actions → Runners → New self-hosted runner
    - Choose Linux as the OS
    - Follow the instructions to download and configure the  runner on:
        - My local machine
    - Start the runner — verify it shows as Idle in GitHub

#### Verify: Your runner appears in the Runners list with a green dot.
![alt text](<../day-41/Screenshot From 2026-09-15 20-16-25.png>)

## TASK-4
1. I create .github/workflows/self-hosted.yml
2. Set runs-on: self-hosted
    Add steps that:
        Print the hostname of the machine (it should be YOUR machine/VM), Print the working directory, Create a file and verify it exists on your machine after the run

    ```yml
    steps:
        - name: my runner
          run: |
            hostname
            pwd
            touch my-self-hosted-runner.txt
            [ -f my-self-hosted-runner.txt ] && echo "Exists"
    ```
3. Trigger it and watch it run on your own hardware

#### Verify: Check your machine — is the file there?
* **YES!**, File is in my machine

## TASK-5
1. I added a label to my self-hosted runner `my-linux-runner`
2. I update my workflow to use runs-on: `[self-hosted, my-linux-runner]`

#### Trigger it — does it still pick up the job?
* **NO!** it doesn't pick up the job

#### Why are labels useful when you have multiple self-hosted runners?
* runs only on an online runner that has both labels. Labels are useful for separating runners by operating system, installed tools, hardware, environment, or security requirements.

## TASK-6

### Notes :-

	                      GitHub-Hosted        	   Self-Hosted

    Who manages it? 	 Github org               Manage by self           
    Cost                 Charge/minute            Free of cost	
    Pre-installed tools     YES                         No
    Good for              standard, lightweight   Heavy, Cost Control               	
    Security concern      Security Concern        High Security	