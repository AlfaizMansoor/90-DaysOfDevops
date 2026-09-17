# Day 43 – Jobs, Steps, Env Vars & Conditionals
## TASK-1
1. I create .github/workflows/multi-job.yml with 3 jobs:
    - **build — prints "Building the app"**
    - **test — prints "Running tests"**
    - **deploy — prints "Deploying"**

2. I make test run only after build succeeds. Make deploy run only after test succeeds.

#### Verify: Check the workflow graph in the Actions tab — does it show the dependency chain?
* **YES!** dependency chain is visible

## TASK-2
1. In a new workflow, use environment variables at 3 levels:
    - **Workflow level — `APP_NAME: myapp`**
    - **Job level — `ENVIRONMENT: staging`**
    - **Step level — `VERSION: 1.0.0`**

#### Print all three in a single step and verify each is accessible.
* All three Environments together
    ```yml
    steps:
        - name: deploy app
          run: |
            echo "Deploying"
            echo "App Name: $APP_NAME"
            echo "Environment: $ENVIRONMENT"
            echo "Version: $VERSION"
            echo "Commit SHA  : ${{ github.sha }}"
            echo "Triggered By: ${{ github.actor }}"
    ```

#### Then use a GitHub context variable — print the commit SHA and the actor (who triggered the run).
* Commit SHA and the actor
    ```yml
    steps:
        - name: deploy app
          run: |
            echo "Deploying"
            echo "App Name: $APP_NAME"
            echo "Environment: $ENVIRONMENT"
            echo "Version: $VERSION"
            echo "Commit SHA  : ${{ github.sha }}"
            echo "Triggered By: ${{ github.actor }}"
    ```

## TASK-3
1. I create a job that sets an output — e.g., today's date as a string
2. Later i create a second job that reads that output and prints it
3. Pass the value using outputs: and needs.<job>.outputs.<name>

#### Why would you pass outputs between jobs?
* because GitHub Actions runner environments are completely isolated from each other.

## TASK-4
1. In a workflow, add:
    - A step that only runs when the branch is main
        ```yml
        runs-on: ubuntu-latest
        steps:
            - name: workflow run
              if: github.ref == 'main'
              run: echo "workflow is running on branch main"
        ```

    - A step that only runs when the previous step failed
        ```yml
        fail:
        runs-on: ubuntu-latest
        steps: 
            - name: failed step
              run: exit 1

            - name: Run on failure
              if: failure()
              run: echo "This step is running because the previous step is failed"
        ```

    - A job that only runs on push events, not on pull requests
        ```yml
         push-event:
        runs-on: ubuntu-latest
        if: github.event_name == 'push'
        ```

    - A step with continue-on-error: true — what does this do?
        ```yml
        - name: continue
              continue-on-error: true
              run: sudo apt-get update && sudo apt-get install -y python3
        ```

## TASK-5

1. I create .github/workflows/smart-pipeline.yml that:
    - Triggers on push to any branch
        ```yml
        on:
            push:
        ```

    - Has a lint job and a test job running in parallel
        ```yml
        jobs:
            lint-job:
                runs-on: ubuntu-latest 
                steps:
                    - name: Checkout code
                      uses: actions/checkout@v4

                    - name: Set up Python environment
                      uses: actions/setup-python@v5
                      with:
                        python-version: '3.11'

                    - name: Install Linting Tools
                      run: |
                        pip install -r requirements.txt
                        ruff check app.py

            test-job: 
                runs-on: ubuntu-latest
                steps:
                    - name: Checkout code
                      uses: actions/checkout@v4

                    - name: Set up Python environment
                      uses: actions/setup-python@v5
                      with:
                        python-version: '3.12'

                    - name: Install dependencies
                      run: |
                        pip install -r requirements.txt
                        python -m pytest app.py || [ $? -eq 5 ]
        ```
    - Has a `summary` job that runs after both, prints whether it's a main branch push or a feature branch push, and prints the commit message
        ```yml
        summary:
        runs-on: ubuntu-latest
        steps:
            - name: Identify Branch Push Type
              run: |
                if [ "${{ github.ref_name }}" = "main" ]; then
                  echo "This is a main branch push! Ready for production deployment."
                else
                  echo "This is a feature branch push! Running tests on branch: ${{ github.ref_name }}"
                fi
                echo "commit message: ${{ github.event.commits[0].message }}"
        ```