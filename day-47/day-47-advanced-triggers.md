# Day 47 – Advanced Triggers: PR Events, Cron Schedules & Event-Driven Pipelines
## TASK-1
1. I create **.github/workflows/pr-lifecycle.yml** that triggers on `pull_request:` with specific activity types:
    - Trigger on: **(opened, synchronize, reopened, closed)**
2. Add steps that:
    - Print which **event type fired: `${{ github.event.action }}`**
    - Print the **PR title: `${{ github.event.pull_request.title }}`**
    - Print the **PR author: `${{ github.event.pull_request.user.login }}`**
    - Print the **source branch and target branch :`${{github.head_ref}}` and `${{github.base_ref}}`**
3. Add a conditional step that only runs when the PR is merged (closed + merged = true)

#### Test it: create a PR, push an update to it, then merge it. Watch the workflow fire each time with a different event type.
* I create pull-requests, push updates, then merge them then i watch the workflow fire each time with a diifferent event.

## TASK-2
1. I create **.github/workflows/pr-checks.yml** — a real-world PR gate:
2. Trigger on `pull_request:` to main
3. Add a job file-size-check that:
    - Checks out the code
    - Fails if any file in the PR is larger than 1 MB
4. Add a job `branch-name-check` that:
    - Reads the branch name from `${{ github.head_ref }}`
    - Fails if it doesn't follow the pattern **(feature/*, fix/*, or docs/*)**
5. Add a job `pr-body-check:` that:
    - Reads the PR body: `${{ github.event.pull_request.body }}`
    - Warns (but doesn't fail) if the PR description is empty

#### Verify: Open a PR from a badly named branch — does the check fail?
* **YES!** it fails always with badly named branch

## TASK-3
1. Create .github/workflows/scheduled-tasks.yml:
2. Add a schedule trigger with `- cron: '30 2 * * 1'` (every Monday at 2:30 AM UTC)
3. Add another cron entry: `'0 */6 * * *'` (every 6 hours)
4. In the job, print which schedule triggered using `${{ github.event.schedule }}`
5. Add a step that acts as a health check — curl a URL and check the response code

#### The cron expression for: every weekday at 9 AM IST
* `0 9 * * 0`
#### The cron expression for: first day of every month at midnight
* `* * 1 * *`
#### Why GitHub says scheduled workflows may be delayed or skipped on inactive repos.
* GitHub delays or disables scheduled workflows on inactive repositories to optimize resource allocation and manage platform load.

#### Important: Also add workflow_dispatch so you can test it manually without waiting for the schedule.

## TASK-4
1. Create .github/workflows/smart-triggers.yml:
2. Trigger on push but only when files in src/ or app/ change:
    ```yml
    on:
      push:
        paths:
          - 'src/**'
          - 'app/**'
    ```
3. Add paths-ignore in a second workflow that skips runs when only docs change:
    ```yml
    on:
      push:
        paths-ignore:
            - '*.md'
            - 'docs/**'
    ```
3. Add branch filters to only trigger on main and release/* branches
4. Test it: push a change to a .md file — does the workflow skip?

#### When would you use paths vs paths-ignore?
* **paths :** it baiscally means if we edit and pushed to the selected files we describe in `paths:` then worflows run
* **paths-ignore :** it baiscally means if we edit and pushed to the selected files we describe in `paths-ignore:` then worflows will not run on these selected files/folders

## TASK-5
1. I create two workflows:
    - **.github/workflows/tests.yml** — runs tests on every push
    - **.github/workflows/deploy-after-tests.yml** — triggers only after tests.yml completes successfully:
    ```yml
    on:
      workflow_run:
        workflows: ["Run Tests"]
        types: [completed]
    ```
2. In the deploy workflow, add a conditional:
    - Only proceed if the triggering workflow succeeded `(${{ github.event.workflow_run.conclusion == 'success' }})`
    - Print a warning and exit if it failed

#### Verify: Push a commit — does the test workflow run first, then trigger the deploy workflow?
* **YES!** "deploy" workflow runs at first after successfully completed the "Run Tests" job  

## TASK-6
1. Create **.github/workflows/external-trigger.yml** with trigger `repository_dispatch:~
2. Set it to respond to event type: `deploy-request:`
    - Print the **client payload: `${{ github.event.client_payload.environment }}`**
3. Trigger it using curl or gh:

    ```bash
    gh api repos/<owner>/<repo>/dispatches \
      -f event_type=deploy-request \
      -f client_payload='{"environment":"production"}'
    ```
#### When would an external system (like a Slack bot or monitoring tool) trigger a pipeline?
* When would an external system (like a Slack bot or monitoring tool) trigger a pipeline?

#### URL's

* **pr-lifecycle.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/pr-lifecycle.yml>

* **pr-checks.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/pr-checks.yml>

* **external-trigger.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/external-trigger.yml>

* **deploy-after-tests.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/deploy-after-tests.yml>

* **tests.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/tests.yml>

* **smart-triggers.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/smart-triggers.yml>

* **scheduled-tasks.yml :-** <https://github.com/AlfaizMansoor/github-actions-practice/blob/main/.github/workflows/scheduled-tasks.yml>

#### cron Expression's

* **every Monday at 2:30 AM UTC :-** `30 2 * * 1`
* **every 6 hours :-** `0 */6 * * *`

## pr-check image
### Fails because branch didn't exist
- ![alt text](<Pasted image.png>)

## workflow_run:
* It's used to run a different and separate pipeline to start after another.
* The downstream workflow has to wait until the upstream workflow is 100% complete.
* Chains pipelines together depends on process status.

## workflow_call:
* It is used when we have written a complex series of steps.
* It is used to run same code blocks to different workflows without rewriting the same code to different workflows.
* It doesn't wait to finish the running workflows it pauses the runnng workflows and starts another on it embeded with.
* Runs code against the triggering branch.