REM Checking disks C and E.

REM Checking disk C will require a reboot.
chkdsk C: /R /V /X

chkdsk E: /R /V /X

echo rebooting ...
shutdown -r -t 60

PAUSE

