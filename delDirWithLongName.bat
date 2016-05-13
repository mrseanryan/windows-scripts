@ECHO OFF
ECHO This script will destroy the directory at %1
ECHO Press CTRL + C to cancel
PAUSE

ECHO Deleting %1 ...
SETLOCAL

SET DIR_TO_DELETE=%1
SET EMPTY_DIR=%TEMP%\empty_dir

IF "%DIR_TO_DELETE%" EQU "" (GOTO _ERROR_USAGE)

IF EXIST "%EMPTY_DIR%" (rmdir /q /s "%EMPTY_DIR%")

MKDIR "%EMPTY_DIR%"
SET _VERBOSITY=/NFL /NJH /NJS /NDL /NC /NS
REM >nul (stdout is not echoed)
ROBOCOPY "%EMPTY_DIR%" "%DIR_TO_DELETE%" /S /MIR %_VERBOSITY% >nul
RMDIR /q /s "%EMPTY_DIR%"
RMDIR /q /s "%DIR_TO_DELETE%"

ECHO Deleting %1 [done]
GOTO _END

:_ERROR_USAGE
ECHO Incorrect arguments!
ECHO .
ECHO USAGE:  _delDirWithLongName.bat {path to dir}
GOTO _ERROR

:_ERROR
ECHO error occurred!
_error_occurred
REM not using exit as that can cause whole cmd session to exit

:_END
