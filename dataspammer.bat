:: Use only under MIT License
:: If you want to Publish a modified Version please mention the Original Creator PIRANY and link the GitHub Repo
:: Some Vars and Settings
::    Todo:
::    Create Custom Batch for USB Stick,   
::    Fix Remotespam via scp/ftp/ssh,    
::    Improve Language,    
::    Remove Weird Call Signs,
::    Add Portable Installation, 
::    Add Startup Arg (e.g. dataspammer.bat -r)
::    Rework Developer Options
::    Remove CD test for spaces in directory names
::    Fix Small Install Install Check 
::    Try to Add a Interaktive CLI Interface, which can be dynamicly called and used by other Scripts. 
::    Add API



@echo off
chcp 65001
set "current-script-version=v2.7"
if "%1"=="h" goto help
if "%1"=="-h" goto help
if "%1"=="help" goto help
if "%1"=="-help" goto help
if "%1"=="--help" goto help
if "%1"=="faststart" goto menu
if "%1"=="update" goto fastgitupdate
if "%1"=="remove" goto remove-script
if "%1"=="start" goto quickstart
if "%1"=="" goto normal-start
if "%1"=="api" goto api-call
if "%1"=="api" goto cli

:normal-start
@color 02
set "large=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto top-startup) else (goto dtd)
setlocal enableextensions ENABLEDELAYEDEXPANSION 
net session >nul 2>&1
:: Fix Directory if started with Elevated Priviliges
if %errorLevel% == 0 (cd %~dp0) else (goto top-startup)


:top-startup
::Check if the Script is on a small install
set inputFile=settings.txt
set "firstLine="
set /p firstLine=<%inputFile%
if "%firstLine%"=="small-install" (
    set "small-install=1" && goto enableascii
) else (
    goto regular-install
)

    :regular-install
    :: Check if Jq and Git are installed
    for /f "delims=" %%a in ('where jq') do (
        set "where_output=%%a"
    )
    if defined where_output (
        set "jq-installed=1" && goto check-git
    ) else (
        set "jq-installed=0" && goto check-git
    )
    
    :check-git
    for /f "delims=" %%a in ('where git') do (
        set "where_output=%%a"
    )
    if defined where_output (
        set "git-installed=1" && goto check-files
    ) else (
        set "git-installed=0" && goto check-files
    )

    :check-files
    :: Checks if all Files needed for the Script exist
    setlocal enabledelayedexpansion
    @title Starting Up...
    echo Checking for Data...
    if not exist "settings.txt" goto Error1
    echo Checking for Files...
    if not exist "install.bat" (goto Error) else (goto updtsearch)

:error1
    :: TLI when Settings arent found
    cls
    echo The File "settings.txt" doesnt exist. 
    @ping -n 1 localhost> nul
    echo Theres a high Chance that the Installer didnt run yet.
    @ping -n 1 localhost> nul
    echo Please consider rerunning the installer to make sure the script can run accurately.
    @ping -n 1 localhost> nul
    echo Do you want to reinstall the Script or do you want to open the Script anyways?
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Open the Installer
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Open the Script anyways 
    @ping -n 1 localhost> nul
    set /p menu=Choose an Option from Above:
    If %menu% == 1 goto openins
    If %menu% == 2 goto no-settings
    goto error1

    :no-settings
    :: Check if the Updater can run
    if jq-installed == 1 (
        if git-installed == 1 goto updtsearch
    ) else (
        goto ulttop
    )



:updtsearch
    :: Check if Script should check for Updates
    setlocal enabledelayedexpansion
    set "file=settings.txt"
    set "linenr=4"
    set "searchfor=uy"

    for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%batchfile%"') do (
        if %%a equ %linenr% (
            set "line=%%b"
            set "line=!line:*:=!"
            if "!line!" equ "%searchtext%" (
                goto gitvercheck
            ) else (
                goto ulttop
            )
        )
    )

