@if "%debug_assist%"=="" @echo off
if "%OS%"=="Windows_NT" setlocal
set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
mode con: cols=140 lines=40
if "%restart-main%" == "1" dataspammer.bat
@title Script Installer by PIRANY
set "foldername=DataSpammer"
set "current-script-version=v4.3"
cd /d %~dp0
color 2
cls  
color 2
        if "%1"=="go" goto custom.go
        if "%1"=="-reverse.arg" dataspammer.bat %2

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
    call :sys.lt 1
    echo You can either delete The Script from here or you can open the main script
    call :sys.lt 1
    echo You can install the Script to antother Directory too.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Open the Main Script
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Delete Script (Script need to run as Administator!)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] Reinstall Script
    set /p installer.executed.menu=Choose an Option from above
    
    if %installer.executed.menu%=="" goto sys.installer.execution.finished
    If %installer.executed.menu% == 1 dataspammer.bat
    If %installer.executed.menu% == 2 goto delete.script.confirmation.window
    If %installer.executed.menu% == 3 goto installer.main.window
    goto sys.installer.execution.finished

:delete.script.confirmation.window
    :: Delete Script TLI
    echo. 
    call :sys.lt 1
    echo You are about to delete the whole script.
    call :sys.lt 1 
    echo Are you sure about this decision?
    call :sys.lt 1
    echo If the script is bugged or you want to download the new Version please 
    call :sys.lt 1
    echo Visit the GitHub Repo
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
    echo [3] No Please Go back
    call :sys.lt 1
    echo.
    echo.
    set /p delete.script.menu=Choose an Option from Above

    if %delete.script.menu%=="" goto delete.script.confirmation.window
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

:sys.verify.execution
    :: Script isnt elevated TLI
    echo Please start the Script as Administrator in order to install.
    echo To do this right click the install.bat File and click "Run As Administrator"
    pause
    exit

:delete.script.confirmed.2
    :: Delete Script 
    if exist "%~dp0\LICENSE" erase "%~dp0\LICENSE" > nul
    echo 1/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\README.md" erase "%~dp0\README.md" > nul
    echo 2/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\dataspammer.bat" erase "%~dp0\dataspammer.bat" > nul
    echo 3/7 Files Deleted
    call :sys.lt 1
    if exist "%~dp0\install.bat" erase "%~dp0\install.bat" > nul
    echo 4/7 Files Deleted
    cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
    if exist "autostart.bat" erase "autostart.bat" > nul
    echo 5/7 Files Deleted
    call :sys.lt 1
    cd /d %userprofile%\Desktop
    if exist "Dataspammer.bat" erase "Dataspammer.bat" > nul
    echo 6/7 Files Deleted
    call :sys.lt 1
    set "startMenuPrograms=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    cd /d %startMenuPrograms%
    if exist "Dataspammer.bat" erase "Dataspammer.bat" > nul
    echo 7/7 Files Deleted
    echo Uninstall Successfull

:installer.main.window
    if exist "%temp%\progress.txt" goto standart.install.run.1 
    cls
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
    call :sys.lt 1
    echo This Installer will lead you throuh the Process of Installing the DataSpammer Utility.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [1] Normal Install  (Recommended, Needs Administrator Priviliges)
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Small Install (WITHOUT Updater, Settings and some less-important Features)
    echo. 
    call :sys.lt 1
    echo.
    echo.
    call :sys.lt 1
    set /P installer.main=Choose an Option from Above:
    if %installer.main% =="" goto installer.main.window
    if %installer.main% == 2 goto installer.custom.install.directory
    if %installer.main% == 1 goto standart.install.run
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
        echo. goto.elevate "%temp%\progress.txt" > nul
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
    call :sys.lt 1
    echo [1] Open Tutorial on how to turn off AV
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] Go back
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [3] My AV is turned off!
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [4] Close the Script
    set /P avturnoff=Choose an Option from above

    if %avturnoff% =="" goto standart.install.run.3
    if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" & cls & goto standart.install.run.3
    if %avturnoff% == 2 cls & goto installer.main.window
    if %avturnoff% == 3 cls & goto standart.install.run.4
    if %avturnoff% == 4 cls & goto cancel
    goto standart.install.run.3
