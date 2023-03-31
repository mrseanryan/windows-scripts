git config --global --unset alias.cfg
git config --global alias.cfg "config --list"

git config --global --unset alias.cfgo
git config --global alias.cfgo "config --list --show-origin"

git config --global --unset alias.co
git config --global alias.co checkout

git config --global --unset alias.br
git config --global alias.br branch

git config --global --unset alias.ci
git config --global alias.ci commit

git config --global --unset alias.st
git config --global alias.st status

REM unstages (index) but does not modify working directory - (it is without --HARD)
git config --global --unset alias.unstage
git config --global alias.unstage "reset HEAD --"

git config --global --unset alias.last
git config --global alias.last "log -1 HEAD"

git config --global --unset alias.pul
git config --global alias.pul "pull --rebase"

git config --global --unset alias.pus
git config --global alias.pus "push --force-with-lease"

git config --global --unset alias.lo
git config --global alias.lo "log --oneline --decorate --graph --all"

git config --global --unset alias.logs
git config --global alias.logs "log --decorate=short --format=oneline --abbrev-commit"

git config --global --unset alias.la
git config --global alias.la "config --get-regexp alias"

git config --global --unset alias.dc
git config --global alias.dc "diff --cached"

git config --global --unset alias.ap
git config --global alias.ap "add -p"
