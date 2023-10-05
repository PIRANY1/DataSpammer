@echo off 
@title Script Installer by PIRANY
set "foldername=ServerCrasherbyPIRANY"
set "gitver12=v1.5"
cd %~dp0
color 2
cls  
color 2

:gitupdtcheck
if "%setupaftgitcl%"=="1" (
    goto updateinstall
) else (
    goto instdone100
)


:updateinstall
cd %~dp0
set "target_dir=%cd%""
set "source_dir=%source_dir_start%"
copy %source_dir%\instdone.txt %target_dir%
copy %source_dir%\stdfil.txt %target_dir%
copy %source_dir%\stdrcch.txt %target_dir%
cd %~dp0
echo Update was Successful
start.bat

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
echo When you want the script to auto upgrade itself when you start it you can install Git, JQ , Jid and Scoop automaticly too.
echo This will be fully automaticly.
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
echo [3] View Information about Jid
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] View Information about JQ
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [5] View Information about Scoop
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [6] Dont install those Components.
echo.
@ping -n 1 localhost> nul
echo.
set /p menu3=Choose an Option from Above:
If %menu3% == 1 set "gitinsyn=1"
If %menu3% == 2 start "" "https://git-scm.com" | goto gitins
If %menu3% == 3 start "" "https://github.com/simeji/jid" | goto gitins
If %menu3% == 4 start "" "https://jqlang.github.io/jq/" | goto gitins
If %menu3% == 5 start "" "https://scoop.sh/#/" | goto gitins
If %menu3% == 6 goto insgo

:insgo
mkdir "%directory%\%foldername%\%gitver12%%" 
xcopy "%~dp0\servercrasher.bat" "%directory%\%foldername%\%gitver12%%" 
xcopy "%~dp0\startupcheck.bat" "%directory%\%foldername%\%gitver12%%"   
xcopy "%~dp0\install.bat" "%directory%\%foldername%\%gitver12%%"   
xcopy "%~dp0\start.bat" "%directory%\%foldername%\%gitver12%%"   
cd %directory%\%foldername%\%gitver12%
echo. > "instdone.txt"
echo. > "stdfil.txt"
echo. > "stdrcch.txt"
cd %~dp0
del servercrasher.bat
del start.bat
del startupcheck.bat
cd %directory%\%foldername%\%gitver12%
goto insdone

:insdone
if %errorlevel% equ 0 (
    echo Success.
    goto jqgitins
) else (
    echo There was an Error.
    echo Please Restart the Script.
    pause
    goto cancel
)

:jqgitins
setlocal
if "%gitinsyn%"=="1" (
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
    PowerShell -Command "iex (irm https://get.scoop.sh)"
    scoop install jq
    scoop install jid
    winget install --id Git.Git -e --source winget
    goto direcdone 
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
If %ynins1% == 5 goto copyreadlic

:copyreadlic
xcopy "%~dp0\README.md" "%directory%\%foldername%\%gitver12%%"    
xcopy "%~dp0\LICENSE" "%directory%\%foldername%\%gitver12%%"     
del %~dp0\LICENSE
del %~dp0\README.md
goto instdone1

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
echo If you want to start the Script please only open start.bat not the servercrasher.bat directly.
cd %~dp0
del install.bat

@ping -n 3 localhost> nul
exit
:cancel
echo The installer is now closing....
pause  
exit