:standart.install.run.4
    :: Default Install Options TLI
    echo The Script will install itself in the Following Directory: %ProgramFiles%
    call :sys.lt 1
    echo For Better Accessibility of the Script you can create for example a Startmenu Shortcut or a Desktop Shortcut
    call :sys.lt 1
    echo Please note that you need to reinstall those if you move the Script into another Folder.
    call :sys.lt 1
    echo Please Choose the Options you want to install:
    call :sys.lt 1
    echo Sometimes they get detected by Antivirus and get deleted.
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
    set /P stdprogdrcvar=Choose the Options from Above:
    if %stdprogdrcvar% =="" goto standart.install.run.4
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
    call :sys.lt 1
    echo Please specify the Directory where the Script should be installed.
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo It can be any Directory as long as you have write/read access to it.
    call :sys.lt 1
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
    dataspammer.bat

:installer.updater.installation.confirm
    :: Updater Install TLI
    echo.
    call :sys.lt 1
    echo Do you want the Script to automaticcaly scan for Updates on every start?
    echo This will be fully automaticly.
    call :sys.lt 1
    echo [1] Yes
    call :sys.lt 1
    echo.
    call :sys.lt 1
    echo [2] No
    echo.
    call :sys.lt 1
    echo.
    set /p install.updater=Choose an Option from Above:
    if %install.updater% =="" goto installer.updater.installation.confirm
    If %install.updater% == 1 set "gitinsyn=1"
    If %install.updater% == 2 goto installer.start.copy

:installer.start.copy
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
    set "elevation=pwsh"
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
        echo :: Elevation Method used (pwsh / sudo)
        echo elevation=%elevation%
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
    set "elevation=pwsh"
    
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
        echo :: Elevation Method used (pwsh / sudo)
        echo elevation=%elevation%
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
    echo Dow you want to delete the LICENSE and README files?
    call :sys.lt 1
    echo.
    echo [1] List content of README
    call :sys.lt 1
    echo.
    echo [2] List content of LICENSE
    call :sys.lt 1
    echo.
    echo [3] Delete LICENSE
    call :sys.lt 1
    echo.
    echo [4] Delete README
    call :sys.lt 1
    echo.
    echo [5] Copy in Script Folder
    call :sys.lt 1
    echo.
    echo [6] Done/Skip
    echo.
    call :sys.lt 1
    echo.
    set /p RL.menu=Select an Answer from above
    if %RL.menu% =="" goto additionals.ask.window
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
    )
    pause
    goto additionals.ask.window

:delete.license
    :: delete the license
    if exist "%~dp0\LICENSE" ( erase "%~dp0\LICENSE" > nul )
    goto additionals.ask.window

:delete.readme
    :: Delete readme 
    if exist "%~dp0\README.md" ( erase "%~dp0\README.md" > nul )
    goto additionals.ask.window

:sys.main.installer.done
    :: Cleanup install directory and finish the installation
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

:update_config
    :: Example for Interactive Change
    :: call :update_config "default-filename" "Type in the Filename you want to use." ""
    
    :: Example for Automated Change
    :: call :update_config "logging" "" "1"
    

    :: call :update_config "1" "2" "3"
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

:sys.lt
    set "dur=%1"
    @ping -n %dur% localhost> nul
    exit /b 0

:verify
    set "verify=%random%"
    powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter Code %verify% to confirm that you want to execute this Option', 'DataSpammer Verify')}" > %TEMP%\out.tmp
    set /p OUT=<%TEMP%\out.tmp
    if not defined OUT goto failed
    if %verify%==%OUT% (goto success) else (goto failed)

:success
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sucess', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    exit /b

:failed
    set msgBoxArgs="& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You have entered the wrong Code. Please try again', 'DataSpammer Verify');}"
    powershell -Command %msgBoxArgs%
    goto verify

:restart.script
    cd /d %~dp0
    install.bat


exit /b 0
