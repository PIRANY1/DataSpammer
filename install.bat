
:: Check Reg
:: Check Elev
:: Remove Beta Branch
:: Check readme
:: add install arg
:: Add update applist on update
:: add add to path

:installer.main.window
    @title DataSpammer - Install
    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                     

    echo Made by PIRANY - %current-script-version% - Batch
    echo.
    call :sys.lt 1
    echo This Installer will lead you through the process of installing the DataSpammer Utility.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Use Program Files as Installation Directory 
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Use Custom Directory
    echo. 
    call :sys.lt 1
    echo.
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 set "directory=%ProgramW6432%"
        if %_erl%==2 set /p directory=Enter the Directory:
    if not defined directory ( goto installer.main.window )

    if not "%directory:~-1%"=="\" set "directory=%directory%\"
    cd /d "%directory%"

    set "startmenushortcut=Not Included"
    set "desktopicon=Not Included"
    set "autostart=Not Included"

:installer.menu.select
    echo Some Files may get flagged as Malware by Antivirus Software.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo The script will install itself in the following directory: %directory%
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] (%startmenushortcut%) Startmenu Shortcut/All Apps List 
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [2] (%desktopicon%) Desktop Shortcut
    call :sys.lt 1
    echo. 
    call :sys.lt 1
    echo [3] (%autostart%) Start with Windows/Autostart
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Done/Skip
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [5] De-select All Options
    echo.
    echo.
    choice /C 12345 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 cls && set "startmenushortcut=Included" && set "startmenushortcut1=1" && goto installer.menu.select
        if %_erl%==2 cls && set "desktopicon=Included" && set "desktopic1=1" && goto installer.menu.select
        if %_erl%==3 cls && set "autostart=Included" && set "autostart1=1" && goto installer.menu.select
        if %_erl%==4 goto installer.start.copy
        if %_erl%==5 set "startmenushortcut=Not Included" && set "desktopicon=Not Included" && set "autostart=Not Included" && goto installer.menu.select
    goto installer.menu.select

:installer.start.copy
    set "directory9=%directory%DataSpammer\"
    mkdir "%directory9%" 
 
    cd /d "%~dp0"

    move dataspammer.bat "%directory9%\" >nul 2>&1
    move README.md "%directory9%\" >nul 2>&1
    move LICENSE "%directory9%\" >nul 2>&1

    cd /d "%directory9%"
    :: Download new Files if one line was used to install
    set "update_url=https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/"
    if not exist dataspammer.bat ( %powershell.short% iwr "%update_url%dataspammer.bat" -UseBasicParsing -OutFile "%directory9%\dataspammer.bat" >nul 2>&1 ) 
    if not exist README.md( %powershell.short% iwr "%update_url%README.md" -UseBasicParsing -OutFile "%directory9%\README.md" >nul 2>&1 )
    if not exist LICENSE( %powershell.short% iwr "%update_url%main/LICENSE" -UseBasicParsing -OutFile "%directory9%\LICENSE" >nul 2>&1 ) 

    :: Add Script to Windows App List
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    )
    reg add "%RegPath%" /v "DisplayName" /d "DataSpammer" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%current-script-version%" /f
    reg add "%RegPath%" /v "InstallLocation" /d "%directory9%" /f
    reg add "%RegPath%" /v "Publisher" /d "PIRANY1" /f
    reg add "%RegPath%" /v "UninstallString" /d "%directory9%\dataspammer.bat remove" /f

    :: Create settings.conf
    cd /d "%directory9%"
    (
        echo :: DataSpammer configuration
        echo :: Standard Filename
        echo default_filename=notused
        echo :: Standard Directory
        echo default_directory=notused
        echo :: Check for Updates
        echo update=1
        echo :: Logging is on by default
        echo logging=1
        echo :: Developer Mode
        echo developermode=0
        echo :: Default Filecount
        echo default-filecount=notused
        echo :: Default Domain
        echo default-domain=notused
        echo :: Elevation Method used (pwsh / sudo / gsudo)
        echo elevation=pwsh
        echo :: Change Monitoring Socket
        echo monitoring=0
        echo :: Change Color - Default 02 (CMD Coloring)
        echo color=02
        echo :: Skip Security Question
        echo skip-sec=0
    ) > settings.conf

    if not defined startmenushortcut1 ( goto desktop.icon.install.check )
    cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    (
    echo cd /d "%directory9%"
    echo dataspammer.bat
    ) > DataSpammer.bat

:desktop.icon.install.check
    if not defined desktopic ( goto script.win.start.check )
    cd /d "%userprofile%\Desktop"
    (
    echo cd /d "%directory9%"
    echo dataspammer.bat %1 %2 %3 %4 %5
    ) > DataSpammer.bat

:script.win.start.check
    if not defined autostart ( goto additional.links.installed )
    cd /d C":\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
    (
    echo cd /d "%directory9%"
    echo dataspammer.bat
    ) > autostart.bat

:additional.links.installed
    :: Add Registry Key - Remember Installed Status
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f

:sys.main.installer.done
    echo Do you want to encrypt the Script Files?
    call :sys.lt 1
    echo This can bypass Antivirus Detections.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Yes
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] No
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo.
    choice /C 12 /M "1/2:"
        set _erl=%errorlevel%
        if %_erl%==1 goto encrypt.script
        if %_erl%==2 goto finish.installation
    goto sys.main.installer.done


:encrypt.script
    for /f "delims=" %%a in ('where certutil') do (
        set "where_output=%%a"
    )  
    if not defined where_output goto finish.installation
    cd /d "%~dp0 "
    echo %random% > "%userprofile%\Documents\SecureDataSpammer\token.hash"
    (
        @echo off
        cd /d "%~dp0"
        echo FF FE 0D 0A 63 6C 73 0D 0A > "%directory9%\temp_hex.txt"
        certutil -f -decodehex "%directory9%\temp_hex.txt" "%directory9%\temp_prefix.bin"
        move "%directory9%\dataspammer.bat" "%directory9%\original_dataspammer.bat"
        copy /b "%directory9%\temp_prefix.bin" + "%directory9%\original_dataspammer.bat" "%directory9%\dataspammer.bat"
        erase "%directory9%\temp_hex.txt"
        erase "%directory9%\temp_prefix.bin"
        Cipher /E "%directory9%\dataspammer.bat"
        cd /d "%~dp0"
        cd /d "%directory9%"
        dataspammer.bat
        erase encrypt.bat
    ) > encrypt.bat
     
    start %powershell.short% -Command "Start-Process 'encrypt.bat' -Verb runAs"
    exit /b startedencryption


:finish.installation
    echo Finishing Installation....
    call :sys.lt 3
    erase "%~dp0\Install" > nul 
    Data-Spammer



