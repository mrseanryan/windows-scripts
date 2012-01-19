REM TEST script that closes any duplicate Exploder windows:
REM works on the titles

SETLOCAL

SET PATH_TO_AU3_DIR=c:\Program Files (x86)\AutoIt3

REM GOTO _SKIP_WIN_OPEN

explorer %USERPROFILE%\Music
explorer %USERPROFILE%\Music
explorer %USERPROFILE%\Music

pause

:_SKIP_WIN_OPEN

"%PATH_TO_AU3_DIR%\AutoIt3.exe" closeWindows.au3

pause
