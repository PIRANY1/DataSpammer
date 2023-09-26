@echo off
@title Data Spammer
color 2

SETLOCAL EnableDelayedExpansion
SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
SETLOCAL DisableDelayedExpansion

:getvar
setlocal enabledelayedexpansion
set "stdrc1="
for /f "usebackq delims=" %%a in ("%~dp0\stdrcch.txt") do (
    set "zeile=%%a"
    set "stdrc1=!text!!zeile!"
)
endlocal
:getvar2
setlocal enabledelayedexpansion
set "stdfile="
for /f "usebackq delims=" %%a in ("%~dp0\stdfil.txt") do (
    set "zeile1=%%a"
    set "stdfile=!text!!zeile!"
)
endlocal



:menu
cls
%$Echo% "    _____                           _____               _                 __  __           _        _             _____ _____ _____            _   ___     __
%$Echo% "   / ____|                         / ____|             | |               |  \/  |         | |      | |           |  __ \_   _|  __ \     /\   | \ | \ \   / /
%$Echo% "  | (___   ___ _ ____   _____ _ __| |     _ __ __ _ ___| |__   ___ _ __  | \  / | __ _  __| | ___  | |__  _   _  | |__) || | | |__) |   /  \  |  \| |\ \_/ / 
%$Echo% "   \___ \ / _ \ '__\ \ / / _ \ '__| |    | '__/ _` / __| '_ \ / _ \ '__| | |\/| |/ _` |/ _` |/ _ \ | '_ \| | | | |  ___/ | | |  _  /   / /\ \ | . ` | \   /  
%$Echo% "   ____) |  __/ |   \ V /  __/ |  | |____| | | (_| \__ \ | | |  __/ |    | |  | | (_| | (_| |  __/ | |_) | |_| | | |    _| |_| | \ \  / ____ \| |\  |  | |   
%$Echo% "  |_____/ \___|_|    \_/ \___|_|   \_____|_|  \__,_|___/_| |_|\___|_|    |_|  |_|\__,_|\__,_|\___| |_.__/ \__, | |_|   |_____|_|  \_\/_/    \_\_| \_|  |_|   
%$Echo% "                                                                                                           __/ |                                             
%$Echo% "                                                                                                          |___/   

@ping -n 1 localhost> nul
echo Made by PIRANY (pirany on discord)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Info
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Start
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Cancel
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Credits/Contact
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [5] Settings
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [6] Autostart after Boot
echo.
echo.
set /p menu1=Choose an Option from Above:

If %menu1% == 1 goto info
If %menu1% == 2 goto start
If %menu1% == 3 goto cancel
If %menu1% == 4 goto credits
If %menu1% == 5 goto setting
If %menu1% == 6 goto autostart

:info
cls
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo No liability for any Damages on your Software.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo If you want to use this Script on a Server you have to be able to write something in the Folder you want to use.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Go back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Exit
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu2=Choose an Option from Above:
If %menu2% == 1 goto menu
If %menu2% == 2 goto cancel

:credits
cls 
echo.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo This Script is made by PIRANY for Educational Use only.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo If you found any Bugs/Glitches or have a Problem With this software please 
@ping -n 1 localhost> nul
echo Create a Issue on the Github-Repo
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Go back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Open the Github-Repo
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Exit
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu3=Choose an Option from Above:
If %menu3% == 1 goto menu
If %menu3% == 3 goto cancel
If %menu3% == 2 goto GitRepo

:GitRepo
cls 
echo Opening Github-Repo 
@ping -n 1 localhost> nul
echo 3
@ping -n 1 localhost> nul
@ping -n 1 localhost> nul
echo 2
@ping -n 1 localhost> nul
@ping -n 1 localhost> nul
echo 1
@ping -n 1 localhost> nul
@ping -n 1 localhost> nul
echo Opening...
start "" "https://github.com/PIRANY1/DataSpammer"
goto credits

:setting
cls 
echo ========
echo Settings
echo ========
echo.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Standart Filename (Will have a Number behind.)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Standard Directory to Crash(idk why you would need this but here you go)
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Go back
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul


set /p menu4=Choose an Option from Above:
If %menu4% == 1 goto filenamechange
If %menu4% == 2 goto stddirectorycrash
If %menu4% == 3 goto menu


:filenamechange
cls 
echo The Filename cant have the following Character(s):\ / : * ? " < > |"
set /p mainfilename=Type in the Filename you want to use.
setlocal enabledelayedexpansion
set "filestdname=%~dp0\stdfil.txt"
type nul > "%filestdname%"
echo !mainfilename! > "%filestdname%"
endlocal
echo The Standart Filename was saved!
cls
goto setting


:stddirectorycrash
cls 
echo.
echo.
set /p directory0=Type Your Directory Here:

cd %directory0%
if %ERRORLEVEL% neq 0 (
    echo There was an Error. Please check if the Directory is correct or retry later. 
) else (
    echo The Directory was Correct!
    goto varcheckdone
)

