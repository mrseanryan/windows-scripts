@ECHO OFF
SETLOCAL

SET OUTPATH=..\JsBundlerDemo\Scripts\FibonaciBundle.*

powershell -f JsBundler.ps1 ..\JsBundlerDemo\Scripts\BAD_PATH.js.bundle ..\JsBundlerDemo
ECHO Errorlevel = %ERRORLEVEL%

echo ===

dir %OUTPATH%
