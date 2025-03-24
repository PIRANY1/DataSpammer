:: Use only under License
:: Contribute under https://github.com/PIRANY1/DataSpammer
:: Version v6
:: Last edited on 24.03.2025 by PIRANY

:: Developer Notes
:: Define %debug_assist% to bypass echo_off
:: Define devtools to open the developer menu
:: Developer Tool is in install.bat at :sys.add.developer.tool

::    Todo: 
::    Fix Updater - Clueless After 3 Gazillion Updates - Added -UseBasicParsing to iwr
::    Add more Docs
::    Add Auto Adjust Window / better sizing for all TLIs
::    Improve Uninstaller - Include Registry etc.
::    Improve Developer Tool
::    Improve Window Sizing
::    Check all Var Names
::    Add Debug List

:top
    cd /d %~dp0
    @color 02
    @title DataSpammer
    set "exec-dir=%cd%"
    @if "debug_assist"="" @echo off
    :: Improve NT Compatabilty
    if "%OS%"=="Windows_NT" setlocal
    set DIRNAME=%~dp0
    if "%DIRNAME%"=="" set DIRNAME=.
    mode con: cols=140 lines=40
    set "current-script-version=v6"
    :: Improve Powershell Speed
    set "powershell.short=powershell.exe -ExecutionPolicy Bypass -NoProfile"
    if "%1"=="" goto normal.start
    if "%1"=="--help" goto help.startup
    if "%1"=="faststart" goto sys.enable.ascii.tweak
    if "%1"=="update" goto fast.git.update
    if "%1"=="update.script" call :update.script %2
    if "%1"=="remove" goto sys.delete.script
    if "%1"=="cli" goto sys.cli
    if "%1"=="debug" goto debuglog
    if "%1"=="debugtest" goto debugtest
    if "%1"=="api" goto sys.api
    if "%1"=="goto" goto dev.goto
    if "%1"=="monitor" goto monitor
    if "%1"=="noelev" set "small-install=1" && goto pid.check
    if "%update-install%"=="1" ( goto sys.new.update.installed )
    if not defined devtools (goto top-startup) else (gotod open.dev.settings)

:startup
    title DataSpammer - Starting

    :: Check install Type
    set "firstLine="
    set /p firstLine=<settings.conf
    if "%firstLine%"=="small-install" ( set "small-install=1" && goto sys.enable.ascii.tweak )

:sys.elevate
    :: Parse Settings
    echo Parsing Settings...

    if not exist "settings.conf" goto sys.no.settings
    set "config_file=settings.conf"
    for /f "usebackq tokens=1,2 delims==" %%a in (`findstr /v "^::" "%config_file%"`) do (
        set "%%a=%%b"
    )

    :: Start the Elevation Request
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        if "%elevation%"=="sudo" goto sudo.elevation
        if "%elevation%"=="gsudo" goto gsudo.elevation
        %powershell.short% -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )
    cd /d %~dp0
    goto pid.check

:sudo.elevation
    net session >nul 2>&1
    if %errorLevel% neq 0 ( 
        for /f "delims=" %%A in ('where sudo') do set SUDO_PATH=%%A
        %SUDO_PATH% cmd.exe -k %~f0
        exit
    )
    cd /d %~dp0
    goto pid.check

:gsudo.elevation
    net session >nul 2>&1
    if %errorLevel% neq 0 ( 
        for /f "delims=" %%A in ('where gsudo') do set GSUDO_PATH=%%A
        %GSUDO_PATH% cmd.exe -k %~f0
        exit
    )
    cd /d %~dp0
    goto pid.check

:pid.check
    :: Get the Process ID of the current Script - Needed for Monitor
    %powershell.short% -Command "(Get-CimInstance Win32_Process -Filter \"ProcessId=$PID\").ParentProcessId" > "%temp%\parent_pid.txt"
    set /p PID=<"%temp%\parent_pid.txt"
    del "%temp%\parent_pid.txt"
    echo Got PID: %PID%
    
    :: Start the Monitor Socket - Moved here to avoid multiple Instances
    if %monitoring%==1 start /min cmd.exe /k ""%~f0" monitor %PID%"

    :: Check if Login is Setup
    set "secure_dir=%userprofile%\Documents\SecureDataSpammer"
    if not exist "%secure_dir%\username.hash" goto file.check    

:login.input

    del %TEMP%\username.txt > nul
    del %TEMP%\password.txt > nul
    del %TEMP%\username_hash.txt > nul
    del %TEMP%\password_hash.txt > nul

    cls
    set /p "username=Please enter your Username: "
    %powershell.short% -Command "$password = Read-Host 'Please enter your Password' -AsSecureString; [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))" > %TEMP%\password.tmp
    set /p password=<%TEMP%\password.tmp
    del %TEMP%\password.tmp

    echo %username% > %TEMP%\username.txt
    echo %password% > %TEMP%\password.txt
    certutil -hashfile %TEMP%\username.txt SHA256 > %TEMP%\username_hash.txt
    certutil -hashfile %TEMP%\password.txt SHA256 > %TEMP%\password_hash.txt

    for /f "delims=" %%a in ('%powershell.short% -Command "(Get-Content '%TEMP%\username_hash.txt' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "username_hash=%%a"
    for /f "delims=" %%a in ('%powershell.short% -Command "(Get-Content '%TEMP%\password_hash.txt' | Select-String -Pattern '([0-9a-fA-F]{64})').Matches.Groups[1].Value"') do set "password_hash=%%a"
    
    echo Comparing Hashes...
    set /p stored_username_hash=<"%secure_dir%\username.hash"
    set /p stored_password_hash=<"%secure_dir%\password.hash"

    :: echo Calc Username: "%username_hash%"  Stored Username: "%stored_username_hash%"
    :: echo Calc Password: "%password_hash%"  Stored Password: "%stored_password_hash%"
    
    set "username_hash=%username_hash: =%"
    set "stored_username_hash=%stored_username_hash: =%"
    set "password_hash=%password_hash: =%"
    set "stored_password_hash=%stored_password_hash: =%"

    if "%username_hash%" EQU "%stored_username_hash%" (
        echo Username Matches
        if "%password_hash%" EQU "%stored_password_hash%" (
            echo Password Matches
            del %TEMP%\username.txt > nul
            del %TEMP%\password.txt > nul
            del %TEMP%\username_hash.txt > nul
            del %TEMP%\password_hash.txt > nul
            goto file.check
        ) else (
            echo Authentication failed. Password does not match.
            del %TEMP%\username.txt > nul
            del %TEMP%\password.txt > nul
            del %TEMP%\username_hash.txt > nul
            del %TEMP%\password_hash.txt > nul
            echo Credentials do not match!
            pause
            goto login.input
        )
    ) else (
        echo Authentication failed. Username does not match.
        del %TEMP%\username.txt > nul
        del %TEMP%\password.txt > nul
        del %TEMP%\username_hash.txt > nul
        del %TEMP%\password_hash.txt > nul
        echo Credentials do not match!
        pause
        goto login.input
    )    