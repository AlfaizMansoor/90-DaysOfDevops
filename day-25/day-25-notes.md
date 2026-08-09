# DAY-25

## Use git reset --soft to go back one commit — what happens to the changes?
* it removes commit but the file remains staged or tracked.

## Re-commit, then use git reset --mixed to go back one commit — what happens now?
* it removes the commit and detach the tracked file and makes it untracked or unstaged. but file remains

## Re-commit, then use git reset --hard to go back one commit — what happens this time?
* it removes the commit and untracked file, from the branch.

## What is the difference between --soft, --mixed, and --hard?
* `--soft`: undo the commit and keep the changes staged.
* `--mixed`: undo the commit and keep the changes in the working tree, but unstaged.
* `--hard`: undo the commit and discard the changes from both the staging area and working tree.

## Which one is destructive and why?
* `--hard` is destructive because it removes the commit and discards changes from the working tree and index, making them difficult or impossible to recover.

## When would you use each one?
* `--soft`: when you want to rewrite the last commit or keep the changes ready to commit again.
* `--mixed`: when you want to undo a commit but still keep the edits available for review or modification.
* `--hard`: when you want to throw away the commit and its changes completely and return to a clean state.

## Should you ever use git reset on commits that are already pushed?
* Generally no, because `git reset` rewrites history and can cause problems for others who already have the old commits.
* Use `git revert` instead for shared/public commits, or reset pushed commits only after coordinating with your team.

## is commit Y still in the history?
* yes commit Y is still visible

## How is git revert different from git reset?
* `git revert` creates a new commit that undoes a specific previous commit.
* `git reset` changes the branch pointer and can remove commits from history.

## Why is revert considered safer than reset for shared branches?
* Revert preserves history and adds a corrective commit, so collaborators don't need to rewrite or force-pull.
* Reset rewrites history, which can break shared branches and requires coordination or forced pushes.

## When would you use revert vs reset?
* Use `git revert` for published/shared commits or when you want to undo changes safely without changing history.
* Use `git reset` for local cleanup of recent unpushed commits or when you want to rewrite your own branch before sharing.

## Comparison between reset and revert:

### git reset
- What it does                      :- Moves the branch pointer to a previous commit and can discard later commits from the current branch.
- Removes commit from history?      :- Yes, it can remove commits from the branch history.
- Safe for shared/pushed branches?  :- No, it is generally unsafe for shared or pushed branches because it rewrites history.
- When to use                       :- Use for local cleanup of recent unpushed commits or when rewriting your own branch before sharing.

### git revert
- What it does                      :- Creates a new commit that undoes the changes of a specific earlier commit.
- Removes commit from history?      :- No, the original commit remains in history.
- Safe for shared/pushed branches?  :- Yes, it is safe for shared/pushed branches because it preserves history.
- When to use                       :- Use for safely undoing public or shared commits without rewriting history.

## Branching strategy comparison

### GitFlow
- How it works: Uses long-lived `main` and `develop` branches, with feature branches off `develop`, release branches from `develop`, and hotfix branches from `main`.
- Diagram:
  - `main` <- release <- `develop` <- feature
  - `main` <- hotfix
- When/where it's used: Good for large teams and scheduled releases, especially when releases are versioned and require stabilization.
- Pros: Clear process, good separation of development and releases, supports hotfixes cleanly.
- Cons: Complex, slower, and more overhead for fast-moving or small teams.

### GitHub Flow
- How it works: Uses a single long-lived `main` branch; developers create short-lived feature branches, open pull requests, merge to `main`, and deploy from `main`.
- Diagram:
  - `main` <- feature-1
  - `main` <- feature-2
- When/where it's used: Best for web apps and startups that deploy continuously and want a simple workflow.
- Pros: Simple, fast, easy to follow, encourages continuous integration and deployment.
- Cons: Less structure for large releases; can be risky without strong CI/testing.

### Trunk-Based Development
- How it works: Developers commit frequently to a single `main` or `trunk`, using very short-lived branches or direct commits with feature flags.
- Diagram:
  - `main` <- short-lived branch -> merge back quickly
- When/where it's used: Ideal for very fast-moving teams, continuous delivery, and organizations with strong automation and testing.
- Pros: Fast feedback, minimal branching overhead, avoids long-lived divergence.
- Cons: Requires strong discipline, automated testing, and can be risky if change control is weak.

### Answers
- Which strategy would you use for a startup shipping fast?
  - GitHub Flow or Trunk-Based Development, because both minimize overhead and support rapid delivery.
- Which strategy would you use for a large team with scheduled releases?
  - GitFlow, because it provides a clear release and hotfix structure for larger teams with planned release cycles.
- Which one does your favorite open-source project use?
  - Many popular GitHub open-source projects use GitHub Flow or a simplified branch model. For example, the React repository uses a main branch with short-lived feature branches and pull requests, which matches GitHub Flow.
