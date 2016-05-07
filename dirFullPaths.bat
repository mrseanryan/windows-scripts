@echo off

set yourDir="%1"

echo:List only files:
for %%a in ("%yourDir%\*") do echo %%~fa

echo:List only directories:
for /d %%a in ("%yourDir%\*") do echo %%~fa

echo:List directories and files in one command:
for /f "usebackq tokens=*" %%a in (`dir /b "%yourDir%\*"`) do echo %yourDir%\%%~a

pause