:gitvercheck
    :: Check if an Updates Is Avaiable
    set "owner=PIRANY1"
    set "repo=DataSpammer"
    set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
    echo Getting Latest Release Info from API...
    cls
    echo Got Release Info ?
    echo Awaiting Response...
    @ping -n 1 localhost> nul
    cls
    echo Got Release Info ?
    echo Recieved API Response ?
    echo Extracting Data...
    for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
    echo Extracted Data ?
    if %latest_version% equ v2.7 (goto UpToDate) else (goto gitverout)

:UpToDate
    :: Message when the Script is up-to-date
    @ping -n 1 localhost> nul
    echo The Version you are currently Using is the newest one (%latest_version%)
    goto ulttop


:gitverout
    :: TLI when the Script is Outdated
    echo.
    @ping -n 1 localhost> nul
    echo Version Outdated!
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo Please consider downloading the new Version. 
    @ping -n 1 localhost> nul
    echo The Version you are currently using is %current-script-version%
    @ping -n 1 localhost> nul 
    echo The newest Version avaiable is %latest_version%
    @ping -n 1 localhost> nul
    echo.
    echo [1] Update
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Continue Anyways
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    set /p menu4=Choose an Option from Above:
    If %menu4% == 1 goto gitupt
    If %menu4% == 2 goto ulttop
    goto gitverout

:gitupt
    :: Unstable Ahhh Update Script
    set gitverold=%current-script-version%
    cd %~dp0
    set "old-script-location=%cd%"
    cd ..
    mkdir %latest_version%
    cd %latest_version%
    echo Downloading Version %latest_version% ...
    git clone https://github.com/PIRANY1/DataSpammer.git
    cls 
    echo Downloaded Version %latest_version%
    @ping -n 1 localhost> nul
    set "update-install=1"
    cd %latest_version%
    cmd .\install.bat


:Error 
    :: TLI When the Installer doesnt exist
    echo The "Install.bat" doesnt exist. The Script has a Chance of not working
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Open GitHub for Versions.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Continue Anyways
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    set /p menu3=Choose an Option from Above:
    If %menu3% == 2 goto ulttop
    If %menu3% == 1 goto gitopen
    goto Error

:gitopen
    :: Open Repo
    start "" "https://github.com/PIRANY1/DataSpammer"
    goto Error

:openins
    :: Opens the Installer
    cd %~dp0
    install.bat
    if %errorlevel% equ 0 (cls | echo Installer is running....) else (echo There was an Error. Please open the install.bat File manually.)

:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: -------------------------------------------------Start.bat  <- Transition -> DataSpammer.bat------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:ulttop
    :: If the Script got opened from installer?
    if "%settingsmainscriptvar%" == "1" goto setting

set inputFile=settings.txt
set "lastLine="
for /f "delims=" %%i in (%inputFile%) do (
    set "lastLine=%%i"
)
if "%lastLine%"=="dev" (
    set "dev-mode=1"
) else (
    set "dev-mode=0"
)


:extract-settings
    :: Extract data from Settings file
    setlocal enabledelayedexpansion
    set "file=settings.txt"
    set nr=0
    for /l %%i in (1,1,5) do (
        set "line%%i="
    )
    for /f "delims=" %%a in (%file%) do (
        set /a "nr+=1"
        set "line!nr!=%%a"
    )
    set "insdonevar1=!line1!"
    set "stdfile=!line2!"
    set "stdrc1=!line3!"
    if not defined devtools (goto enableascii) else (goto dtd)

:enableascii
    :: Allow for example ASCII art
    SETLOCAL EnableDelayedExpansion
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
    SETLOCAL DisableDelayedExpansion

:menu
    :: Main Menu TLI
    cls
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                     



    @ping -n 1 localhost> nul
    echo Made by PIRANY 
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
    echo [6] Autostart/Desktop Icon
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [7] Check for Script-Updates
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [8] Check for Library Updates (may take some time)
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [9] Open GitHub-Repo
    echo.
    echo.
    set /p menu1=Choose an Option from Above:

    If %menu1% == 1 goto info
    If %menu1% == 2 goto start
    If %menu1% == 3 goto cancel
    If %menu1% == 4 goto credits
    If %menu1% == 5 goto setting
    If %menu1% == 6 goto autostartdeskic
    If %menu1% == 7 goto checkgitupdt
    If %menu1% == 8 goto checklibupdt
    If %menu1% == 9 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto menu
    goto menu

