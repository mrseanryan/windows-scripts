SETLOCAL

PUSHD "c:\sean\bb\windows-programming-tools"

SET _OUTPATH=%TEMP%\handle_out.txt

handle > %_OUTPATH%

start notepad %_OUTPATH%

POPD

PAUSE

