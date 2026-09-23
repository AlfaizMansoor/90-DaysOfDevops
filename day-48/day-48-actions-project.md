# Day 48 – GitHub Actions Project: End-to-End CI/CD Pipeline
## TASK-1
1. I create a new repo called github-actions-capstone (or use your existing github-actions-practice)
2. Add a simple app:
    - A Python Flask/FastAPI app with one endpoint (Your Dockerized app from Day 36)
3. Add a Dockerfile and a basic test (even a script that curls the health endpoint counts)
4. Add a **README.md** with a project description

## TASK-2
1. I create **.github/workflows/reusable-build-test.yml:**
2. Trigger: `workflow_call:`
3. Inputs: `python_version:` (or node_version), `run_tests:` **(boolean, default: true)**
4. Steps:
    - Check out code
    - Set up the language runtime
    - Install dependencies
    - Run tests (only if run_tests is true)
    - Set `output: test_result` with value passed or failed

*This workflow does NOT deploy — it only builds and tests.

## TASK-3
1. I create **.github/workflows/reusable-docker.yml:**
2. Trigger: `workflow_call:`
3. Inputs: `image_name:` **(string)**, `tag:` **(string)**
4. Secrets: `DOCKER_USERNAME`, `DOCKER_TOKEN`
5. Steps:
    - Check out code
    - Log in to Docker Hub
    - Build and push the image with the given tag
    - Set `output: image_url` with the full image path

## TASK-4
1. I create **.github/workflows/pr-pipeline.yml:**
2. Trigger: `pull_request:` to [main] **(types: opened, synchronize)**
3. Call the reusable build-test workflow:
    - `Run tests: true`
4. Add a standalone job `pr-comment:` that:
    - Runs after the build-test job
    - Prints a summary: "PR checks passed for branch: <branch>"
5. Do NOT build or push Docker images on PRs

![alt text](<Screenshot From 2026-09-23 11-58-11.png>)

#### Verify: Open a PR — does it run tests only (no Docker push)?

## TASK-5
1. Create **.github/workflows/main-pipeline.yml:**
2. Trigger: push to main
3. Job 1: Call the reusable build-test workflow
4. Job 2 (depends on Job 1): Call the reusable Docker workflow
    - Tag: latest and sha-<short-commit-hash>
5. Job 3 (depends on Job 2): deploy job that:
    - Prints "Deploying image: <image_url> to production"
    - Uses environment: production (set this up in repo Settings → Environments)
    
![alt text](<Screenshot From 2026-09-23 11-57-55.png>)

#### Verify: Merge a PR to main — does it run tests → build Docker → deploy in sequence?
* **YES!** after merging a pr it deploys in sequence.

## TASK-6
1. Create **.github/workflows/health-check.yml:**
2. Trigger: schedule with cron `'0 */12 * * *'` *(every 12 hours) + `workflow_dispatch:` for manual testing
3. Steps:
    - Pull your latest Docker image
    - Run the container in detached mode
    - Wait 5 seconds, then curl the health endpoint
    - Print pass/fail based on the response
    - Stop and remove the container
4. Add a step that creates a summary using $GITHUB_STEP_SUMMARY:
    ```bash
    echo "## Health Check Report" >> $GITHUB_STEP_SUMMARY
    echo "- Image: myapp:latest" >> $GITHUB_STEP_SUMMARY
    echo "- Status: PASSED" >> $GITHUB_STEP_SUMMARY
    echo "- Time: $(date)" >> $GITHUB_STEP_SUMMARY
    ```

## TASK-7

1. Add status badges for all your workflows to the repo README.md
    - **Main branch pipeline:** 
        - [![main branch pipeline](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/main-pipeline.yml/badge.svg)](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/main-pipeline.yml)
    
    - **Health check:**
        - [![health check](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/health-check.yml/badge.svg)](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/health-check.yml)

    - **PR pipeline:**
        - [![pr pipeline](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/pr-pipeline.yml/badge.svg)](https://github.com/AlfaizMansoor/github-actions-capstone/actions/workflows/pr-pipeline.yml)

2. Add a pipeline architecture diagram in your notes — draw (or describe) the flow:
    ```mermaid
    %%{init: {'theme': 'neutral', 'themeVariables': { 'primaryTextColor': '#222222', 'edgeLabelBackground':'#ffffff'}}}%%
    graph TD
        A[PR opened] --> B[build & test]
        B --> C[PR checks pass]
        C --> D[Merge to main]
        D --> E[build & test]
        E --> F[Docker build & push]
        F --> G[deploy]
        G --> H[Every 12 hours]
        H --> I[health check]
    ```
    
#### What would you add next? (Slack notifications? Multi-environment? Rollback?)
* Muti-environment &#8594; Slack notifications &#8594; Rollbacks

### Image URL:
* **devuqaab/github-actions-capstone:<tag>:** <https://hub.docker.com/repository/docker/devuqaab/github-actions-capstone/general>

### Workflow files:
* **.github/workflows/reusable-build-test.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/reusable-build-test.yml>

* **.github/workflows/reusable-docker.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/reusable-docker.yml>

* **.github/workflows/pr-pipeline.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/pr-pipeline.yml>

* **.github/workflows/main-pipeline.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/main-pipeline.yml>

* **.github/workflows/health-check.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/health-check.yml>

#### What i'll improve?
* I'll improve health checks and security