# Day 44 – Secrets, Artifacts & Running Real Tests in CI
## TASK-1
1. I went to my repo → Settings → Secrets and Variables → Actions
2. Create a secret called **`MY_SECRET_MESSAGE`**
3. Create a workflow that reads it and prints: The secret is set: true (never print the actual value)
    ```yml
    steps: 
            - name: print secret
              run: |
                echo "My Secret is ${{secrets.MY_SECRET_MESSAGE}}"
                echo "The secret is set: True"

    ```
#### Try to print ${{ secrets.MY_SECRET_MESSAGE }} directly — what does GitHub show?
* It shows this **`"***"`** not my secret key

#### Why should you never print secrets in CI logs?
* Printing secrets in CI log is severe security issue if secrets gets leaked hackers can easily hack your app and if your API key is in secrets and gets leaked then it can billed you in lakhs.

## TASK-2
1. Pass a secret to a step as an environment variable
2. I use it in a shell command without ever hardcoding it
3. Add `${{DOCKER_USERNAME}}`  and  `${{DOCKER_TOKEN}}` as secrets (you'll need these on Day 45)

## TASK-3
1. Create a step that generates a file — e.g., a test report or a log file.
    ```yml

    - name: file create
      run: |
        echo "TEST REPORT" > test-report.log
        echo "Timestamp: $(date)" >> test-report.log
        echo "Status: SUCCESS" >> test-report.log
        echo "Passed: 14 tests" >> test-report.log
        echo "Failed: 0 tests" >> test-report.log
    ```
2. Use actions/upload-artifact to save it
    ```yml
    - name: upload artifact
      uses: actions/upload-artifact@v4
      with:
        path: test-report.log
    ```
3. After the workflow runs, i download the artifact from the Actions tab 


#### Verify: Can you see and download it from GitHub?
* **YES!** i can download it direct from github

## TASK-4
1. I create Job 1: to generate a file and upload it as an artifact
    ```yml
    file-generate:
        runs-on: ubuntu-latest
        steps:
            - name: Checkout code
              uses: actions/checkout@v4

            - name: create file
              run: |
                echo "TEST REPORT" > report-practice.log
                echo "Timestamp: $(date)" >> report-practice.log
                echo "Status: SUCCESS" >> report-practice.log
                echo "Passed: 14 tests" >> report-practice.log
                echo "Failed: 0 tests" >> report-practice.log

            - name: Download artifact 
              uses: actions/upload-artifact@v7
              with: 
                name: created file
                path: report-practice.log
    ```
2. I create a another Job 2: to download the artifact from Job 1 and use it.
    ```yml
    download-artifact:
        needs: [file-generate]
        runs-on: ubuntu-latest
        steps:
            - name: Download artifact 
              uses: actions/download-artifact@v7
              with: 
                name: created file
            - run: cat report-practice.log            
    ```

#### When would you use artifacts in a real pipeline?
* when you need to pass files between different jobs in the same pipeline run, or when you want to download and view the final results.

## TASK-5

1. I add your script to the github-actions-practice repo
2. Write a workflow that:
    - Checks out the code
    - Installs any dependencies needed
    - Runs the script
    - Fails the pipeline if the script exits with a non-zero code
    ```yml
    steps: 
            - name: Checkout code
              uses: actions/checkout@v4

            - name: Set up Python environment
              uses: actions/setup-python@v5
              with:
                python-version: '3.13'

            - name: install curl
              run: |
                sudo apt-get update -y
                sudo apt-get install -y curl
            
            - name: app run
              run: |
                pip install -r requirements.txt
                python app.py &
                sleep 5
                curl -f http://127.0.0.1:5000

            - name: failed
              run: echo "script fixed"
    ```
3. Intentionally break the script — verify the pipeline goes red
4. Fix it — verify it goes green again
    ![alt text](<Screenshot From 2026-09-18 19-40-52.png>)

## TASK-6
1. Add actions/cache to a workflow that installs dependencies
    ```yml
    - name: cache
              uses: actions/cache@v4
              with: 
                path: ~/.cache/pip
                key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    ```
2. Run it twice — observe the time difference
    ![alt text](<Screenshot From 2026-09-18 19-45-54.png>)
    
#### What is being cached and where is it stored?
* It stores Compiled packages and installer metadata On Virtual machine runner and on Github secure cloud