:checkgitupdt
    :: Check for Update (Why not restart the Script at all and then check for updates)
    set "owner=PIRANY1"
    set "repo=DataSpammer"
    set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
    echo Fetching Git Url....
    @ping -n 1 localhost> nul
    for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
    if %latest_version% equ v2.7 (goto UpToDate1) else (goto gitverout)

:UpToDate1
    :: Display Version
    @ping -n 1 localhost> nul
    echo The Version you are currently Using is the newest one (%latest_version%)
    pause 
    goto menu 

:checklibupdt
    :: REWORK NEEDED - Check for Lib Updates
    echo Checking for Updates...
    start cmd /k "scoop update && exit /b 0"
    start cmd /k "scoop update jq && exit /b 0"
    start cmd /k "winget upgrade --id Git.Git -e --source winget && exit /b 0"
    goto menu

:info
    :: TLI for Infos
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
    goto info

:credits
    :: TLI Code for Credits
    cls 
    echo.
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo This Script is made by PIRANY for Educational Use only.
    @ping -n 1 localhost> nul
    echo The whole Code is made by PIRANY  
    @ping -n 1 localhost> nul
    echo If you found any Bugs/Glitches or have a Problem With this software please Create a Issue on the Github-Repo
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
    If %menu3% == 2 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto credits
    goto credits

:setting
if %small-install% == 1 echo "Due to the Small Install this section is locked." && @ping -n 2 localhost> nul && goto setting

if %dev-mode% == 1 set "settings-dev-display=Activated"
if %dev-mode% == 0 set "settings-dev-display=Not Activated"
    :: TLI for Settings - Add Skip Security Question + Always use Custom Directory Yes/No
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
    echo [2] Standard Directory to Spam(idk why you would need this but here you go)
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Activate Developer Options (%settings-dev-display%)
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go back
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul


    set /p menu4=Choose an Option from Above:
    If %menu4% == 1 goto filenamechange
    If %menu4% == 2 goto stddirectorycrash
    If %menu4% == 3 goto activate-dev-options
    If %menu4% == 4 goto menu
    goto setting

:activate-dev-options
if %dev-mode% == 1 echo Developer Mode is already activated!

echo Do you want to activate the Developer Options?
echo Developer Options include Debugging, Logging and some extra Menus
    choice /C YN /M "Yes/No (Y/N)"
    set _erl=%errorlevel%
    if %_erl%==Y goto write-dev-options
    if %_erl%==N goto setting

:write-dev-options
setlocal enabledelayedexpansion
set inputFile=settings.txt
set tempFile=tempfile.tmp
(for /f "delims=" %%i in (%inputFile%) do (
    echo %%i
)) > %tempFile%
echo dev >> %tempFile%
move /y %tempFile% %inputFile%
echo Developer Options have been activated!
@ping -n 1 localhost> nul
goto restart-script

:filenamechange
    :: Write Standart Filename to File
    cls 
    echo The Filename cant have the following Character(s):\ / : * ? " < > |"
    set /p mainfilename=Type in the Filename you want to use.
    setlocal enabledelayedexpansion
    set "file=settings.txt"
    set "tmpfile=temp.txt"
    set linenumber=0
    (for /f "tokens=*" %%a in (!file!) do (
        set /a "linenumber+=1"
        if !linenumber! equ 2 (
            echo !mainfilename!
        ) else (
            echo %%a
        )
    )) > !tmpfile!
    move /y !tmpfile! !file!
    echo The Standart Filename was saved!
    cls
    goto setting


:stddirectorycrash
    :: Standart Spam Directory Check
    cls 
    echo.
    echo.
    set /p directory0=Type Your Directory Here:
    if exist %directory0% (goto stddirectorycrash2) else (goto stddirectorycrash3)

