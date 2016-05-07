@ECHO OFF
SETLOCAL

SET TAG_NAME=%1

IF "%TAG_NAME%" EQU "" (GOTO _ERROR_USAGE)

ECHO !!! NOT WORKING !!!
GOTO _ERROR_USAGE

git tag -a %TAG_NAME%
git push origin %TAG_NAME%

GOTO _END

:_ERROR_USAGE
ECHO USAGE: gitTag.bat {tag-name}
ECHO The tag name must NOT have spaces!

ECHO .
ECHO example tag:
ECHO ava-{branch}-{tag name}-{date}
ECHO .
ECHO date format: yyyymmdd

:_END
