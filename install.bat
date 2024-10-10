@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto normal.start) else (goto dev.options)
:normal.start
mode con: cols=120 lines=30
if "%restart-main%" == "1" goto sys.open.main.script
@title Script Installer by PIRANY
set "foldername=DataSpammer"
set "current-script-version=v3.5"
cd /d %~dp0
color 2
cls  
color 2
    if "%1"=="-dev.secret" goto dev.options
    if "%1"=="-reverse.arg" dataspammer.bat %2

:script.install.check
    :: Check if Script started after an update
    if "%update-install%"=="1" (
        goto sys.new.update.installed
    ) else (
        goto open.install.done
    )
:sys.verify.execution
    :: Script isnt elevated TLI
    echo Please start the Script as Administrator in order to install.
    echo To do this right click the install.bat File and click "Run As Administrator"
    pause
    exit


:sys.new.update.installed
    cd /d %~dp0
    erase updater.bat
    :: Update Installed TLI
    echo Update was Successful!
    @ping -n 1 localhost> nul
    echo Updated from %current-script-version% to %latest_version%
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Open Script
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Exit
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /P update.installed.menu=Choose an Option from above
    if "%update.installed.menu%"=="" goto sys.new.update.installed
    if %update.installed.menu% == 1 goto sys.open.main.script
    if %update.installed.menu% == 2 goto cancel
    goto sys.new.update.installed


:open.install.done
    :: Check if Settings Exist
    if exist "settings.conf" (
        goto sys.installer.execution.finished
    ) else (
        goto installer.main.window
    )
:sys.installer.execution.finished
    :: Installer Was Executed TLI
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
    echo [3] Delete Script (Script need to run as Administator!)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Reinstall Script
    set /p installer.executed.menu=Choose an Option from above
    
    if "%installer.executed.menu%"=="" goto sys.installer.execution.finished
    If %installer.executed.menu% == 1 goto sys.open.main.script
    If %installer.executed.menu% == 2 goto open.settings.dts
    If %installer.executed.menu% == 3 goto delete.script.confirmation.window
    If %installer.executed.menu% == 4 goto installer.main.window
    If %installer.executed.menu% == 6 goto sys.add.developer.tool
    goto sys.installer.execution.finished

:sys.add.developer.tool
    :: Add the DevTool - Currently Hidden due to missing Features
    (
    echo :topp
    echo @echo off
    echo cd /d %%~dp0
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
    echo gg
    pause
    exit

:delete.script.confirmation.window
    :: Delete Script TLI
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
    set /p delete.script.menu=Choose an Option from Above

    if "%delete.script.menu%"=="" goto delete.script.confirmation.window
    If %delete.script.menu% == 1 goto delete.script.verify
    If %delete.script.menu% == 2 start "" "https://github.com/PIRANY1/DataSpammer" && goto delete.script.confirmation.window
    If %delete.script.menu% == 3 goto open.install.done
    goto delete.script.confirmation.window


:open.settings.dts
    :: Open Settings in Main Script
    cd /d %~dp0
    dataspammer.bat settings

:delete.script.verify
    call :verify
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto delete.script.confirmed.2) else (goto sys.verify.execution)

:delete.script.confirmed.2
    :: Delete Script 
    if exist "%~dp0\LICENSE" erase "%~dp0\LICENSE" > nul
    echo 1/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\README.md" erase "%~dp0\README.md" > nul
    echo 2/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\dataspammer.bat" erase "%~dp0\dataspammer.bat" > nul
    echo 3/7 Files Deleted
    @ping -n 1 localhost> nul
    if exist "%~dp0\install.bat" erase "%~dp0\install.bat" > nul
    echo 4/7 Files Deleted
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    if exist "autostart.bat" erase "autostart.bat" > nul
    echo 5/7 Files Deleted
    @ping -n 1 localhost> nul
    cd /d %userprofile%\Desktop
    if exist "Dataspammer.bat" erase "Dataspammer.bat" > nul
    echo 6/7 Files Deleted
    @ping -n 1 localhost> nul
    set "startMenuPrograms=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    cd /d %startMenuPrograms%
    if exist "Dataspammer.bat" erase "Dataspammer.bat" > nul
    echo 7/7 Files Deleted
    echo Uninstall Successfull

