:: Use only under License
:: Contribute under https://github.com/PIRANY1/DataSpammer
:: Version v6 - NIGHTLY
:: Last edited on 09.04.2025 by PIRANY

:: Improve Progress.txt

    @echo off
    cd /d %~dp0
    @color 02
    @title DataSpammer - Install
    
    :: Improve NT Compatability
    if "%OS%"=="Windows_NT" setlocal
    set DIRNAME=%~dp0
    if "%DIRNAME%"=="" set DIRNAME=.

    setlocal ENABLEDELAYEDEXPANSION
    :: Window Sizing
    mode con: cols=140 lines=40

    :: Preset Vars
    set "foldername=DataSpammer"
    set "current-script-version=v6"
    
    :: Dev Tool
    if "%1"=="go" goto custom.go
    
    :: Check if Settings Exist
    reg query "HKCU\Software\DataSpammer" /v Installed >nul 2>&1
    if %errorlevel% neq 0 (
        echo The Installer was already executed.
        echo Opening DataSpammer.bat...
        call :sys.lt 3
        "%~dp0\dataspammer.bat"
    )

:installer.main.window
    if exist "%temp%\progress.txt" goto standard.install.run

    :: Allows ASCII stuff without Codepage Settings - Not My Work - Credits to ?
    SETLOCAL EnableDelayedExpansion
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
    SETLOCAL DisableDelayedExpansion


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
    echo [1] Normal Install  (Recommended, Needs Administrator Privileges)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Small Install (WITHOUT Updater, Settings and some less-important Features)
    echo. 
    call :sys.lt 1
    echo.
    echo.
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto standard.install.run
        if %_erl%==2 installer.custom.install.directory
    goto installer.main.window

:standard.install.run
    :: Some Pre-Install Stuff
    set "directory=%ProgramW6432%"
    cd /d "%directory%"
    net session >nul 2>&1
    if %errorLevel% neq 0 (
    echo. goto.elevate "%temp%\progress.txt" > nul
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit
    )

:standard.install.run.2
    set "startmenushortcut=Not Included"
    set "desktopicon=Not Included"
    set "autostart=Not Included"

:standard.install.run.3
    echo Some Files may get flagged by some Antivirus Software.
    echo.
    call :sys.lt 1
    echo [1] Continue
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Open Link to Disable Antivirus
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Go Back
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Close the Script
    echo.
    echo.
    choice /C 1234 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 cls & goto standard.install.run.4
        if %_erl%==2 start "" "https://www.security.org/antivirus/turn-off/" & cls 
        if %_erl%==3 cls & goto installer.main.window
        if %_erl%==4 cls & goto cancel
    goto standard.install.run.3

:standard.install.run.4
    echo The script will install itself in the following directory: %ProgramW6432%
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
    echo [5] De-select / Cancel Options
    echo.
    echo.
    choice /C 12345 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 cls & goto n1varinst
        if %_erl%==2 cls & goto n2varinst
        if %_erl%==3 cls & goto n3varinst
        if %_erl%==4 goto installer.start.copy
        if %_erl%==5 goto standard.install.run.2
    goto standard.install.run


:n1varinst
    set "startmenushortcut=Included"
    set "startmenushortcut1=1"
    goto standard.install.run.4

:n2varinst
    set "desktopicon=Included"
    set "desktopic1=1"
    goto standard.install.run.4

:n3varinst
    set "autostart=Included"
    set "autostart1=1"
    goto standard.install.run.4


:installer.custom.install.directory
    set "small-install=1"
    call :sys.lt 1
    echo Please specify the directory where the script should be installed.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    set /p directory=Type Your Directory Here: 

    echo Installing Script...
    cd /d %~dp0
    mkdir DataSpammer
    set "install-directory=%cd%"
    xcopy dataspammer.bat "%install-directory%\DataSpammer"
    erase dataspammer.bat > nul
    cd /d DataSpammer
    echo small-install > settings.conf
    cd /d %~dp0
    erase README.md > nul
    erase LICENSE > nul
    
    echo Installation Done.
    cd /d DataSpammer 
    erase %install-directory%\install.bat > nul
    dataspammer.bat


