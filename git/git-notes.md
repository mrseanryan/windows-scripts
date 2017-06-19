# git notes

```
//get latest
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

## CMDs run to update and push a branch:

//this updates from trunk (master)
git fetch && git rebase origin/master

//this pulls remote changes on this branch
git pull

//this pulls remote changes on this branch, and handles if someone else did a rebase against master, on this branch
git pull --rebase

//this pushes - and makes sure no one else made changes since (on this branch)
git push --force-with-lease

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

## show branches on remote

git remote show origin

## git URLs

git remote -v

## tags

git tag

git tag -a v1.2 -m "my tag details" 9fceb02

also push tags to remote:

git push origin --tags

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

### if you are in a mess:

//this resets the pointer to match remote
git reset --hard origin/{branch name}

# ref:

https://gitlab.srv.hq.mendix.net/webmodeler/webmodeler/tree/master

stashes! (like TFS shelvesets)
https://git-scm.com/book/en/v2/Git-Tools-Stashing-and-Cleaning

https://git-scm.com/docs/git-stash