:installer.main.window
    :: Main install TLI
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
    echo This Installer will lead you throuh the Process of Installing the DataSpammer Utility.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Normal Install  (Recommended, Needs Administrator Priviliges)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Small Install (WITHOUT Updater, Settings and some less-important Features)
    echo. 
    @ping -n 1 localhost> nul
    echo.
    echo.
    @ping -n 1 localhost> nul
    set /P installer.main=Choose an Option from Above:
    if "%installer.main%"=="" goto installer.main.window
    if "%installer.main%" == 2 goto installer.custom.install.directory
    if "%installer.main%" == 1 goto standart.install.run
    goto installer.main.window

:standart.install.run
    call :verify
    :: Some Pre-Install STuff
    set "directory=%ProgramFiles%"
    cd /d "%directory%"
:standart.install.run.1
    setlocal EnableDelayedExpansion
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo Script will request Administrator Rights.
        @ping -n 2 localhost> nul
        powershell -Command "Start-Process '%~f0' -Verb runAs"
        exit
    )

:standart.install.run.2
    :: Preset some Variables
    set "startmenushortcut=Not Included"
    set "desktopicon=Not Included"
    set "autostart=Not Included"
:standart.install.run.3
    :: AV Deactivate TLI
    echo These extra Files get detected as a Virus from some antivirus Programs. 
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

    if "%avturnoff%"=="" goto standart.install.run.3
    if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" & cls & goto standart.install.run.3
    if %avturnoff% == 2 cls & goto installer.main.window
    if %avturnoff% == 3 cls & goto standart.install.run.4
    if %avturnoff% == 4 cls & goto cancel
    goto standart.install.run.3
:standart.install.run.4
    :: Default Install Options TLI
    echo The Script will install itself in the Following Directory: %ProgramFiles%
    @ping -n 1 localhost> nul
    echo For Better Accessibility of the Script you can create for example a Startmenu Shortcut or a Desktop Shortcut
    @ping -n 1 localhost> nul
    echo Please note that you need to reinstall those if you move the Script into another Folder.
    @ping -n 1 localhost> nul
    echo Please Choose the Options you want to install:
    @ping -n 1 localhost> nul
    echo Sometimes they get detected by Antivirus and get deleted.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] (%startmenushortcut%) Startmenu Shortcut/All Apps List 
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo [2] (%desktopicon%) Desktop Shortcut
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo [3] (%autostart%) Start with Windows/Autostart
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] Done/Skip
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [5] De-select / Cancel Options
    set /P stdprogdrcvar=Choose the Options from Above:
    if "%stdprogdrcvar%"=="" goto standart.install.run.4
    if %stdprogdrcvar% == 1 goto n1varinst
    if %stdprogdrcvar% == 2 goto n2varinst
    if %stdprogdrcvar% == 3 goto n3varinst
    if %stdprogdrcvar% == 4 goto installer.updater.installation.confirm
    if %stdprogdrcvar% == 5 goto standart.install.run
    goto standart.install.run


:n1varinst
    cls
    set "startmenushortcut=Included"
    set "startmenushortcut1=1"
    goto standart.install.run.4

:n2varinst
    cls
    set "desktopicon=Included"
    set "desktopic1=1"
    goto standart.install.run.4

:n3varinst
    cls
    set "autostart=Included"
    set "autostart1=1"
    goto standart.install.run.4


:installer.custom.install.directory
    call :verify
    set "small-install=1"
    :: Script Install Location
    @ping -n 1 localhost> nul
    echo Please specify the Directory where the Script should be installed.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo It can be any Directory as long as you have write/read access to it.
    @ping -n 1 localhost> nul
    set /p directory=Type Your Directory Here: 
    :: Installer Confirmation Dialog
    call :verify


:small.installer
    echo Installing Script...
    cd /d %~dp0
    mkdir DataSpammer
    set "install-directory=%cd%"
    xcopy dataspammer.bat "%install-directory%\DataSpammer"
    erase dataspammer.bat > nul
    cd /d DataSpammer
    echo small-install > settings.conf
    cd /d %~dp0
    echo Do you want to copy the README into the Script Folder too or should it be deleted?
    choice /C DC /M "Press D If you want to Delete README and C to Copy it into the Script folder"
    set _erl=%errorlevel%
    if %_erl%==D erase README.md > nul
    if %_erl%==C xcopy "README.md" "%install-directory%\DataSpammer"
    echo Installation Done.
    cd /d DataSpammer 
    erase %install-directory%\install.bat > nul
    goto sys.open.main.script