:varcheckdone
setlocal enabledelayedexpansion
set "stdvarset=%~dp0\stdrcch.txt"
type nul > "%stdvarset%"
echo !directory0! > "%stdvarset%"
endlocal
echo The Directory was saved!
cls
goto setting

:autostart
echo.
cls
echo.
echo ==================
echo Autostart Settings
echo ==================
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Setup 
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Delete Autostart
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Back
echo.
echo.
set /p menu0=Choose an Option from Above:

If %menu0% == 1 goto autostartsetup
If %menu0% == 2 goto autostartdelete
If %menu0% == 3 goto menu

:autostartsetup
echo This Setup will --------------------------------------------------------------------------------------------------------------------------------


:start
if defined stdrc1 (
    cd %stdrc1%
    goto nameset
) else (
    goto novarset
)

:novarset
cls
echo Please enter the Directory of the Folder/Server you want to Crash.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo You can find the Directory by Clicking on the Path in you Explorer (on top) and copy it in here. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo It should look something like this: C:\User\Dokuments\CrashFolder
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo You can use your User Directory if you are using a Server. This works in most Cases but it sometimes doesnt work. Why dont you try?
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Use User Directory
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [2] Enter a Directory
@ping -n 1 localhost> nul
set /p menu5=Choose an Option from Above:
If %menu5% == 1 goto userdrc
If %menu5% == 2 goto manualcd

:userdrc 
cd %userprofile%

:manualcd
echo.
echo.
set /p directory1=Type Your Directory Here:

cd %directory1%

if %ERRORLEVEL% neq 0 (
    echo There was an Error. Please check if the Directory is correct or retry later. 
) else (
    echo The Directory was Correct!
    goto nameset
)

:nameset
if defined stdfile (
    goto cddone
) else (
    goto nameset2
)

:nameset2
cls
echo Now You have to choose a filename. It can be anything as long as the 
echo Filename doesnt have the following Character(s):\ / : * ? " < > |"
set /p stdfile=Type in the Filename you want to use.
setlocal enabledelayedexpansion
goto timerask

:timerask
cls
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Do you want to set how many files should be created?
@ping -n 1 localhost> nul
echo If you choose No the script will run for eternity.
@ping -n 1 localhost> nul
set /p menu6=Yes[y]  No [n]:
If %menu6% == y goto timerset
If %menu6% == n goto cddone

:timerset 
cls
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo How many Files should be created?
set /p filecount=Type a Number:
goto cddone

:cddone
cls
echo. 
echo.
echo Please confirm.
pause
echo Loading...
@ping -n 2 localhost> nul
echo 5 Seconds left
@ping -n 2 localhost> nul
echo 4 Seconds left
@ping -n 2 localhost> nul
echo 3 Seconds left
@ping -n 2 localhost> nul
echo 2 Seconds left
@ping -n 2 localhost> nul
echo 1 Second left
@ping -n 2 localhost> nul
echo Starting......
echo If you want to stop this script simply close the Command Windows or press ALT F4
:top
set /a x+=1
type nul > %stdfile%%x%.txt
echo Created %x% File(s).
if %x% equ %filecount% (
    goto done
    cls
) else (
    goto top
    cls
)
cls

:done 
echo.
%$Echo% "    _____                           _____               _                 __  __           _        _             _____ _____ _____            _   ___     __
%$Echo% "   / ____|                         / ____|             | |               |  \/  |         | |      | |           |  __ \_   _|  __ \     /\   | \ | \ \   / /
%$Echo% "  | (___   ___ _ ____   _____ _ __| |     _ __ __ _ ___| |__   ___ _ __  | \  / | __ _  __| | ___  | |__  _   _  | |__) || | | |__) |   /  \  |  \| |\ \_/ / 
%$Echo% "   \___ \ / _ \ '__\ \ / / _ \ '__| |    | '__/ _` / __| '_ \ / _ \ '__| | |\/| |/ _` |/ _` |/ _ \ | '_ \| | | | |  ___/ | | |  _  /   / /\ \ | . ` | \   /  
%$Echo% "   ____) |  __/ |   \ V /  __/ |  | |____| | | (_| \__ \ | | |  __/ |    | |  | | (_| | (_| |  __/ | |_) | |_| | | |    _| |_| | \ \  / ____ \| |\  |  | |   
%$Echo% "  |_____/ \___|_|    \_/ \___|_|   \_____|_|  \__,_|___/_| |_|\___|_|    |_|  |_|\__,_|\__,_|\___| |_.__/ \__, | |_|   |_____|_|  \_\/_/    \_\_| \_|  |_|   
%$Echo% "                                                                                                           __/ |                                             

@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo The Script Created %filecount% Files.
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Do you want to Close the Script or Go to the Menu?
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Close
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Menu
echo.
@ping -n 1 localhost> nul
set /p menu9=Choose an Option from Above:
If %menu9% == 1 goto cancel
If %menu9% == 2 goto menu










:cancel 
exit
exit
