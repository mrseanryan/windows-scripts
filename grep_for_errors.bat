@ECHO OFF
IF "%1" EQU "" (GOTO _ERROR)

REM note: the space separates multiple words to match by OR (not AND)
REM note: -i is to Ignore case
type %1 | findstr -i "error warning"

GOTO _OK
:_ERROR
@ECHO grepping - error occured! - USAGE: grep_for_errors {log file}
_GREP_ERROR_

:_OK
