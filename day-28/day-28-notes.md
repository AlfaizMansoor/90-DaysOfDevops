# REVISION OF DAY-[01-27]
## TASK-1 : Self-Assessment Checklist
### Linux

- [x] Navigate the file system, create/move/delete files and directories
- [x] Manage processes — list, kill, background/foreground
- [x] Work with systemd — start, stop, enable, check status of services
- [x] Read and edit text files using vi/vim or nano
- [x] Troubleshoot CPU, memory, and disk issues using top, free, df, du
- [x] Explain the Linux file system hierarchy (/, /etc, /var, /home, /tmp, etc.)
- [x] Create users and groups, manage passwords
- [x] Set file permissions using chmod (numeric and symbolic)
- [x] Change file ownership with chown and chgrp
- [x] Create and manage LVM volumes
- [x] Check network connectivity — ping, curl, netstat, ss, dig, nslookup
- [x] Explain DNS resolution, IP addressing, subnets, and common ports

### Shell Scripting

- [x] Write a script with variables, arguments, and user input
- [x] Use if/elif/else and case statements
- [x] Write for, while, and until loops
- [x] Define and call functions with arguments and return values
- [x] Use grep, awk, sed, sort, uniq for text processing
- [x] Handle errors with set -e, set -u, set -o pipefail, trap
- [x] Schedule scripts with crontab

### Git & GitHub

- [x] Initialize a repo, stage, commit, and view history
- [x] Create and switch branches
- [x] Push to and pull from GitHub
- [x] Explain clone vs fork
- [x] Merge branches — understand fast-forward vs merge commit
- [x] Rebase a branch and explain when to use it vs merge
- [x] Use git stash and git stash pop
- [x] Cherry-pick a commit from another branch
- [x] Explain squash merge vs regular merge
- [x] Use git reset (soft, mixed, hard) and git revert
- [x] Explain GitFlow, GitHub Flow, and Trunk-Based Development
- [x] Use GitHub CLI to create repos, PRs, and issues


## TASK-3 : Quick-Fire Questions
###  What does chmod 755 script.sh do?
- it gives permission for read-r, write-w, and execute-x for user, group, and others.
- while 7 gives full permission tp -rwx- to th user but 5 gives only read and execute permission/acces to group and others.

###  What is the difference between a process and a service?
- A process is running commands to take advantages of services.
- A service is can be a pproduct we used to run processes.

###  How do you find which process is using port 8080?
- this terminal command is used to check service running on which process "8080" `ss -lptn 'sport = :8080'`

###  What does set -euo pipefail do in a shell script?
- Handle errors with set -e, set -u, set -o pipefail
- `euo pipefail` stops the scripts if any error occurs.

###  What is the difference between git reset --hard and git revert?
- `git reset --hard` is used to delete a commit recursively and deletes all the edits we did in last commit.
- `git revert` it undoes a commit and make a new revert commit stores the the last commit and preserves history without deleting it.

###  What branching strategy would you recommend for a team of 5 developers shipping weekly?
- I'll make 5 feature branches for every developer so that they can code on different branch apart from main/master so thAt if any failure occure main branch remains safe.

###  What does git stash do and when would you use it?
- `git stash` stashes a file so we can chage branch do other work on different branch without commiting the work on first branch.
- If i'm working on a file and then a sudden urgent work occurs so at that time i'll use `git stash` 

###  How do you schedule a script to run every day at 3 AM?
- 0 3 * * * /devops_devuqaab/day-19/script.sh

###  What is the difference between git fetch and git pull?
- `git fetch` downloads commits, files, and refs from the remote into your local repository's remote-tracking branches (e.g., origin/main) but does not change your current branch or working tree.
- `git pull` git pull fetches changes from the remote and then integrates them into your current branch.

###  What is LVM and why would you use it instead of regular partitions?
- Logical Volume Management :- It separates logical volume from physical volume so we can use volume when it requires nad stops the wastage of volume.

## TASK-5 : Teach It Back

### Git Branching
- Git branching is very useful for developers we can work on different feature branches apart from main branch if any error occurs in feature branch we can simply deletes that feature branch or resolve the issue then we can merge that feature branch to the main branch. let assume you're working on a electricity circuit board and your job is attach 5 wires to a circuit board now you don't starts working directly on circuit instead we can start connection from the switches one by one whhen all 5 connections done we simply connects/merge that 5 wires of electricity board and then our system starts without any failure.