:installer.updater.installation.confirm
    :: Updater Install TLI
    echo.
    @ping -n 1 localhost> nul
    echo Do you want the Script to automaticcaly scan for Updates on every start?
    echo This will be fully automaticly.
    @ping -n 1 localhost> nul
    echo [1] Yes
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] No
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /p install.updater=Choose an Option from Above:
    if "%install.updater%"=="" goto installer.updater.installation.confirm
    If "%install.updater%" == 1 set "gitinsyn=1"
    If "%install.updater%" == 2 goto installer.start.copy

:installer.start.copy
    :: Main install part
    set "directory9=%directory%\%foldername%"
    mkdir "%directory9%" 
 
    cd /d %~dp0
    erase readme.md > nul   
    erase license > nul
    curl -so license https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/license
    curl -so readme.md https://raw.githubusercontent.com/PIRANY1/DataSpammer/refs/heads/beta/readme.md
    erase dataspammer.bat > nul
    cd /d "%directory9%"
    curl -so dataspammer.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/dataspammer.bat > nul
    curl -so install.bat https://raw.githubusercontent.com/PIRANY1/DataSpammer/main/install.bat > nul

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


    

:installer.start.settings
    :: Create settings.conf
    setlocal enabledelayedexpansion
    
    cd /d "%directory9%"
    set "default.filename=notused"
    set "default.directory=notused"
    set "update=0"
    set "logging=0"
    set "dev.mode=0"
    set "default-filecount=notused"
    set "default-domain=notused"
    (
        echo :: DataSpammer configuration
        echo :: Standart Filename
        echo default_filename=%default.filename%
        echo :: Standart Directory
        echo default_directory=%default.directory%
        echo :: Check for Updates
        echo update=%update%
        echo :: Logging is on by default
        echo logging=%logging%
        echo :: Developer Mode
        echo developermode=%dev.mode%
        echo :: Default Filecount
        echo default-filecount=%default-filecount%
        echo :: Default Domain
        echo default-domain=%default-domain%
    ) > settings.conf
    

:check.if.updater.install
    if defined gitinsyn (
        goto installer.common.drc.switch
    ) else (
        goto additionals.ask.window
    )


:installer.common.drc.switch
    :: Write Settings.conf with Update
    setlocal enabledelayedexpansion
    cd /d "%directory9%"
    set "stdfile=notused"
    set "stdrcch=notused"
    set "update=1"
    set "logging=1"
    set "dev.mode=0"
    set "default-filecount=notused"
    set "default-domain=notused"
    
    (
        echo :: DataSpammer configuration
        echo :: Standart Filename
        echo default_filename=%stdfile%
        echo :: Standart Directory
        echo default_directory=%stdrcch%
        echo :: Check for Updates
        echo update=%update%
        echo :: Logging is on by default
        echo logging=%logging%
        echo :: Developer Mode
        echo developermode=%dev.mode%
        echo :: Default Filecount
        echo default-filecount=%default-filecount%
        echo :: Default Domain
        echo default-domain=%default-domain%
    ) > settings.conf
    
    cd /d %~dp0
    goto install.additional.links
    

:install.additional.links
    cd /d "%directory9%"
    set varlinkauto=%cd%
    if defined startmenushortcut1 (goto start.menu.icon.setup) else (goto desktop.icon.install.check)
:start.menu.icon.setup
    :: Install Startmenu
    cd /d "%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    (
    echo @echo off
    echo cd /d %varlinkauto%
    echo dataspammer.bat
    ) > DataSpammer.bat
    echo Added Startmenu Shortcut
:desktop.icon.install.check
    if defined desktopic (goto desktop.icon.install) else (goto script.win.start.check)
:desktop.icon.install
    :: Desktop-IC Installer
    cd /d %userprofile%\Desktop
    (
    echo @echo off
    echo cd /d %varlinkauto%
    echo dataspammer.bat %1 %2 %3 %4 %5
    ) > DataSpammer.bat
    echo Added Desktop Shortcut                                                                                              
:script.win.start.check
    if defined autostart (goto script.win.start.setup) else (goto additional.links.installed)
:script.win.start.setup
    :: Autostart Installer
    echo The Setup for Autostart is now starting...
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    (
    echo @echo off
    echo cd /d %varlinkauto%
    echo dataspammer.bat
    ) > autostart.bat
    cd /d %~dp0
    echo Added Autostart Shortcut!
    goto additional.links.installed
