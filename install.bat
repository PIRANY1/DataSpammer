@echo off
@title Script Installer by PIRANY
set "foldername=ServerCrasherbyPIRANY"
cd %~dp0
color 2
cls

rem if exist installdone für installer bearbeiten


echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo This Installer will lead you throuh the Process of Installing the Servercrasher.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo First you need to specify the Directory where the Script should be installed.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo It can be any Directory as long as you have write/read access to it.
@ping -n 1 localhost> nul
set /p directory=Type Your Directory Here:
@ping -n 1 localhost> nul
echo Are you sure you want to run the installer and move the Files into the specified Directory?
@ping -n 1 localhost> nul
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
cls 
echo Dow you want to delete the LICENSE and README files?
@ping -n 1 localhost> nul
echo Those are not needed for the script to work.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] List content of README
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] List content of LICENSE
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Delete LICENSE
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Delete README
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [5] Skip this
echo.
@ping -n 1 localhost> nul
echo.
set /p ynins1=Select an Answer from above
If %ynins1% == 1 goto listlicense
If %ynins1% == 2 goto listreadme
If %ynins1% == 3 goto dellisence
If %ynins1% == 4 goto delreadme
If %ynins1% == 5 goto instdone1

:listlicense
set "liscensefad=%~dp0\LICENSE"

if exist "%liscensefad%" (
    for /f "tokens=*" %%a in (%liscensefad%) do (
        echo %%a
    )
) else (
    echo Error. Please open LICENSE manually.
)
pause
goto direcdone

:listreadme
set "liscensefad=%~dp0\README.md"

if exist "%liscensefad%" (
    for /f "tokens=*" %%a in (%liscensefad%) do (
        echo %%a
    )
) else (
    echo Error. Please open README manually.
)
pause
goto direcdone

:dellisence
if exist "%~dp0\LICENSE" (
    del "%~dp0\LICENSE"
) else (
    echo File wasnt found.
)
goto direcdone

:delreadme
if exist "%~dp0\README.md" (
    del "%~dp0\README.md"
) else (
    echo File wasnt found.
)
goto direcdone

:instdone1
echo The Installer is now done!
@ping -n 1 localhost> nul
echo The Servercrasher will now Open.
@ping -n 1 localhost> nul
pause 
cd %directory%\%foldername%
start.bat

:cancel
echo The installer is now closing....
pause  
exit