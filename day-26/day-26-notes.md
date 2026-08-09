# TASK-1

## What authentication methods does gh support?
* {
  "id": 31212487796,
  "name": "Running Copilot Code Review",
  "event": "dynamic",
  "status": "completed",
  "conclusion": "success",
  "created_at": "2026-08-07T19:40:16Z",
  "html_url": "https://github.com/octocat/Hello-World/actions/runs/31212487796"
}
{
  "id": 28205921175,
  "name": "Running Copilot Code Review",
  "event": "dynamic",
  "status": "completed",
  "conclusion": "success",
  "created_at": "2026-06-25T23:01:55Z",
  "html_url": "https://github.com/octocat/Hello-World/actions/runs/28205921175"
}
{
  "id": 23372736275,
  "name": "Copilot code review",
  "event": "dynamic",
  "status": "completed",
  "conclusion": "failure",
  "created_at": "2026-03-21T05:15:12Z",
  "html_url": "https://github.com/octocat/Hello-World/actions/runs/23372736275"
}
{
  "id": 23031637328,
  "name": "Copilot code review",
  "event": "dynamic",
  "status": "completed",
  "conclusion": "failure",
  "created_at": "2026-03-13T01:13:05Z",
  "html_url": "https://github.com/octocat/Hello-World/actions/runs/23031637328"
}
{
  "id": 22796200342,
  "name": "Copilot code review",
  "event": "dynamic",
  "status": "completed",
  "conclusion": "failure",
  "created_at": "2026-03-07T09:09:18Z",
  "html_url": "https://github.com/octocat/Hello-World/actions/runs/22796200342"
}

# TASK-3
## How could you use gh issue in a script or automation?
* Use `gh issue create`, `gh issue list`, `gh issue view`, and `gh issue edit` in shell scripts to manage issues programmatically.
* Use `--json` and `--jq` to parse output in automation, for example: `gh issue list --limit 5 --json number,title,state | jq '.[] | {number,title,state}'`.
* Automate bug tracking by creating issues for CI failures, adding comments from scripts, or updating issue state from deployment pipelines.

# TASK-4
## What merge methods does gh pr merge support?
* `merge` (merge commit)
* `squash` (squash and merge)
* `rebase` (rebase and merge)

## How would you review someone else's PR using gh?
* Use `gh pr checkout <number>` to check out the PR branch locally.
* Use `gh pr diff <number>` or `gh pr view <number>` to inspect changes.
* Use `gh pr review <number> --approve`, `--request-changes`, or `--comment` to submit feedback.

# TASK-5
## How could gh run and gh workflow be useful in a CI/CD pipeline?
* `gh workflow run <workflow.yml>` can trigger workflows from scripts or automation.
* `gh run list` and `gh run view <run-id>` can inspect run history, status, and logs.
* These commands help pipelines trigger dependent jobs, rerun failed workflows, and integrate GitHub Actions with external deployment steps.

# TASK-6
## gh search repos
* Use `gh search repos <query>` to find repositories from the command line, e.g. `gh search repos "topic:actions language:js" --limit 10`.
* Useful for discovering public repos, filtering by topic, language, owner, or visibility in automation.
