# Day 41 – Triggers & Matrix Builds

## TASK-1
1. I create .github/workflows/pr-check.yml
2. Trigger it only when a pull request is opened or updated against main
    ```yaml
    on:
      pull_request:
        branches: [main]
        types: [opened]
    ```
3. I added a step that prints: PR check running for branch: <branch name> by using
    ```yaml
    run: echo "branch is ${{ github.ref_name }}"
    ```
4. I create a new branch, push a commit, and open a PR(Pull Request)
    Watch the workflow run automatically

#### Verify: Does it show up on the PR page?
* **YES!** it shows up on the PR page

## TASK-2
1. I added a schedule: trigger to any workflow using cron syntax && Set it to run every day at midnight UTC
    ```yaml
    schedule:
      - cron: '0 0 * * *'
    ```
#### What is the cron expression for every Monday at 9 AM?
* **0 9 * * 1** 

## TASK-3
1. I create .github/workflows/manual.yml with a workflow_dispatch: trigger
    ```yaml
    on:
      workflow_dispatch:
    ```
2. I added an input that asks for an environment name (staging/production)
    ```yaml
    inputs:
            environment:
                description: "Choose Environment"
                default: "staging"
                required: true
                type: choice
                options:
                    - staging
                    - production
    ```
3. Print the input value in a step
    ```yaml
    - name: print input
              run: echo "Environment selected ${{ github.event.inputs.environment }}"
    ```
5. I went to the Actions tab → find the workflow → click Run workflow

#### Verify: Can you trigger it manually and see your input printed?
* **YES!** i triggered it manually and i can see my input printed

## TASK-4

1. I create .github/workflows/matrix.yml that:
    - Uses a matrix strategy to run the same job across:    Python versions: 3.10, 3.11, 3.12
        ```yaml
        matrix:
                os: [ubuntu-latest, windows-latest]
                python-versions: ["3.10", "3.11", "3.12"]
        ```
2. Each job installs Python and prints the version
3. Watch all 3 run in parallel
    - ![alt text](<Screenshot From 2026-09-15 20-16-25.png>)

4. Then i extend the matrix to also include 2 operating systems — how many total jobs run now?
    - Total 5 jobs is running now
    ```yaml
    strategy:
             matrix:
                os: [ubuntu-latest, windows-latest]
                python-versions: ["3.10", "3.11", "3.12"]
    ```

## TASK-5
1. In your matrix, exclude one specific combination (e.g., Python 3.10 on Windows)
    ```yaml
    strategy:
            matrix:
                os: [ubuntu-latest, windows-latest]
                python-versions: ["3.10", "3.11", "3.12"]
                exclude:
                    - os: windows-latest
                      python-versions: "3.10"
    ```
2. Set fail-fast: false — trigger a failure in one job and observe what happens to the rest
    ```yaml
    strategy:
            fail-fast: false
            matrix:
                os: [ubuntu-latest, windows-latest]
                python-versions: ["3.10", "3.11", "3.12"]
                exclude:
                    - os: windows-latest
                      python-versions: "3.10"
    ```
#### What does fail-fast: true (the default) do vs false?
* If it is **TRUE** then it will stop automatically if any versions fails
* If it is **FALSE** then it will run anyways if it fails on any verion or not