:stddirectorycrash2
    :: Write Standart Spam Directory to Settings
    setlocal ENABLEDELAYEDEXPANSION
    set "setfile=settings.txt"
    set "tmpfile=temp.txt"
    set "lineCounter=0"

    (
      for /f "tokens=*" %%a in (!setfile!) do (
        set /a "lineCounter+=1"
        if !lineCounter! equ 3 (
          echo !directory0!
        ) else (
          echo %%a
        )
      )
    ) > !tmpfile!
    move /y !tmpfile! !setfile!
    echo The Directory was saved!
    cls
    goto setting

:stddirectorycrash3
    :: Not so hard to understand
    echo The Directory is invalid!
    pause
    goto stddirectorycrash

:autostartdeskic
    :: Autostart TLI
    echo.
    cls
    echo.
    echo ==================
    echo Autostart/Desktopicon Settings
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
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Delete DesktopIcon
    echo.
    @ping -n 1 localhost> nul
    echo [4] Back
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [5] Settings
    echo.
    echo.
    set /p menu000=Choose an Option from Above:

    If %menu000% == 1 goto autostartsetup
    If %menu000% == 2 goto autostartdelete
    If %menu000% == 4 goto menu
    If %menu000% == 3 goto desktopicdel
    If %menu000% == 5 goto autostartdesktsett
    goto autostartdeskic

:autostartsetup
    :: Autostart Setup TLI - INOPERATIONAL - NEED TO FIX ASAP
    echo This Setup will lead you trough the Autostart/Desktopicon Setup.
    @ping -n 1 localhost> nul
    echo If you are not sure what that is please take a look at the Information.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Start Setup for Autostart
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Start Setup for DesktopIcon
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] View Information
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go Back
    @ping -n 1 localhost> nul
    echo.
    set /p menu123134=Choose an Option from Above:

    If %menu123134% == 3 goto viewdocs 
    If %menu123134% == 1 goto autostartsetupconfyy
    If %menu123134% == 4 goto autostart
    If %menu123134% == 2 goto desktopiconsetup
    goto autostartsetup

:viewdocs 
    @ping -n 1 localhost> nul
    echo If you put for example Links or Programms into your Autostart Folder 
    @ping -n 1 localhost> nul
    echo They will automaticly launch if you boot your Device.
    @ping -n 1 localhost> nul
    echo Your System cant be more vulnerable if you do this.
    @ping -n 1 localhost> nul
    echo You can create an Desktop Icon too if you dont want the Script to open 
    @ping -n 1 localhost> nul
    echo Every time you boot.
    @ping -n 1 localhost> nul
    echo Please note that if you change the Directory you also need to change it in the Autostart Settings.
    @ping -n 1 localhost> nul
    echo [1] Go back
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Open Desktop Icon Setup.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Open AutostartSetup
    echo.
    @ping -n 1 localhost> nul
    set /p viewdocsmenu=Choose an Option from above:

    If %viewdocsmenu% == 1 goto autostartsetup
    If %viewdocsmenu% == 2 goto desktopiconsetup
    If %viewdocsmenu% == 3 goto autostartsetupconfyy
    goto viewdocs

:autostartdelete
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto autostartdelete2) else (goto noelev)
:autostartdelete2
    echo Autostart is getting detected as a Virus from some antivirus Programs. 
    echo A Tutorial on how to temporarily turn off your AV is down below
    echo.
    @ping -n 1 localhost> nul
    echo [1] Open Tutorial on how to turn off AV
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Go back
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] My AV is turned off!
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Close the Script
    set /P avturnoff=Choose an Option from above
    if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" | cls | goto autostartdelete2
    if %avturnoff% == 2 cls | goto viewdocs 
    if %avturnoff% == 3 cls | goto autostartdelete3
    if %avturnoff% == 4 cls | goto cancel
    goto autostartdelete2