:installer.start.copy
    set "gitinsyn=1"
    :: Main install part
    set "directory9=%directory%\%foldername%"
    mkdir "%directory9%" 
 
    cd /d %~dp0
    erase readme.md > nul   
    erase license > nul
    curl -sSLo license https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/license > nul
    curl -sSLo readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/readme.md > nul
    erase dataspammer.bat > nul 
    cd /d "%directory9%"
    curl -sSLo dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat > nul
    curl -sSLo install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat > nul

    :: Add Script to Registry / AppList
    set "app.name=DataSpammer"
    set "app.version=%current-script-version%"
    set "app.path=%directory9%"
    set "app.publisher=PIRANY1"

    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%app.name%"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%app.name%"
    )
    reg add "%RegPath%" /v "DisplayName" /d "%app.name%%x%" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%app.version%" /f
    reg add "%RegPath%" /v "InstallLocation" /d "%app.path%" /f
    reg add "%RegPath%" /v "Publisher" /d "%app.publisher%" /f
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
    
    echo Created Settings.conf
    if not defined startmenushortcut1 (goto desktop.icon.install.check)

:start.menu.icon.setup
    cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    (
    echo @echo off
    echo cd /d "%directory9%"
    echo dataspammer.bat
    ) > DataSpammer.bat
    echo Added Startmenu Shortcut

:desktop.icon.install.check
    if not defined desktopic (goto script.win.start.check)

:desktop.icon.install
    cd /d %userprofile%\Desktop
    (
    echo @echo off
    echo cd /d "%directory9%"
    echo dataspammer.bat %1 %2 %3 %4 %5
    ) > DataSpammer.bat
    echo Added Desktop Shortcut

:script.win.start.check
    if not defined autostart (goto additional.links.installed)
    
:script.win.start.setup
    echo The setup for Autostart is now starting...
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    (
    echo @echo off
    echo cd /d "%directory9%"
    echo dataspammer.bat
    ) > autostart.bat
    cd /d %~dp0
    echo Added Autostart Shortcut!

:additional.links.installed
    :: Add Registry Key - Remember Installed Status
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f

:additionals.ask.window
    if exist "%~dp0\LICENSE" ( erase "%~dp0\LICENSE" > nul )
    if not exist "%~dp0\README.md" ( goto additionals.ask.window )
    echo Do you want to delete the LICENSE and README files?
    call :sys.lt 1
    echo.
    echo [1] List content of README
    call :sys.lt 1
    echo.
    echo [2] Delete README
    call :sys.lt 1
    echo.
    echo [3] Copy in Script Folder
    call :sys.lt 1
    echo.
    echo [4] Done/Skip
    echo.
    call :sys.lt 1
    echo.
    choice /C 1234 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 for /f "tokens=*" %%a in (%liscensefad1%) do ( echo %%a ) && pause && goto additionals.ask.window
        if %_erl%==2 if exist "%~dp0\README.md" ( erase "%~dp0\README.md" > nul ) && goto sys.main.installer.done
        if %_erl%==3 if exist "%~dp0\README.md" ( xcopy "%~dp0\README.md" "%directory%\%foldername%\%current-script-version%" > nul ) && if exist "%~dp0\README.md" ( erase %~dp0\README.md > nul ) && goto sys.main.installer.done
        if %_erl%==4 goto sys.main.installer.done
    goto additionals.ask.window

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


