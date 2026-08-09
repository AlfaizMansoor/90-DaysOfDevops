# NOTES

## What is the difference between <git add> and <git commit>?
* `git add` is used to make a untraceable file into traceable file.
usage :- <git add file-name>
* `git commit` is used to stores the traceable to make history.
usage :- <git commit -m file-name>

## What does the staging area do? Why doesn't Git just commit directly?
* everything in repo is not for commit, user wants to commit a few files in a bunch of files so user staged that choose the files he wants to commit and then commit, commiting directly makes commit the unwanted files which user doesn't want to commit. 

## What information does git log show you?
* <git log> shows the commit history
- it includes:-
<commit hash
user name and email
date and time of commit
commit message>

## What is the .git/ folder and what happens if you delete it?
* it stores the history of the repository in it, like:- commits, branches, configuration etc.
* if accidently i deletes .git folder then i'll loose my repo history.
- including:-
<branches, commits, tags, hash etc.>

## What is the difference between a working directory, staging area, and repository?
* working directory :- actual files on disk that i edit.
* staging area :- A snapshot of selected changes waiting to be committed.
* repository :- The permanent history stored in .git/.

