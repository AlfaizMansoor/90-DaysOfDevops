# Day 46 – Reusable Workflows & Composite Actions
## TASK-1
#### What is a reusable workflow?
* A reusable workflow is a feature in Github Actions that allows us to reuse an entire workflow file across mltiple other workflows, whatever it's present in same diretory or different directory.

#### What is the workflow_call trigger?
* `workflow_call` event is a trigger used in the on: block of a workflow file to make it "reusable." Without this trigger, a workflow cannot be called by other workflows.

#### How is calling a reusable workflow different from using a regular action (uses:)?
* **Reusable Workflow :-** 
    - Contains one or more Jobs (which contain steps)
    - Defines its own runs-on runners per job.
    - Best for entire delivery pipelines (Build → Test → Deploy).
    - Visualised as distinct sub-jobs in the GitHub Actions UI.

* **Custom Action :-**
    - Contains Steps (which run inside a single job)
    - Inherits the runner defined by the host job.
    - Best for isolated tasks (e.g., logging in to AWS, setting up Node.js).
    - Local actions require an explicit actions/checkout first.

#### Where must a reusable workflow file live?
* A reusable workflow file must live in the .github/workflows/ directory of a repository.

## TASK-2
1. I create **.github/workflows/reusable-build.yml**:
2. I set the trigger to `workflow_call:`
3. I added an `inputs:` section with:
    - `app_name:` **(string, required)**
    - `environment:` **(string, required, default: staging)**
4. I added a secrets: section with:
    - `docker_token:` **(required)**
5. Create a job that:
    - Checks out the code
    - Prints Building `app_name:` for `environment:`
    - Prints Docker token is set: true (never print the actual secret)

    ```yml
    workflow_call:
        inputs:
            app-name:
                type: string
                required: true
            environment: 
                description: "Describe environment"
                type: string
                default: "staging"
                required: true
        secrets:
            docker_token: 
                required: true 
    ```
    ```yml
     - name: Prints docker token
       run: echo "Docker token is set:true"
    ```

#### Verify: This file alone won't run — it needs a caller. That's next.
* Workflow file can't run without caller workflow.

## TASK-3
1. I Create .github/workflows/call-build.yml:
2. It trigger on push to main
3. Add a job that uses your reusable workflow:
    ```yml
    jobs:
      build:
        uses: ./.github/workflows/reusable-build.yml
        with:
          app_name: "my-web-app"
          environment: "production"
        secrets:
          docker_token: ${{ secrets.DOCKER_TOKEN }}
    ```
4. I push to main and watch it run
    ```yml
    build:
        uses: ./.github/workflows/reusable-build.yml
        with:
            app-name: "my-web-app"
            environment: "production"
        secrets:
            docker_token: ${{ secrets.DOCKER_TOKEN }}

    ```

#### Verify: In the Actions tab, do you see the caller triggering the reusable workflow? Click into the job — can you see the inputs printed?
* **YES!** I verifies that my caller worflow triggering workflow trigger
* **YES!** I can see my inputs printed.

## TASK-4

1. I extend reusable-build.yml:
    - Add an `outputs:` section that exposes a `build_version:` value
    - Inside the job, generate a version string (e.g., v1.0-<short-sha>) and set it as output
2. In my caller workflow, add a second job that:
    - Depends on the build job (`needs:`)
    - Reads and prints the `build_version:` output

    ```yml
     outputs:
            build_version:
                value: ${{ jobs.building.outputs.version_output }}
    ```
    ```yml
    Building:
        runs-on: ubuntu-latest
        outputs:
            version_output: ${{ steps.generate-version.outputs.version }}
        
        steps:
            - name: Build version
              id: generate-version
              run: VERSION_STRING="v1.0-${{github.sha}}"
    ```

#### Verify: Does the second job print the version from the reusable workflow?
* **YES!** second job prints version from reusable workflow

## TASK-5:
1. I create a custom composite action in my repo at .github/actions/setup-and-greet/action.yml:
2. Define `inputs:` name and language (`default: en`)
3. Add steps that:
    - Print a greeting in the specified language
    - Print the current date and runner OS
    - Set an output called greeted with value true
4. Use the composite action in a new workflow with uses: ./.github/actions/setup-and-greet

#### Verify: Does your custom action run and print the greeting?
* **YES!** my custom workflow action run and print greetings
## TASK-6
    ```bash

	                                Reusable Workflow 	                  Composite Action

    Triggered by 	                workflow_call 	                      uses: in a step
    Can contain jobs? 	                YES                                    NO
    Can contain multiple steps?         YES                                    YES
    Lives where? 	                .github/workflows/                    .github/actions/
    Can accept secrets directly?        YES                                    NO
    Best for 	                    High-level Orchastration              Granular step reusability

    ```

#### URL's :-

* **reusable-build.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/reusable-build.yml>

* **call-build :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/call-build.yml>

* **action.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/actions/setup-and-greet/action.yml>

* **greet.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/greet.yml>

#### Status :-
[![workflow run](https://github.com/AlfaizMansoor/github-actions-practice/actions/workflows/call-build.yml/badge.svg?branch=main&event=push)](https://github.com/AlfaizMansoor/github-actions-practice/actions/workflows/call-build.yml)

![alt text](<Screenshot From 2026-09-20 16-51-06.png>)
![alt text](<Screenshot From 2026-09-20 12-25-07.png>)