:encrypt.script
    for /f "delims=" %%a in ('where certutil') do (
        set "where_output=%%a"
    )  
    if not defined where_output goto finish.installation
    echo Encrypting...
    cd /d %~dp0 
    echo %random% > "%userprofile%\Documents\SecureDataSpammer\token.hash"
    (
        @echo off
        cd /d %~dp0
        echo FF FE 0D 0A 63 6C 73 0D 0A > "%directory9%\temp_hex.txt"
        certutil -f -decodehex "%directory9%\temp_hex.txt" "%directory9%\temp_prefix.bin"
        move "%directory9%\dataspammer.bat" "%directory9%\original_dataspammer.bat"
        copy /b "%directory9%\temp_prefix.bin" + "%directory9%\original_dataspammer.bat" "%directory9%\dataspammer.bat"
        move "%directory9%\install.bat" "%directory9%\original_install.bat"
        copy /b "%directory9%\temp_prefix.bin" + "%directory9%\original_install.bat" "%directory9%\install.bat"
        erase "%directory9%\original_install.bat"
        erase "%directory9%\original_dataspammer.bat"
        erase "%directory9%\temp_hex.txt"
        erase "%directory9%\temp_prefix.bin"
        Cipher /E "%directory9%\dataspammer.bat"
        Cipher /E "%directory9%\install.bat"
        cd /d %~dp0
        erase install.bat > nul
        cd /d "%directory9%"
        dataspammer.bat
        erase encrypt.bat
    ) > encrypt.bat
     
    start powershell -Command "Start-Process 'encrypt.bat' -Verb runAs"
    exit /b startedencryption


:finish.installation
    echo Finishing Installation....
    cd /d %~dp0
    erase install.bat > nul
    cd /d "%directory9%"
    dataspammer.bat

:cancel
    echo The installer is now closing....
    @ping -n 2 localhost> nul
    set EXIT_CODE=%ERRORLEVEL%
    if %EXIT_CODE% equ 0 set EXIT_CODE=1
    if "%OS%"=="Windows_NT" endlocal
    exit /b %EXIT_CODE%


:custom.go
   if %logging% == 1 ( call :log Opened_Custom_GOTO ) 
   if "%1"=="go" goto custom.go
   set "custom.goto.location=%2"
   goto %custom.goto.location%


:save.progress 
    set "input=%1"
    cd %temp%
    erase progress.txt
    echo %input% > progress.txt
    exit /b 0


:log
    :: call scheme is:
    :: if %logging% == 1 ( call :log Opened_verify_tab )
    :: _ and - are getting replaced by space    

    set "log.content=%1"
    set "logfile=DataSpammer.log"
    
    :: Check folder structure
    set "folder=%userprofile%\Documents\DataSpammerLog"
    if not exist "%folder%" (
        mkdir "%folder%"
    )
    
    set "log.content.clean=%log.content%"
    set log.content.clean=%log.content.clean:_= %
    set log.content.clean=%log.content.clean:-= %

    for /f "tokens=1-3 delims=:." %%a in ("%time%") do set formatted_time=%%a:%%b:%%c
    echo %date% %formatted_time% %log.content.clean% >> "%folder%\%logfile%"
    :: exit
    exit /b 0

:update_config
    :: Example for interactive change
    :: call :update_config "default-filename" "Type in the filename you want to use." ""
    
    :: Example for automated change
    :: call :update_config "logging" "" "1"
    
    :: call :update_config "1" "2" "3"
    :: Parameter 1: Value (logging etc.)
    :: Parameter 2: User choice (interactive prompt, empty for automated)
    :: Parameter 3: New value (leave empty for user input)
    
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

:sys.lt
    set "dur=%1"
    @ping -n %dur% localhost> nul
    exit /b 0

:sys.verify.execution
    :: Script isn't elevated TLI
    echo Please start the script as Administrator in order to install.
    echo To do this right click the install.bat file and click "Run As Administrator"
    pause
    exit

:verify
    set "verify=%random%"
    powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter code %verify% to confirm that you want to execute this option', 'DataSpammer Verify')}" > %TEMP%\out.tmp
    set /p OUT=<%TEMP%\out.tmp
    if not defined OUT goto failed
    if %verify%==%OUT% (goto success) else (goto failed)

:success
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Success', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    exit /b

:failed
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered the wrong code. Please try again', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    goto verify

:restart.script
    cd /d %~dp0
    install.bat

exit /b 0
