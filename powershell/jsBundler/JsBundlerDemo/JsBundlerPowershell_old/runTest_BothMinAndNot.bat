@ECHO OFF
SETLOCAL

SET OUTPATH=..\JsBundlerDemo\Scripts\FibonaciBundle.*

powershell -f JsBundler.ps1 ..\JsBundlerDemo\Scripts\FibonaciBundle.js.bundle ..\JsBundlerDemo -b
ECHO Errorlevel = %ERRORLEVEL%

echo ===
type ..\JsBundlerDemo\Scripts\FibonaciBundle.js
echo ===
type ..\JsBundlerDemo\Scripts\FibonaciBundle.min.js
echo ===

dir %OUTPATH%
