@echo off 
@title Script Installer by PIRANY
set "foldername=ServerCrasherbyPIRANY"
cd %~dp0
color 2
cls  
color 2
:instdone100
rem New install poss
if exist "instdone.txt" (
    goto instdoneconf
) else (
    goto instmain
)

:instdoneconf
echo The Installer was already executed.
@ping -n 1 localhost> nul
echo You can either delete The Script from here or you can open the main script
@ping -n 1 localhost> nul
echo You can install the Script to antother Directory too.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Open the Main Script
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Open Settings
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Delete Script
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Reinstall Script
set /p insdone123=Choose an Option from above
    
If %insdone123% == 1 start.bat
If %insdone123% == 2 goto settingsmainscript
If %insdone123% == 3 goto delscriptconf
If %insdone123% == 4 goto instmain
:delscriptconf
echo. 
@ping -n 1 localhost> nul
echo You are about to delete the whole script.
@ping -n 1 localhost> nul 
echo Are you sure about this decision?
@ping -n 1 localhost> nul
echo If the script is bugged or you want to download the new Version please 
@ping -n 1 localhost> nul
echo Visit the GitHub Repo
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Yes, Delete the Whole Script
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Open the Github-Repo
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] No Please Go back
@ping -n 1 localhost> nul
echo.
echo.
set /p delscrconf=Choose an Option from Above

If %delscrconf% == 1 goto delscriptconfy
If %delscrconf% == 2 goto githubrepo190
If %delscrconf% == 3 goto instdone100

:githubrepo190
start "" "https://github.com/PIRANY1/DataSpammer"
goto instdoneconf

:settingsmainscript
set "settingsmainscriptvar=1"
start start.bat


:delscriptconfy
echo The Script is now Deleting itself....
@ping -n 1 localhost> nul
echo 1/10 Files deleted
del LICENSE
@ping -n 1 localhost> nul
echo 2/10 Files deleted
del README.md
@ping -n 1 localhost> nul
echo 3/10 Files deleted
del gitver.txt
@ping -n 1 localhost> nul
echo 4/10 Files deleted
del stdrcch.txt
@ping -n 1 localhost> nul
echo 5/10 Files deleted
del stdfil.txt
@ping -n 1 localhost> nul
echo 6/10 Files deleted
del instdone.txt
@ping -n 1 localhost> nul
echo 7/10 Files deleted
del servercrasher.bat
@ping -n 1 localhost> nul
echo 8/10 Files deleted
del start.bat
@ping -n 1 localhost> nul
echo 9/10 Files deleted
del startupcheck.bat
@ping -n 1 localhost> nul
echo 10/10 Files deleted
del install.bat
@ping -n 1 localhost> nul
echo The Script deleted itself successfully.
exit

:instmain
SETLOCAL EnableDelayedExpansion
SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
SETLOCAL DisableDelayedExpansion

%$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
%$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
%$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
%$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
%$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
%$Echo% "                             |_|                                              |___/                                     


echo.
@ping -n 1 localhost> nul
echo Please turn the CMD Windows to FullScreen. The Graphics will only be then displayed correctly.
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
If %ynins% == y goto gitins

:gitins
echo.
@ping -n 1 localhost> nul
echo When you want the script to auto upgrade itself when you start it you have to download the Git Programm too. 
echo When you choose to Install Git too it needs Administrator privileges too.
echo.
@ping -n 1 localhost> nul
echo [1] Install Git too
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] View Information about Git
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Dont install Git
echo.
@ping -n 1 localhost> nul
echo.
set /p menu3=Choose an Option from Above:
If %menu3% == 1 set "gitinsyn=1"
If %menu3% == 2 start "" "https://git-scm.com"
If %menu3% == 3 goto jqins1

:jqins1
echo.
@ping -n 1 localhost> nul
echo Do you have JQ installed?
@ping -n 1 localhost> nul
echo [1] Yes
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] No
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] I dont know
echo.
@ping -n 1 localhost> nul
echo.
set /p menu3=Choose an Option from Above:
If %menu3% == 1 set "jqins=1"
If %menu3% == 2 set "jqins=0"
If %menu3% == 3 set "jqins=0"

:insgo
mkdir "%directory%\%foldername%" 
xcopy "%~dp0\servercrasher.bat" "%directory%\%foldername%\"  
xcopy "%~dp0\startupcheck.bat" "%directory%\%foldername%\"  
xcopy "%~dp0\install.bat" "%directory%\%foldername%\"  
xcopy "%~dp0\start.bat" "%directory%\%foldername%\"  
cd %directory%\%foldername%\
echo. > "instdone.txt"
echo. > "stdfil.txt"
echo. > "stdrcch.txt"
echo. > "gitver.txt"

:insdone
if %errorlevel% equ 0 (
    echo Success.
    goto jqins3
) else (
    echo There was an Error.
    echo Please Restart the Script.
    pause
    goto cancel
)

:jqins3
setlocal
if "%jqins%"=="0" (
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
    PowerShell -Command "iex (irm https://get.scoop.sh)"
    goto gitins4
) else (
    goto gitins4
)
endlocal

:gitins4
setlocal
if "%gitinsyn%"=="1" (
    winget install --id Git.Git -e --source winget
) else (
    goto direcdone
)
endlocal

:direcdone
color 02
cls 
color 02
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
echo [5] Done/Skip
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
set "liscensefad1=%~dp0\README.md"

if exist "%liscensefad1%" (
    for /f "tokens=*" %%a in (%liscensefad1%) do (
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
echo Finishing Installation....
echo The Script will open itself now...
echo If you want to start the Script please only open start.bat not the servercrasher.bat directly.
(
  @echo off
  echo Dies ist die erste Batch-Datei.
  del "%~f0"
  start "Batch Runner" "start.bat"
) > "scoopinsttemp.bat"
scoopinsttemp.bat
@ping -n 3 localhost> nul
exit
:cancel
echo The installer is now closing....
pause  
exit