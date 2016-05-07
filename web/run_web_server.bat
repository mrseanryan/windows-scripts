IF "%1" EQU "" (GOTO _ERROR_USAGE)

pushd "%1"
http-server -o --cors -p 8081
IF "%ERRORLEVEL%" NEQ "0" (GOTO _ERROR)
GOTO _END

:_ERROR_USAGE
ECHO USAGE: run_web_server.bat [path to directory]

:_ERROR
ECHO error occurred!
_error_occurred

:_END
