@ECHO OFF
ECHO USAGE:  delDirWithLongName.bat {path to dir}

ECHO .

ECHO This will destroy the directory at '%1'
ECHO Press CTRL + C to cancel
PAUSE

SETLOCAL

SET DIR_TO_DELETE=%1
SET EMPTY_DIR=%TEMP%\empty_dir

IF "%DIR_TO_DELETE%" EQU "" (GOTO _ERROR_USAGE)

IF EXIST "%EMPTY_DIR%" (rmdir /q /s "%EMPTY_DIR%")

MKDIR "%EMPTY_DIR%"
ROBOCOPY "%EMPTY_DIR%" "%DIR_TO_DELETE%" /S /MIR
RMDIR /q /s "%EMPTY_DIR%"
RMDIR /q /s "%DIR_TO_DELETE%"

GOTO _END

:_ERROR_USAGE
ECHO Incorrect argumente!
GOTO _ERROR

:_ERROR
ECHO error occurred!
_error_occurred
REM not using exit as that can cause whole cmd session to exit

:_END
ECHO [done]
