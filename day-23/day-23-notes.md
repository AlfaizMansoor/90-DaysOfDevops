# What is a branch in Git?
* branch is a pointer or path to a specific commit so we can see that commit in history.
- by default Git creates `main` branch.

# Why do we use branches instead of committing everything to main?
* we need multiple branches here is why:-
- we can experiment on a same file but on different branches without affecting the original source code.
- multiple developers can work on same file on different branches.
- we can represent new featurs, bug fixes, or new-release.
- if a code fails then we can simply remove the branch without touching `main` branch.


# What is HEAD in Git?
* `HEAD` is a pointer that tells you which commit your working directory is currently based on.
- HEAD points to the latest commit in the current branch

# What happens to your files when you switch branches?
* File Changes on Branch Switch
- **Tracked files**: Git replaces them with the versions from the target branch. If a file exists in both branches but with different content, it will be updated to match the new branch.
- **New files**: If the target branch has files that don’t exist in your current branch, Git will add them to your working directory.
- **Deleted files**: If the target branch doesn’t have files that exist in your current branch, Git will remove them from your working directory.
- **Untracked files**: These stay as they are. Git doesn’t touch files it isn’t tracking.
- **Staged changes**: If you have changes staged for commit, Git will prevent the branch switch unless you commit, stash, or discard them (to avoid conflicts).

# How is `git switch` different from `git checkout` ?
* <git switch> is used for switching branches so we can work on same file on different branches.
* <git checkout> is used to make a new branch and change branch in a single command <git checkout -b branch_name>

# What is the difference between `origin` and `upstream`?
* <ORIGIN> :- The name automatically given to the remote repository you cloned from.
Your personal copy of the repo (usually your fork on GitHub/GitLab).
* <UPSTREAM> :- A manually added remote pointing to the original source repository.
The main project repo you forked from, maintained by the original authors.

# What is the difference between git fetch and git pull?
* <GIT FETCH> 
- Updates remote-tracking branches only
- No changes to local files
- Safer; lets you review before merging
- Full control over when/how to merge
- Keeps history clean until you merge
- Code review, planning integration, safe syncing

* <GIT PULL>
- Updates remote-tracking branches and merges/rebases into your current branch
- Changes applied immediately to your working branch
- Less safe; can trigger merge conflicts right away
- Automates integration, less manual decision-making
- May add merge commits or rewrite history (if rebase)
- Fast updates, CI/CD pipelines, trusted environments

# What is the difference between clone and fork?
* <CLONE>
- Creates a local copy of a repository on your machine.
- lives	On your local computer.
- To work with the repo locally, contribute, or just explore.
- You can push changes only if you have write access to the original repo.
- Typically used when you’re part of the project team.

* <FORK>
- Creates a copy of someone else’s repository under your GitHub account.
- On GitHub (remote, under your account).
- To propose changes to someone else’s project, or to customize it independently.
- You own the fork, so you can freely push changes to it.
- Used when you’re outside the project team but want to contribute.

# When would you clone vs fork?

* <CLONE>
- You’re part of the team maintaining the repo.
- You just want a local copy to experiment, without needing GitHub hosting.
- Example: Cloning your own private repo to work offline.

* <FORK>
- You want to contribute to an open-source project but don’t have write access.
- You want to customize a project independently (your own version).
- Example: Forking tensorflow/tensorflow to add a feature, then submitting a pull request.
After forking, how do you keep your fork in sync with the original repo?

# After forking, how do you keep your fork in sync with the original repo?
* steps to sync on remote :-
1) Open fork on github
2) Go on to the default branch
3) Sync fork
4) Update branch

* steps to sync on local :- 
1) Check remotes:- `git remote -v`
2) Original repo as upstream:- `git remote add upstream` </URL>
3) Fetching changes from the original repo:- `git fetch upstream`
4) Switch to other branch:- `git switch` </branch_name>
5) Sync branch:- `git merge upstream`
6) Push the updated branch to fork on github:- `git push orgin` </branch_name>

