# git notes

## rebasing

https://git-scm.com/book/en/v2/Git-Branching-Rebasing

//get latest - rebase to 'merge' from remote master, and have a single history line (as opposed to 2 history lines with merge)
git rebase origin/master

(commit via VC)

//makes sure no one else made changes since?
git push --force-with-lease

## edit global config

git config --global --edit

## stashing (like TFS shelvesets)

//to shelve local changes
git stash

//to continue work
git stash pop
```

git stash list
git stash show
git stash clear

### to pop a particular stash

git stash list

git stash pop stash@{nnn}

### using git stash to perform multiple commits

# ... hack hack hack ...
$ git add --patch foo            # add just first part to the index
$ git stash save --keep-index    # save all other changes to the stash
$ edit/build/test first part
$ git commit -m 'First part'     # commit fully tested change
$ git stash pop                  # prepare to work on all other changes
# ... repeat above five steps until one commit remains ...
$ edit/build/test remaining parts
$ git commit foo -m 'Remaining parts'

## git diff

//only shows *unstaged* changes!
git diff

//only shows *staged* changes (what would be committed...)
git diff --staged

## git remove

//remove from git, AND from disk
git rm README.txt

//remove from git, but NOT remove from disk
git rm --cached README.txt

## git log

//last 10 commits:
git log  --pretty=short --stat -10

//last 2 commits - also show the changes (-p):
git log  --pretty=short --stat -2 -p

//today (when fetched?)
git log  --pretty=short --stat --since=12.hours

//find a change in code!
git log -S function_name

//find a word in commit message
git log --grep wordInCommitMessage

//omit merge commits
--no-merges

//limit log to a path
-- path/to/file

// Log as one line
git log --graph --oneline

// Log as lines but sorted by date (like gitlab 'Commits' tab does)
git log --date-order --graph --oneline

## branches

### show local branches

git branch

### show branches on remote

git remote show origin

### getting a remote branch

//create a tracking branch:
//Tracking branches are local branches that have a direct relationship to a remote branch
$ git checkout -b {branch-name} origin/{branch-name}
Branch {branch-name} set up to track remote branch {branch-name} from origin.
Switched to a new branch '{branch-name}'

//shortcut (if just 1 remote and local branch does not exist)
git checkout {branch-name}

### switch back to previous branch

git checkout -

### create a branch

git checkout -b mfe/{name-of-branch-ME-nnn}

#### push NEW branch to origin

git push --set-upstream origin mfe/{name-of-branch-ME-nnn}

### CMDs run to update and push a branch:

//this updates from trunk (master)
git fetch && git rebase origin/master
- note: a pull will undo the rebase, unless you first push

//this pushes - and makes sure no one else made changes since (on this branch)
git push --force-with-lease

//update from a different branch (other than master)
git fetch && git rebase origin/mfe/branch-name

//this pulls remote changes on this branch
git pull

//this pulls remote changes on this branch, and handles if someone else did a rebase against master, on this branch
git pull --rebase

### delete a branch

//fails if the branch has not yet been merged
git branch -d my-branch

//deletes local, even if the branch has not yet been merged
git branch -D my-branch

//delete a REMOTE branch (not just the tracking branch)
git push origin --delete my-branch

## git URLs

git remote -v

## tags

git tag

git tag -a v1.2 -m "my tag details" 9fceb02

also push tags to remote:

git push origin --tags

## clearing files not in git

  Windows: *admin* console

  git clean -dfx

## undo...

## removing a commit from history (!)

git rebase -i {commit id/hash}

- text editor opens with list of commits
- change 'pick' to be 'drop' for that commit
- save + close editor
- check the log:
  git log
- push:
  git push --force-with-lease

## recover a commit that was removed from history

git reflog
git cherry-pick {commit-hash}

git push

## staging/unstaging chunks (like in sourcetree)

// add chunks like sourcetree
git add -p

// remove chunks like sourcetree
git co -p

### reset - if you are in a mess:

// problem: rebasing results in merge conflicts in other's commits
// solution:
rebase -i xxx // then can delete the extra commits

// also works against other branch, where old commits are hanging around in this branch:
rebase -i myBranchName // then can delete the extra commits

//this resets the pointer to match remote
// *hard*: !!!undoes local commits + updates working dir!!!
git reset --hard origin/{branch name}

https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified#_git_reset

https://git-scm.com/docs/git-rebase

reset vs checkout:
- reset moves the branch that HEAD points to
	- checkout moves HEAD itself
- reset HARD can lose working directory changes
	- checkout HARD will keep working directory changes
	- BUT checkout with path will NOT keep working directory changes

### deleting branches

#### deleting branches - LOCAL

```
git branch -d <branch_name>
```

If there are unmerged changes which you are confident of deleting:

```
git branch -D <branch_name>
```

#### deleting branches - REMOTE

```
git push origin --delete <branch_name>
```

# webmodeler readme:

https://gitlab.srv.hq.mendix.net/webmodeler/webmodeler/tree/master

stashes! (like TFS shelvesets)
https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning

https://git-scm.com/docs/git-stash

# splitting a commit

git rebase -i xxx

Mark the commit you want to split with the action "edit" (e).

git reset HEAD~

// now commit your changes as normal

// when finished:
get rebase --continue

### tracking down a bug (binary search)

ref: https://git-scm.com/docs/git-bisect

git bisect start
git bisect bad
git co HEAD~10
git bisect good
// test for the bug, repeat until good again:
git bisect <good|bad>

	Keep repeating the process: compile the tree, test it, and depending on whether it is good or bad run git bisect good or git bisect bad to ask for the next commit that needs testing.

	Eventually there will be no more revisions left to inspect, and the command will print out a description of the first bad commit. The reference refs/bisect/bad will be left pointing at that commit.

// end - clean up:
git bisect reset

### making a script executable on Linux

git update-index --chmod=+x build.sh

### viewing diffs

git diff

#### viewing *staged* diffs

git diff --cached

# switching the origin of a repo (for example after cloning, instead of forking)
git remote rm origin
git remote add origin git@github.com:aplikacjainfo/proj1.git
git config master.remote origin
git config master.merge refs/heads/master