:autostartdelete3
    @ping -n 1 localhost> nul
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    del autostart.bat
    cd /d %~dp0

:autostartsetupconfyy
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto autostartsetupconfyy2) else (goto noelev)
:autostartsetupconfyy2
    @ping -n 1 localhost> nul
    echo The Setup for Autostart is now starting...
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    @ping -n 1 localhost> nul
    echo. > DataSpammer.bat
    set "varlinkauto=%~dp0"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    dataspammer.bat
    ) > autostart.bat
    cd /d %~dp0


:desktopiconsetup
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto desktopiconsetup2) else (goto noelev)
:desktopiconsetup2
    cd %userprofile%\Desktop
    echo. > DataSpammer.bat
    set "varlinkauto=%~dp0"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    dataspammer.bat
    ) > DataSpammer.bat
    echo Done!
    pause
    goto autostartdeskic
                                                                                                    

:autostartdesktsett
    echo.
    @ping -n 1 localhost> nul
    echo If you have moved the Directory please Delete the Autostart and Then Set it up new
    @ping -n 1 localhost> nul
    pause
    goto autostartdeskic

:quickstart




:start
    cls
    set "verify=%random%"
    echo Please Verify that you want to use a Spam Method.
    echo Please have in Mind that this can make your Installation Unusable.
    echo Please enter %verify% in the Field Below
    set /p verifyans=Type %verify%:
    if "%verifyans%"=="%verify%" (
        goto start187
    ) else (
       goto start
    )

:start187
    echo Choose the Method you want to use:
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] .txt Spam in custom Directory
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Desktop Icon Spam
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Remote Spam (Under developement)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go Back
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /p spammethod=Choose an Option from Above:

    If %spammethod% == 1 goto txtspamchose
    If %spammethod% == 2 goto deskiconspam
    If %spammethod% == 3 goto remotespam
    If %spammethod% == 4 goto menu
    goto start187

:remotespam
    :: Not working - TLI For remotespam
    echo In Order to work the Remote Spam Method needs 6 components.
    @ping -n 1 localhost> nul
    echo 1: The IP of the Device you want to spam
    @ping -n 1 localhost> nul
    echo 2: The Account you want to Use
    @ping -n 1 localhost> nul
    echo 3: The Passwort of the Account you want to spam
    @ping -n 1 localhost> nul
    echo 4: A Filename
    @ping -n 1 localhost> nul
    echo 5: The Directory you want to Spam.
    @ping -n 1 localhost> nul
    echo 6: How many Files you want to create
    @ping -n 1 localhost> nul
    echo The Device has to be turned on too and has to be connected to the Internet. It has to accept the connection too. 
    @ping -n 1 localhost> nul
    echo.
    echo. 
    echo [1] Continue
    echo.
    echo [2] Back
    echo.
    set /P remotespamchoose=Choose an Option from above:
    if %remotespamchoose% == 1 goto remotespamsetupfirst
    if %remotespamchoose% == 2 goto start187

:remotespamsetupfirst
    :: Ask the User to enter the IP - supported with arp
    echo Please specify the IP of the Device
    @ping -n 1 localhost> nul
    echo Down Below are a Few IPs in your Network. 
    arp -a 
    @ping -n 1 localhost> nul
    echo If you need help finding the IP type "help"
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /P remotespamip=Enter the IP:
    if %remotespamip% == help (
        start "" "https://support.ucsd.edu/services?id=kb_article_view&sysparm_article=KB0032480"
    ) else (
        goto remotespamsetup
    )
:remotespamsetup
    :: Check if IP is valid
    setlocal enabledelayedexpansion
    echo !remotespamip! | findstr /R "^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if %errorlevel% equ 0 (
        goto remotespamsetup2
    ) else (
        echo The IP you entered doesnt seem Valid. Please try again.
        pause
        goto remotespamsetupfirst
    )

:remotespamsetup2
    :: Enter other things needed for Remotespam
    set /P remotespamaccname=Enter an Account Name:
    set /P remotespampasswrd=Enter the Password of the Account:
    echo The Filename cant include the following Character(s):\ / : * ? " < > |"
    set /P remotespamfilename=Enter a Filename:
    set /P remotespamfilecount=How many files do you want to create:
:remotespamverify
    :: Verify execution
    cls
    set "verify=%random%"
    echo Please Verify that you want to this Spam Method.
    set /p verifyans=Type %verify%:
    if "%verifyans%"=="%verify%" (
        goto startremotespam
    ) else (
        goto remotespamverify
    )

:startremotespam
    :: 100% UD ASSET COUNTER (Does nothing)
    set "assetcount=1"
    :assetcounttop
    color 02
    @ping -n 1 localhost> nul
    echo Loading Assets [%assetcount%/32]
    set /a "assetcount+=1"
    cls
    If %assetcount% == 33 (goto remotespamstart) else (goto assetcounttop)

:remotespamstart
    :: remotespam countdown
    echo 3
    @ping -n 2 localhost> nul
    echo 2
    @ping -n 2 localhost> nul
    echo 1
    @ping -n 2 localhost> nul
    echo Starting.....
    @ping -n 2 localhost> nul
    set "remotespamcount=1"
    cd %temp%
    echo Troll by https://github.com/PIRANY1/DataSpammer > dataspammertemp.txt
:startremotespamwasset
    :: remotespam executor
    scp file.txt root@serverip:~/file.txt
    scp %temp%\dataspammertemp.txt %remotespamaccname%@%remotespamip%:Desktop\%remotespamfilename%_%remotespamcount%.txt
    %remotespampasswrd%
    set /a "remotespamcount+=1"
    if %remotespamfilecount% == %remotespamcount% (goto remotespamdone) else (goto startremotespamwasset)

:remotespamdone
    :: Remote Spam Done TLI
    echo.
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                                                                                                                  
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo The Script Created %remotespamfilecount% Files on the PC of %remotespamaccname%
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
    goto remotespamdone

:deskiconspam
    :: Desktop Spam Start TLI
    @ping -n 1 localhost> nul
    echo This Method will Spam your Desktop with Files
    @ping -n 1 localhost> nul
    echo You can customise four things here. 
    @ping -n 1 localhost> nul
    echo 1:Filename
    @ping -n 1 localhost> nul
    echo 2:Format of the File (for example .txt or .bat)
    @ping -n 1 localhost> nul
    echo 3:The Text in the File
    @ping -n 1 localhost> nul
    echo 4:Count of Files
    @ping -n 1 localhost> nul
    echo.
    echo [1] Start 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Go Back
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /p menu1877=Choose an Option from Above:
    If %menu1877% == 2 goto start
    If %menu1877% == 1 goto deskiconspam1
    goto deskiconspam

:deskiconspam1
    :: Name TLI
    echo How Should the Files be named?
    @ping -n 1 localhost> nul
    echo The Filename cant include one of the following Character(s):\ / : * ? " < > |"
    @ping -n 1 localhost> nul
    set /p "deskiconspamname=Choose a Filename:"
    goto deskiconspam2

:deskiconspam2  
    :: Format TLI
    echo Now Choose the Format of the File
    @ping -n 1 localhost> nul
    echo If you are not sure type txt
    @ping -n 1 localhost> nul
    echo Please not include the dot
    @ping -n 1 localhost> nul
    set /p "deskiconspamformat=Choose the Format:"
    goto deskiconspam3

:deskiconspam3
    :: Content TLI
    echo Now Choose the Content the File should include
    @ping -n 1 localhost> nul
    set /p "deskiconspamcontent=Type something in:"
    goto deskiconspam4

:deskiconspam4
    :: Filecount TLI
    echo Now Choose how many files should be created 
    @ping -n 1 localhost> nul
    echo Leave empty if you want infinite.
    @ping -n 1 localhost> nul
    set /p "deskiconspamamount=Type a Number:"
    goto deskiconspamwdata

