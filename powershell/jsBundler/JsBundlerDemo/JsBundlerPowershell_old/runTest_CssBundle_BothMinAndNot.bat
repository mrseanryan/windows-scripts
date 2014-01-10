@ECHO OFF
SETLOCAL

SET OUTPATH=..\JsBundlerDemo\Styles

powershell -f JsBundler.ps1 ..\JsBundlerDemo\Styles\Styles.css.bundle ..\JsBundlerDemo -b
ECHO Errorlevel = %ERRORLEVEL%

echo ===
type %OUTPATH%\styles.css
echo ===
type %OUTPATH%\styles.min.css
echo ===

dir %OUTPATH%
