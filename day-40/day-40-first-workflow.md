# Day 40 – Your First GitHub Actions Workflow
## TASK-1
1. I create a new public GitHub repository called **"github-actions-practice"**
2. I clone it locally
3. Later i create the folder structure: .github/workflows/

## TASK-2
1. I create **".github/workflows/hello.yml"** with a workflow that:
    - Triggers on every push
    - Has one job called greet
    - Runs on ubuntu-latest
    - Has two steps:
        - **Step 1**: Check out the code using actions/checkout
        - **Step 2**: Print Hello from GitHub Actions!

2. I push it. then Go to the Actions tab on GitHub and watch it run.

#### Verify: Is it green? Click into the job and read every step.
* **YES!** it is green, i read every single step from its job.

## TASK-3
1. **on:**
* It triggers the workflow and runs the pipeline on several operations like - push, commit, pull request and workflow dispatch(manually)

2. **jobs:**
* It is a group of stages called jobs where multiple stages can run one by one.

3. **runs-on:**
* It is an virtual machine which runs and executes the pipelines into it.

4. **steps:**
* A few layers in a job that executes one by one and make the production deployable

5. **uses:**
* It use to give reference of predfined actions instead of writing logic by self

6. **run:**
* It executes the commands related to the production on the runner
    
7. **name:**
* Used to define a name of steps in job

## TASK-4
    
1. I upgraded my previous "hello.yaml" file, Print the current date and time
2. I print the name of the branch that triggered the run (hint: GitHub provides this as a variable)
    - ${{github.ref_name}}
3. List the files in the repo
    - ls -R
4. Print the runner's operating system
    - ${{runner.os}}

##### I Pushed again — watch the new run.

## TASK-5
1. I add a step that runs a command that will fail (e.g., exit 1 or a misspelled command)
2. I Push and observe what happens in the Actions tab
3. Fix it and push again by fixing it's command

#### Write in your notes: What does a failed pipeline look like? How do you read the error?

```bash
0s
Run mkdipr day-40
  mkdipr day-40
  shell: /usr/bin/bash -e {0}
/home/runner/work/_temp/93082525-18c1-4c64-bf6a-0a34e66085d0.sh: line 1: mkdipr: command not found
Error: Process completed with exit code 127.
```

##### REPO LINK :- <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/hello.yaml>