:deskiconspamwdata
    :: verify tli
    echo All set. 
    @ping -n 1 localhost> nul
    echo Please confirm that you want to Spam your Desktop.
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo [y] Yes
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [n] No, Cancel
    @ping -n 1 localhost> nul
    set /p deskicspamconf11=Choose an Option from Above:
    If %deskicspamconf11% == y goto deskiconspamconfdata
    If %deskicspamconf11% == n goto menu
    goto deskiconspamwdata

:deskiconspamconfdata
    :: 100% UD ASSET COUNTER (does nothing but look cool)
    set "assetcount=1"
    :assetcounttop
    color 02
    @ping -n 1 localhost> nul
    echo Loading Assets(%assetcount%/32)
    set /a "assetcount+=1"
    If %assetcount% == 33 (goto deskiconspamsetdonestart) else (goto assetcounttop)

:deskiconspamsetdonestart
    :: Desktop Spam Countdown
    cls
    color 02
    echo The Desktopiconspammer is about to start....
    @ping -n 2 localhost> nul
    echo 3 Seconds Left
    echo If you want to stop this, Simply close the CMD-Window
    @ping -n 2 localhost> nul
    echo 2 Seconds Left
    @ping -n 2 localhost> nul
    echo 1 Seconds Left
    @ping -n 1 localhost> nul
    echo Starting.....
    cd /d %userprofile%\Desktop
    if not defined deskiconspamamount (
        goto infinitespam
    ) else (
        goto limitedspam
    )
    exit


:infinitespam
    :: Infinite Spam Function
    :deskspamtop
    echo %deskiconspamcontent% > %deskiconspamname%.%deskiconspamformat%
    goto deskspamtop
    exit

:limitedspam
    :: Limited Spam Function
    color 02
    set "deskspamlimitedvar=1"
    :limitedspam1
    If %deskspamlimitedvar% == %deskiconspamamount% (goto done2) else (goto limitedspam2)
    :limitedspam2
    echo Created %deskspamlimitedvar% File(s)
    echo %deskiconspamcontent% > %deskiconspamname%%deskspamlimitedvar%.%deskiconspamformat%
    set /a "deskspamlimitedvar+=1"
    goto limitedspam1

:txtspamchose
    :: dont know if that function is even used but it works
    if stdrc1 equ notused (goto novarset) else (cd /d %stdrc1% && goto nameset)

:novarset
    :: normal spam tli
    cls
    echo Please enter the Directory of the Folder/Server you want to Spam.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo You can find the Directory by Clicking on the Path in you Explorer (on top) and copy it in here. 
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo It should look something like this: C:\User\Dokuments\SpamFolder
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
    :: what is this doin here?
    cd /d %userprofile%

:manualcd
    :: enter directory tli
    echo.
    echo.
    set /p directory1=Type Your Directory Here:

    cd /d %directory1%

    if %ERRORLEVEL% neq 0 (
        echo There was an Error. Please check if the Directory is correct or retry later. 
    ) else (
        echo The Directory was Correct!
        goto nameset
    )

:nameset
    :: check if filename setting is used
    if %stdfile% equ notused (goto nameset2) else (goto timerask)

:nameset2
    :: filename tli
    cls
    echo Now You have to choose a filename. It can be anything as long as the 
    echo Filename doesnt have the following Character(s):\ / : * ? " < > |"
    set /p stdfile=Type in the Filename you want to use.
    setlocal enabledelayedexpansion
    goto timerask

:timerask
    :: check if the script should run for eternity
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
    If %menu6% == n set "filecount=1%large%%large%%large%%large%%large%%large%%large%%large%%large%%large%%large%" && goto cddone
    goto timerask

:timerset 
    :: filecount tli
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
    :: confirmation dialoge
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
    echo If you want to stop this script simply close the Command Windows or press ALT+F4 / CTRL+C
:top
    :: create files
    set /a x+=1
    echo. > %stdfile%%x%.txt
    echo Created %x% File(s).
    if %x% equ %filecount% (goto done) else (goto top)


:done
    :: done tli
    cls
    echo.
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                                                                                                                     

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
    goto done

