@ECHO OFF
SETLOCAL

SET OUTPATH=..\JsBundlerDemo\Styles

powershell -f JsBundler.ps1 ..\JsBundlerDemo\Styles\Styles.css.bundle ..\JsBundlerDemo
ECHO Errorlevel = %ERRORLEVEL%

echo ===

dir %OUTPATH%
