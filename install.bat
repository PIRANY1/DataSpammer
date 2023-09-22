@echo off
@title Script Installer by PIRANY
set "foldername=ServerCrasherbyPIRANY"
cd %~dp0
color 2
cls

rem if exist installdone für installer bearbeiten


echo.
echo.
echo This Installer will lead you throuh the Process of Installing the Servercrasher.
echo.
echo.
echo First you need to specify the Directory where the Script should be installed.
echo.
echo It can be any Directory as long as you have write/read access to it.
set /p directory=Type Your Directory Here:
echo Are you sure you want to run the installer and move the Files into the specified Directory?
set /p ynins=[y]Yes [n]No:
If %ynins% == n goto cancel
If %ynins% == y goto insgo


:insgo
mkdir "%directory%\%foldername%" 
xcopy "%~dp0\servercrasher.bat" "%directory%\%foldername%"  
xcopy "%~dp0\startupcheck.bat" "%directory%\%foldername%"  
xcopy "%~dp0\install.bat" "%directory%\%foldername%"  
xcopy "%~dp0\start.bat" "%directory%\%foldername%"  
echo. > "instdone.txt"
echo. > "stdfil.txt"
echo. > "stdrcch.txt"

if %errorlevel% equ 0 (
    echo Success.
    goto direcdone
) else (
    echo There was an Error.
    pause
    goto cancel
)

:direcdone
echo.
echo The Installer is now done!
echo The Servercrasher will now Open.
pause 
cd %directory%\%foldername%
start.bat

:cancel
echo The installer is now closing....
pause  
exit