@echo off
@title Script Installer by PIRANY
set "foldername=ServerCrasherbyPIRANY"
cd %~dp0
color 2
cls

rem if exist installdone für installer bearbeiten
setlocal
if exist "instdone.txt" (
    echo The Installer was already executed.
    echo Press a Key to open the Main Script.
    pause 
    start.bat
) else (
    goto instmain
)

endlocal

:instmain
SETLOCAL EnableDelayedExpansion
SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
SETLOCAL DisableDelayedExpansion

%$Echo% "    _____                           _____               _                 __  __           _        _             _____ _____ _____            _   ___     __
%$Echo% "   / ____|                         / ____|             | |               |  \/  |         | |      | |           |  __ \_   _|  __ \     /\   | \ | \ \   / /
%$Echo% "  | (___   ___ _ ____   _____ _ __| |     _ __ __ _ ___| |__   ___ _ __  | \  / | __ _  __| | ___  | |__  _   _  | |__) || | | |__) |   /  \  |  \| |\ \_/ / 
%$Echo% "   \___ \ / _ \ '__\ \ / / _ \ '__| |    | '__/ _` / __| '_ \ / _ \ '__| | |\/| |/ _` |/ _` |/ _ \ | '_ \| | | | |  ___/ | | |  _  /   / /\ \ | . ` | \   /  
%$Echo% "   ____) |  __/ |   \ V /  __/ |  | |____| | | (_| \__ \ | | |  __/ |    | |  | | (_| | (_| |  __/ | |_) | |_| | | |    _| |_| | \ \  / ____ \| |\  |  | |   
%$Echo% "  |_____/ \___|_|    \_/ \___|_|   \_____|_|  \__,_|___/_| |_|\___|_|    |_|  |_|\__,_|\__,_|\___| |_.__/ \__, | |_|   |_____|_|  \_\/_/    \_\_| \_|  |_|   
%$Echo% "                                                                                                           __/ |                                             
%$Echo% "                                                                                                          |___/   
%$Echo% " 

echo.
@ping -n 1 localhost> nul
echo Please turn the CMD Windows to FullScreen. Then the Graphics will be displayed correctly.
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
echo. > "instdone.txt"
echo. > "stdfil.txt"
echo. > "stdrcch.txt"
echo. > "gitver.txt"

:insdone
if %errorlevel% equ 0 (
    echo Success.
    goto gitins4
) else (
    echo There was an Error.
    echo Please Restart the Script.
    pause
    goto cancel
)

:jqins3
setlocal
if "%jqins%"=="1" (
    winget install jqlang.jq.
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
echo The Installer is now done!
@ping -n 1 localhost> nul
echo If you want to start the Script please only open start.bat not the servercrasher.bat directly.
goto cancel

:cancel
echo The installer is now closing....
pause  
exit