:additional.links.installed
    :: Display a Finish Message
    echo Done!
    echo You might need to restart your Device in order for all changes to apply.
    pause 
	goto additionals.ask.window



:additionals.ask.window
    :: TLI for Readme and LICENSE
    color 02
    echo Dow you want to delete the LICENSE and README files?
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
    echo [5] Copy in Script Folder
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [6] Done/Skip
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /p RL.menu=Select an Answer from above
    if "%RL.menu%"=="" goto additionals.ask.window
    If %RL.menu% == 1 goto list.content.LC
    If %RL.menu% == 2 goto list.content.RD
    If %RL.menu% == 3 goto delete.license
    If %RL.menu% == 4 goto delete.readme
    If %RL.menu% == 5 goto copy.rl.to.script
    If %RL.menu% == 6 goto sys.main.installer.done
    goto additionals.ask.window

:copy.rl.to.script
    :: RL refers to Readme License
    :: Copy readme and license to install directory
    if exist "%~dp0\LICENSE" xcopy "%~dp0\LICENSE" "%directory%\%foldername%\%current-script-version%" > nul
    if exist "%~dp0\README.md" xcopy "%~dp0\README.md" "%directory%\%foldername%\%current-script-version%" > nul  
    erase %~dp0\LICENSE > nul
    erase %~dp0\README.md > nul
    goto sys.main.installer.done

:list.content.LC
    :: List the Content of LICENSE
    set "liscensefad=%~dp0\LICENSE"
    
    if exist "%liscensefad%" (
        for /f "tokens=*" %%a in (%liscensefad%) do (
            echo %%a
        )
    ) else (
        echo Error. Please open LICENSE manually.
    )
    pause
    goto additionals.ask.window

:list.content.RD
    :: List the Content of readme
    set "liscensefad1=%~dp0\README.md"
    
    if exist "%liscensefad1%" (
        for /f "tokens=*" %%a in (%liscensefad1%) do (
            echo %%a
        )
    ) else (
        echo Error. Please open README manually.
    )
    pause
    goto additionals.ask.window

:delete.license
    :: delete the license
    if exist "%~dp0\LICENSE" (
        erase "%~dp0\LICENSE" > nul
    ) else (
        goto additionals.ask.window
    )
    goto additionals.ask.window
:delete.readme
    :: Delete readme 
    if exist "%~dp0\README.md" (
        erase "%~dp0\README.md" > nul
    ) else (
        goto additionals.ask.window
    )
    goto additionals.ask.window

:sys.main.installer.done
    :: Cleanup install directory and finish the installation
    echo Finishing Installation....
    cd /d %~dp0
    erase install.bat > nul
    cd /d "%directory9%"
    dataspammer.bat

:cancel
    :: When the Install got canceled
    echo The installer is now closing....
    @ping -n 2 localhost> nul
    exit

:dev.options 
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
    set /P dev.option=Choose an Option From Above.
    if "%devoption%" == "" goto dev.options 
    if "%devoption%" == 1 goto dev.jump.callsign
    if "%devoption%" == 2 goto dev.options
    if "%devoption%" == 3 @ECHO ON && goto normal.start
    if "%devoption%" == 4 goto dev.custom.var.set 
    if "%devoption%" == 5 restart.script.dev
    if "%devoption%" == 6 restart.script
    goto dev.options
    
    :dev.jump.callsign
    echo In which Script you want go to
    echo [1] DataSpammer.bat
    echo [2] Install.bat
    echo. 
    set /P callsign.custom=Choose an Option from Above:
    if %callsign.custom% == 1 goto dev.jump.callsign.dts
    if %callsign.custom% == 2 goto dev.jump.callsign.install
    goto dev.jump.callsign


    :dev.jump.callsign.install
    set /P jump-to-call-sign=Enter a Call Sign:
    goto %jump-to-call-sign%


    :dev.jump.callsign.dts
    cd /d %~dp0
    set /P jump-to-call-sign=Enter a Call Sign:
    dataspammer.bat go %jump-to-call-sign%

    :sys.open.main.script
        dataspammer.bat

:verify
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
    goto verify

:restart.script.dev
    cd /d %~dp0
    goto normal.start
:restart.script
    cd /d %~dp0
    install.bat

exit 0