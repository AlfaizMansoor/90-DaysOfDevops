# Day 49 – DevSecOps: Add Security to Your CI/CD Pipeline
### What is DevSecOps?
* DevSecOps is advanced security a Devops Engineer applies while deploying an app by scanning pipelines, review and test code 

#### Without DevSecOps:

* You build the app → deploy it → a security team finds a vulnerability weeks later → you scramble to fix it

#### With DevSecOps:

* You open a PR → the pipeline automatically checks for vulnerabilities → you fix it before it ever gets merged

## Key Principles (To Keep These in Mind)
* Catch problems early — A vulnerability found in a PR takes 5 minutes to fix. The same vulnerability found in production takes days.

* Automate the checks — Don't rely on someone remembering to check. Let the pipeline do it every time.

* Block on critical issues — If a scan finds a serious vulnerability, the pipeline should fail — just like a failing test.

* Never put secrets in code — Use GitHub Secrets (you learned this on Day 44). No .env files, no hardcoded API keys.

* Give only the access needed — Your workflow doesn't need write access to everything. Limit permissions.

## TASK-1
1. My Docker image might use a base image with known security issues. Let's find out.
2. I Add this step to my main branch pipeline (after Docker build, before deploy):
  ```yml
  - name: Scan Docker Image for Vulnerabilities
    uses: aquasecurity/trivy-action@master
    with:
      image-ref: 'your-username/your-app:latest'
      format: 'table'
      exit-code: '1'
      severity: 'CRITICAL,HIGH'
  ```
* What this does:
  - trivy scans your Docker image for known CVEs (Common Vulnerabilities and Exposures)
  - format: 'table' prints a readable table in the logs
  - exit-code: '1' means fail the pipeline if CRITICAL or HIGH vulnerabilities are found
  - If it passes, your image is clean — proceed to push and deploy

#### Verify: Can you see the vulnerability table in the logs? Did it pass or fail?
* **YES!** I found 1 severe/critical vulnerability in the log table. it failed
#### What CVEs (if any) were found? What base image are you using?
* **YES!** i found 1 CVE, i'm using base image **:latest**

## TASK-2
* GitHub can automatically detect if someone pushes a secret (API key, token, password) to your repo.
1. I went to my repo → Settings → Code security and analysis
2. Enable Secret scanning
3. If available, also enable Push protection — this blocks the push entirely if a secret is detected

#### What is the difference between secret scanning and push protection?
* **Secret scanning:-** If github finds that if any secret is revealed in push and remediate it.
* **Push protection:-** Block and prevent credentials from ever reaching the server.
#### What happens if GitHub detects a leaked AWS key in your repo?
* If you accidentally commit and push a live AWS Access Key to a repository, an incredibly fast, highly automated security relay race triggers between GitHub and Amazon Web Services (AWS) to protect your infrastructure.

## TASK-3
1. Add this to your PR pipeline (not the main pipeline):
  ```yml
  - name: Check Dependencies for Vulnerabilities
    uses: actions/dependency-review-action@v4
    with:
      fail-on-severity: critical
  ```
* This checks any new dependencies added in the PR against a vulnerability database. If a dependency has a critical CVE, the PR check fails.

* I Test it:
  - Open a PR that adds a package to your app
  - Check the Actions tab — did the dependency review run?

#### Verify: Does the dependency review show up as a check on your PR?
* **YES!** dependency review was in there as logs

## TASK-4
1. I Add this block near the top of your workflow files (after on:):
  ```yml
  permissions:
    contents: read
  ```

* I Update all of my existing workflow files with a permissions block.

#### Why is it a good practice to limit workflow permissions? What could go wrong if a compromised action has write access to your repo?
* Limiting permissions stops hackers from using compromised automated steps to attack your code [GitHub Actions Workflows].
* If an attacker gets write access, they can:Inject backdoors straight into your production app.
* Steal private API keys and database passwords.Corrupt releases and push malicious Docker images.
* Delete branches, tags, or deployment pipelines.
* The Fix: Add permissions: contents: read to the top of your YAML files [GitHub Actions Workflows].

## TASK-5
* Look at what your pipeline does now:
```mermaid
PR opened
  → build & test
  → dependency vulnerability check     ← NEW (Day 49)
  → PR checks pass or fail

Merge to main
  → build & test
  → Docker build
  → Trivy image scan (fail on CRITICAL) ← NEW (Day 49)
  → Docker push (only if scan passes)
  → deploy

Always active
  → GitHub secret scanning              ← NEW (Day 49)
  → push protection for secrets         ← NEW (Day 49)

Draw this diagram in your notes. You just built a DevSecOps pipeline — security is now part of your automation, not an afterthought.
```

### Workflow files:
* **.github/workflows/reusable-build-test.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/reusable-build-test.yml>

* **.github/workflows/reusable-docker.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/reusable-docker.yml>

* **.github/workflows/pr-pipeline.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/pr-pipeline.yml>

* **.github/workflows/main-pipeline.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/main-pipeline.yml>

* **.github/workflows/health-check.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/health-check.yml>

* **.github/workflows/docker-image-scan.yml :-** <https://github.com/AlfaizMansoor/github-actions-capstone/blob/main/.github/workflows/docker-image-scan.yml>

![alt text](<Screenshot From 2026-09-23 19-29-22.png>)
![alt text](<Screenshot From 2026-09-23 19-30-18.png>)
![alt text](<Screenshot From 2026-09-23 19-30-35.png>)
![alt text](<Screenshot From 2026-09-23 19-32-20.png>)
