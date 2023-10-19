@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto nodev) else (goto dtd)
:nodev
@title Script Installer by PIRANY
set "foldername=DataSpammerbyPIRANY"
set "gitver12=v2"
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
if exist "settings.txt" (
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
If %insdone123% == 6 goto adddevtool
goto instdoneconf

:adddevtool
(
echo :topp
echo cd %%~dp0
echo @echo off
echo @title DevTool
echo if not exist dataspammer.bat goto errornofile
echo :dataspammerdevtool
echo echo [1] Echo On Debug
echo echo [2] DevConsole Input
echo set /P dataspammerdevtoolvar=Choose an Answer from Above
echo if %%dataspammerdevtoolvar%% == 1 goto echoondebug
echo if %%dataspammerdevtoolvar%% == 2 goto devconsoleinput
echo goto dataspammerdevtool
echo :devconsoleinput
echo set /P devconsoleinputvar=For which File:
echo set "devtools=1"
echo %%devconsoleinputvar%%
echo :echoondebug
echo set /P echoondebugvar=For Which File:
echo set "debug_assist=1"
echo %%echoondebugvar%%
echo :errornofile
echo echo For the Script to work efficiently it has to be in the same Directory.
echo @ping -n 1 localhost> nul
echo echo Please move the Script.
echo @ping -n 1 localhost> nul
echo pause
echo exit
) > devtool.bat
echo Die Telemedialen Freunde Beglueckwuenschen Dich!
pause
exit

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
goto delscriptconf


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
@ping -n 1 localhost> nul
echo 5/10 Files deleted
@ping -n 1 localhost> nul
echo 6/10 Files deleted
del settings.txt
@ping -n 1 localhost> nul
echo 7/10 Files deleted
del dataspammer.bat
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
echo This Installer will lead you throuh the Process of Installing the DataSpammer.
@ping -n 1 localhost> nul
echo [1] Install in Custom Directory (For Experienced Users)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Install In the Default Programm Directory
echo. 
@ping -n 1 localhost> nul
echo.
echo.
@ping -n 1 localhost> nul
set /P programdrccustom=Choose an Option from Above:
if %programdrccustom% == 1 goto customdirectory
if %programdrccustom% == 2 goto stdprogdrc
goto instmain

:stdprogdrc
set "directory=%CommonProgramFiles%"
set "n1=1"
set "n2=2"
set "n3=3"
echo The Script will install itself in the Following Directory: %CommonProgramFiles%
echo For Better Accessibility of the Script you can create for example a Startmenu Shortcut or a Desktop Shortcut
echo Please note that you need to reinstall those if you move the Script into another Folder.
echo Please Choose the Options you want to install:
echo.
echo [%n1%] Startmenu Shortcut
echo. 
echo [%n2%] Desktop Shortcut
echo. 
echo [%n3%] Start with Windows
echo.
echo [4] Done/Skip
set /P stdprogdrcvar=Choose the Options from Above
if %stdprogdrcvar% == 1 goto n1varinst
if %stdprogdrcvar% == 2 goto n2varinst
if %stdprogdrcvar% == 3 goto n3varinst
if %stdprogdrcvar% == 4 goto gitins

:n1varinst
set "n1=?"
set "startmenshortcut=1"
:n2varinst
set "n2=?"
set "desktopic=1"
:n3varinst
set "n3=?"
set "autostart=1"

:customdirectory
@ping -n 1 localhost> nul
echo Please specify the Directory where the Script should be installed.
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
goto instmain

:gitins
echo.
@ping -n 1 localhost> nul
echo When you want the script to auto upgrade itself when you start it you can install Git, JQ , Jid and Scoop automaticly too.
echo This will be fully automaticly.
echo When you choose to Install Git too it needs Administrator privileges too.
echo.
@ping -n 1 localhost> nul
echo [1] Install those Too
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
xcopy "%~dp0\dataspammer.bat" "%directory%\%foldername%\%gitver12%%" 
xcopy "%~dp0\startupcheck.bat" "%directory%\%foldername%\%gitver12%%"   
xcopy "%~dp0\install.bat" "%directory%\%foldername%\%gitver12%%"   
xcopy "%~dp0\start.bat" "%directory%\%foldername%\%gitver12%%"   
cd %directory%\%foldername%\%gitver12%
setlocal enabledelayedexpansion
set "insdonevar=insdone"
set "stdfil=n.a"
set "stdrcch=n.a"
set "file=settings.txt"
echo !insdonevar! >> %file%
echo !stdfil! >> %file%
echo !stdrcch! >> %file%
echo Settings.txt was created.

cd %~dp0
del dataspammer.bat
del start.bat
del startupcheck.bat
cd %directory%\%foldername%\%gitver12%
goto insdone

:insdone
if %errorlevel% equ 0 (
    echo Success.
    cls
    goto jqgitins
) else (
    echo There was an Error.
    echo Please Restart the Script.
    pause
    goto cancel
)

:jqgitins
if defined gitinsyn (
    goto jqgitins1
) else (
    goto direcdone
)

:jqgitins1
for /f "delims=" %%a in ('where git') do (
    set "where_output=%%a"
)
if defined where_output (
    echo Git is already installed!
) else (
    winget install --id Git.Git -e --source winget
)

for /f "delims=" %%a in ('where scoop') do (
    set "where_output=%%a"
)
if defined where_output (
    echo Scoop is already installed!
) else (
    PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
    PowerShell -Command "iex (irm https://get.scoop.sh)"
)

for /f "delims=" %%a in ('where jq') do (
    set "where_output=%%a"
)
if defined where_output (
    echo jq is already installed!
) else (
    scoop install jq
)

for /f "delims=" %%a in ('where jid') do (
    set "where_output=%%a"
)
if defined where_output (
    echo jid is already installed!
) else (
    scoop install jid
)

:addupdcheck
cd %directory%\%foldername%\%gitver12%
set "line1=insdone"
set "line2=notused"
set "line3=notused"
set "line4=uy"
set "setfile=settings.txt"
if exist !setfile! (
    del !setfile!
)
(
    echo !line1!
    echo !line2!
    echo !line3!
    echo !line4!
) > !setfile!
goto direcdone
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem -----------------------------------------------------------------------------------------------------------
rem stdprogdrc
:direcdone
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
goto direcdone

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
echo If you want to start the Script please only open start.bat not the dataspammer.bat directly.
cd %~dp0
del install.bat

@ping -n 3 localhost> nul
exit
:cancel
echo The installer is now closing....
pause  
exit
:dtd
set /p dtd1=.:.
%dtd1%
