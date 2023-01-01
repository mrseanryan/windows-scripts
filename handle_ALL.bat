SETLOCAL

SET _OUTPATH=%TEMP%\handle_out.txt

handle.exe > %_OUTPATH%

start notepad %_OUTPATH%

POPD

PAUSE

