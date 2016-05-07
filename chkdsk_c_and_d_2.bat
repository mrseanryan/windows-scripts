REM Checking disks D and C.

REM Checking disk C will require a reboot.
chkdsk C: /R /V /X

chkdsk D: /R /V /X

echo rebooting ...
shutdown -r -t 60

PAUSE

