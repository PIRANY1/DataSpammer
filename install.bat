@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto normal.start) else (goto dev.options)
:normal.start
chcp 65001
if "%restart-main%" == "1" goto sys.open.main.script
@title Script Installer by PIRANY
set "foldername=DataSpammer"
set "current-script-version=v3.2"
cd /d %~dp0
color 2
cls  
color 2
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
    set /P updateinstalledvar=Choose an Option from above
    if %updateinstalledvar% == 1 goto sys.open.main.script
    if %updateinstalledvar% == 2 goto cancel
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
    set /p insdone123=Choose an Option from above
    
    If %insdone123% == 1 goto sys.open.main.script
    If %insdone123% == 2 goto open.settings.dts
    If %insdone123% == 3 goto delete.script.confirmation.window
    If %insdone123% == 4 goto installer.main.window
    If %insdone123% == 6 goto sys.add.developer.tool
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
    set /p delscrconf=Choose an Option from Above

    If %delscrconf% == 1 goto delete.script.verify
    If %delscrconf% == 2 start "" "https://github.com/PIRANY1/DataSpammer" && goto delete.script.confirmation.window
    If %delscrconf% == 3 goto open.install.done
    goto delete.script.confirmation.window


:open.settings.dts
    :: Open Settings in Main Script
    set "settingsmainscriptvar=1"
    goto sys.open.main.script

:delete.script.verify
    call :verify
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto delete.script.confirmed.2) else (goto sys.verify.execution)

:delete.script.confirmed.2
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
    echo Please turn the CMD Windows to FullScreen. The Graphics will only be then displayed correctly.
    @ping -n 1 localhost> nul
    echo This Installer will lead you throuh the Process of Installing the DataSpammer.
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
    set /P programdrccustom=Choose an Option from Above:
    if %programdrccustom% == 2 goto installer.custom.install.directory
    if %programdrccustom% == 1 goto standart.install.run
    goto installer.main.window

:standart.install.run
    :: Some Pre-Install STuff
    set "directory=%ProgramFiles%"
    cd /d "%directory%"
:standart.install.run.1
    :: Check if script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto standart.install.run.2) else (goto sys.verify.execution)
:standart.install.run.2
    :: Preset some Variables
    set "startmenushortcut=Not Included"
    set "desktopic=Not Included"
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
    echo [2] (%desktopic%) Desktop Shortcut
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
    set "desktopic=Included"
    set "desktopic1=1"
    goto standart.install.run.4

:n3varinst
    cls
    set "autostart=Included"
    set "autostart1=1"
    goto standart.install.run.4


:installer.custom.install.directory
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
    del dataspammer.bat
    cd /d DataSpammer
    echo small-install > settings.conf
    cd /d %~dp0
    echo Do you want to copy the README into the Script Folder too or should it be deleted?
    choice /C DC /M "Press D If you want to Delete README and C to Copy it into the Script folder"
    set _erl=%errorlevel%
    if %_erl%==D del README.md
    if %_erl%==C xcopy "README.md" "%install-directory%\DataSpammer"
    echo Installation Done.
    cd /d DataSpammer 
    del %install-directory%\install.bat
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
    set /p menu3=Choose an Option from Above:
    If %menu3% == 1 set "gitinsyn=1"
    If %menu3% == 2 goto installer.start.copy

:installer.start.copy
    :: Main install part
    set "directory9=%directory%\%foldername%"
    mkdir "%directory9%" 
    xcopy "%~dp0\dataspammer.bat" "%directory9%" 
    xcopy "%~dp0\install.bat" "%directory9%"     

:installer.start.settings
    cd /d "%directory9%"
    :: Create settings.conf
    setlocal enabledelayedexpansion
    set "insdonevar=insdone"
    set "stdfil=notused"
    set "stdrcch=notused"
    set "update=notused"
    set "file=settings.conf"
    echo !insdonevar! >> %file%
    echo !stdfil! >> %file%
    echo !stdrcch! >> %file%
    echo !update! >> %file%
    echo Settings.conf was created.
    cd /d %~dp0
    del dataspammer.bat
    cd /d "%directory9%"

:installer.copy.settings.done
    :: Check if there where errors installing the base script
    if %errorlevel% equ 0 (
        echo Success.
        cls
        goto check.if.updater.install
    ) else (
        echo There was an Error.
        echo Please Restart the Script.
        pause
        goto cancel
    )

:check.if.updater.install
    if defined gitinsyn (
        goto installer.common.drc.switch
    ) else (
        goto additionals.ask.window
    )


:installer.common.drc.switch
    cd /d "%directory9%"
    
:installer.start.template
    :: Write Settings Template
    set "line1=insdone"
    set "line2=notused"
    set "line3=notused"
    set "line4=uy"
    set "setfile=settings.conf"
    if exist !setfile! (
        del !setfile!
    )
    (
        echo !line1!
        echo !line2!
        echo !line3!
        echo !line4!
    ) > !setfile!
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
    echo dataspammer.bat
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
    set /p ynins1=Select an Answer from above
    If %ynins1% == 1 goto list.content.LC
    If %ynins1% == 2 goto list.content.RD
    If %ynins1% == 3 goto delete.license
    If %ynins1% == 4 goto delete.readme
    If %ynins1% == 5 goto copy.rl.to.script
    If %ynins1% == 6 goto sys.main.installer.done
    goto additionals.ask.window

:copy.rl.to.script
    :: RL refers to Readme License
    :: Copy readme and license to install directory
    if exist "%~dp0\LICENSE" xcopy "%~dp0\LICENSE" "%directory%\%foldername%\%current-script-version%" > nul
    if exist "%~dp0\README.md" xcopy "%~dp0\README.md" "%directory%\%foldername%\%current-script-version%" > nul  
    del %~dp0\LICENSE
    del %~dp0\README.md
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
        del "%~dp0\LICENSE"
    ) else (
        goto additionals.ask.window
    )
    goto additionals.ask.window
:delete.readme
    :: Delete readme 
    if exist "%~dp0\README.md" (
        del "%~dp0\README.md"
    ) else (
        goto additionals.ask.window
    )
    goto additionals.ask.window

:sys.main.installer.done
    :: Cleanup install directory and finish the installation
    echo Finishing Installation....
    cd /d %~dp0
    del install.bat
    cd /d "%directory9%"
    goto sys.open.main.script

:cancel
    :: When the Install got canceled
    echo The installer is now closing....
    @ping -n 2 localhost> nul
    exit

:dev.options 
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
    set /P devoption=Choose an Option From Above.
    if %devoption% == 1 goto dev.jump.callsign
    if %devoption% == 2 goto dev.options
    if %devoption% == 3 @ECHO ON && goto normal.start
    if %devoption% == 4 goto dev.custom.var.set 
    if %devoption% == 5 restart.script.dev
    if %devoption% == 6 restart.script
    goto dev.options
    
    :dev.jump.callsign
    set /P jump-to-call-sign=Enter a Call Sign:
    goto %jump-to-call-sign%

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