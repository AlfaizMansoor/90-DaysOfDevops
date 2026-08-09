# DAY-24

## Observe the merge — did Git do a fast-forward merge or a merge commit?
* it creates a fast-forward commit because there is not any new feature commit, and branch pointer just moved forward it means it's a <fast-forward merge>

## Merge feature-signup into main — what happens this time?
* it merge feature-signup
Auto-merging demo-2-file.txt
CONFLICT (content): Merge conflict in demo-2-file.txt
Automatic merge failed; fix conflicts and then commit the result.

- a merge conflict appears because of different commits on different branches on same line.
- to resolve conflict :- open `demo-2-file.txt` and removes the conflict tage `======`, `<<<<<<`, `>>>>>>`

## What is a fast-forward merge?
* Fast-forward mergein Git  is a process where no new merge commit is created, but instead the pointer of the target branch is moved forward to the last commit of the feature branch.

## When does Git create a merge commit instead?
* Git creates a merge commit instead of doing a fast‑forward when the two branches have diverged 
- meaning both branches have new commits since they split.

## What is a merge conflict? (try creating one intentionally by editing the same line in both branches)
* A merge conflict happens when Git tries to combine two branches but finds that the same part of a file was changed differently in both branches. Since Git can’t decide which version to keep, it stops and asks you to resolve the conflict manually.


## how does the history look compared to a merge?
### git merge
* b890268 (HEAD -> main) version-10: updated 9th line
*   3c9d999 version-7: updated line
|\  
| * 7692225 (feature-signup) version-5: fifth line
| * 71a4aac version-4: fourth line
* | f27ba15 version-6: sixth line
|/  
* 22a18da (feature-login) version-3: Third line
* b7baa51 version-2: second line
* 233b683 version-1: first line

### git rebase
* b890268 (HEAD -> main) version-10: updated 9th line
| * 66415ef (feature-dashboard) version-9: updated 8th line
| * bfae0b2 version-8: updated 7th line
|/  
*   3c9d999 version-7: updated line
|\  
| * 7692225 (feature-signup) version-5: fifth line
| * 71a4aac version-4: fourth line
* | f27ba15 version-6: sixth line
|/  
* 22a18da (feature-login) version-3: Third line
* b7baa51 version-2: second line
* 233b683 version-1: first line

## What does rebase actually do to your commits?
* Rebase takes the commits from one branch and replays them on top of another branch. It creates new commits with new hashes, so the history looks cleaner and more linear.

## How is the history different from a merge?
* Merge keeps the branch structure and usually creates a merge commit.
* Rebase rewrites the branch history so it appears as if the work was done on top of the latest base branch, without a merge commit.

## Why should you never rebase commits that have been pushed and shared with others?
* You should never rebase commits that have already been pushed and shared because rebase changes commit IDs. Other people may already have those old commits in their history, so they can end up with duplicate or conflicting commits after you force-push.

## When would you use rebase vs merge?
* Use rebase when:
- you want a clean, linear history
- the branch is local or private
- you are polishing commits before merging

* Use merge when:
- the branch is already shared with others
- you want to preserve the actual branch history
- you want a clear record that a branch was merged

## compare the history

### merge 

`087a7d4` (HEAD -> main, feature-settings) version-16: updated 15th line
`ab6dc5f` version-15: updated 14th line
`0ea2262` Merge <feature-profile> into main (squashed)
`b890268` version-10: updated 9th line
`3c9d999` version-7: updated line
`f27ba15` version-6: sixth line
`7692225` (feature-signup) version-5: fifth line
`71a4aac` version-4: fourth line
`22a18da` (feature-login) version-3: Third line
`b7baa51` version-2: second line
`233b683` version-1: first line  

### merge --squash

`0ea2262` (HEAD -> main, feature-settings) Merge <feature-profile> into main (squashed)
`b890268` version-10: updated 9th line
`3c9d999` version-7: updated line
`f27ba15` version-6: sixth line
`7692225` (feature-signup) version-5: fifth line
`71a4aac` version-4: fourth line
`22a18da` (feature-login) version-3: Third line
`b7baa51` version-2: second line
`233b683` version-1: first line

- git merge all commits separately on the other hand git --squash merge all the commits in a single commit and make a new commit

## What does squash merging do?
* it merges commits of a branch in other branch and makes a single commit from mltiple commits.

## When would you use squash merge vs regular merge?
* Use squash merge when:
  - you want to keep the main branch history clean and linear
  - the feature branch has many small or experimental commits that are not worth preserving individually
  - you want one summarized commit for a completed feature
* Use regular merge when:
  - you want to preserve the full branch history and individual commits
  - the branch is shared with others or already reviewed as-is
  - you need the context of separate commits for debugging or auditing

## What is the trade-off of squashing?
* Squashing keeps history cleaner but loses the detailed record of each individual commit.
* You get a simpler main branch history, but you also lose per-commit context, author timestamps, and fine-grained changes.
* Use it when history readability matters more than preserving every incremental step. 

## What is the difference between git stash pop and git stash apply?

* `git stash apply` reapplies the selected stash but leaves it in the stash list.
* `git stash pop` reapplies the selected stash and then removes it from the stash list if it applies cleanly.
* Use `apply` when you want to keep the stash around in case you need it again or want to test it first.
* Use `pop` when you want to restore the changes and clean up the stash entry in one step.

## When would you use stash in a real-world workflow?
* When you need to switch branches but have unfinished work that you don't want to commit yet.
* When you want to test a quick fix on a different branch without losing your current changes.
* When you need to pull or merge updates cleanly and want to temporarily set aside local modifications.
* When you want to save work-in-progress changes and later resume them without cluttering the commit history.


## What does cherry-pick do?
* `git cherry-pick <commit>` takes the changes introduced by a specific commit from another branch and applies them onto your current branch.
* It creates a new commit in the current branch with the same changes, but a new commit hash.

## When would you use cherry-pick in a real project?
* When you need a single bug fix or small feature from another branch without merging the entire branch.
* When you want to backport a fix from `main` to a release branch.
* When you need to apply a specific commit to multiple branches independently.

## What can go wrong with cherry-picking?
* Conflicts can occur if the commit touches files that differ in the target branch.
* The same change can be duplicated in history if the source branch is later merged, causing extra commits.
* Cherry-picking can make history harder to follow if used too often instead of merging or rebasing.