:done2
    :: done tli
    echo.
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                     
                                                                                              

    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo The Script Created %deskspamlimitedvar% Files.
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
    goto done2

:: Display Help Dialog
:help
    echo.
    echo.
    echo Dataspammer: 
    echo    With this script, you can create files on your PC or your friends' PC in large quantities.
    echo.
    echo Usage dataspammer [Argument]
    echo       dataspammer.bat [Argument]
    echo.
    echo Parameters: 
    echo    help Show this Help Dialog
    echo.
    echo    update Check for Updates and exit afterwards
    echo.
    echo    faststart Start the Script without checking for Anything 
    echo.
    echo    remove Remove the Script and its components from your System
    echo.
    echo    start Directly start a Spam Method
    echo.
    echo    api Call the Scripts API and get a Plain-Text response (currently in Alpha)
    echo.
    echo    cli Use the Scripts CLI Interface (currently in Alpha)
    echo.
    echo.

    exit /b 1464

:: Whitout the UD stuff
:fastgitupdate
    :: Check for Update (Why not restart the Script at all and then check for updates)
    set "owner=PIRANY1"
    set "repo=DataSpammer"
    set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
    echo Fetching Data...
    for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
    if %latest_version% equ %current-script-version% (
        echo The Script is up-to-date [Version:%latest_version%]
    ) else (
        echo Your Script is outdated [Newest Version: %latest_version% Script Version:%current-script-version%]
    )
    exit /b 0

:remove-script
    :: Delete Script TLI
    echo. 
    @ping -n 1 localhost> nul
    echo You are about to delete the whole script.
    @ping -n 1 localhost> nul 
    echo Are you sure about this decision?
    @ping -n 1 localhost> nul
    echo If the script is bugged or you want to download the new Version please Visit the GitHub Repo
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
    echo [3] No Go Back
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /p delscrconf=Choose an Option from Above

    If %delscrconf% == 1 goto remove-script-confirmed
    If %delscrconf% == 2 explorer "https://github.com/PIRANY1/DataSpammer" && goto remove-script
    If %delscrconf% == 3 exit /b 100
    goto remove-script

:remove-script-check-elev
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto remove-script-confirmed) else (goto noelev)
   
:remove-script-confirmed
    :: Delete Script 
    if exist "%~dp0\LICENSE" del "%~dp0\LICENSE"
    echo 1/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\README.md" del "%~dp0\README.md"
    echo 2/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\dataspammer.bat" del "%~dp0\dataspammer.bat"
    echo 3/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\install.bat" del "%~dp0\install.bat"
    echo 4/7 Files Deleted
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    if exist "autostart.bat" del "autostart.bat"
    echo 5/7 Files Deleted
    @ping -n 1 localhost> nul
    cd /d %userprofile%\Desktop
    if exist "Dataspammer.bat" del "Dataspammer.bat"
    echo 6/7 Files Deleted
    @ping -n 1 localhost> nul
    set "startMenuPrograms=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    cd %startMenuPrograms%
    if exist "Dataspammer.bat" del "Dataspammer.bat"
    echo 7/7 Files Deleted
    echo Uninstall Successfull
:noelev
    :: Script isnt elevated TLI
    echo Please start the Script as Administrator in order to install.
    echo To do this right click the Dataspammer File and click "Run As Administrator"
    echo The Explorer Windows with the Script will open in 5 Seconds
    timeout 5
    explorer %~dp0
    exit 0

:restart-script
set "restart-main=1"
install.bat

:cli
@echo off
chcp 65001 >nul
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
echo Type 'help' to get an overview of commands
:input
echo.
echo  [97m???[0m([92m%username%[0m@[95m%computername%[0m)-[[91m%cd%[0m] - [[94m%time% %date%[0m]
set /p cmd=".%BS% [97m???>[0m "
echo.
%cmd%
goto input


:cancel 
    :: yes
    exit
    exit

:dtd
    :: ud dev stuff
    set /p dtd1=.:.
    %dtd1%
