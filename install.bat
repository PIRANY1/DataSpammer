@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto nodev) else (goto dtd)
:nodev
@title Script Installer by PIRANY
set "foldername=DataSpammerbyPIRANY"
set "gitver12=v2.6"
cd %~dp0
color 2
cls  
color 2
:gitupdtcheck
    :: Check if Script started after an update
    if "%setupaftgitcl%"=="1" (
        goto updateinstall
    ) else (
        goto instdone100
    )

:noelev
    :: Script isnt elevated TLI
    echo Please start the Script as Administrator in order to install.
    echo To do this right click the install.bat File and click "Run As Administrator"
    pause
    exit

:updateinstall
    :: Install the Update
    cd %~dp0
    set "target_dir=%cd%""
    set "source_dir=%source_dir_start%"
    copy %source_dir%\settings.txt %target_dir%
    cd %~dp0
:updateinstalled
    :: Update Installed TLI
    echo Update was Successful!
    @ping -n 1 localhost> nul
    echo Updated from %gitver12% to %latest_version%
    @ping -n 1 localhost> nul
    echo Do you want to delete the Files from the old Version? (no Data will get deleted!)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Yes delete the old Version Files
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] No just open the Script
    @ping -n 1 localhost> nul
    echo.
    echo.
    set /P updateinstalledvar=Choose an Option from above
    if %updateinstalledvar% == 1 goto deleteoldfiles
    if %updateinstalledvar% == 2 dataspammer.bat
    goto updateinstalled

:deleteoldfiles
    :: Delete Old Versions
    cd %~dp0
    cd .. 
    rmdir /s /q %gitverold%
    echo Old Files deleted!
    pause
    cd %~dp0
    dataspammer.bat

:instdone100
    :: Check if Settings Exist
    if exist "settings.txt" (
        goto instdoneconf
    ) else (
        goto instmain
    )
:instdoneconf
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
    
    If %insdone123% == 1 dataspammer.bat
    If %insdone123% == 2 goto settingsmainscript
    If %insdone123% == 3 goto delscriptconf
    If %insdone123% == 4 goto instmain
    If %insdone123% == 6 goto adddevtool
    goto instdoneconf

:adddevtool
    :: Add the DevTool - Currently Hidden due to missing Features
    (
    echo :topp
    echo @echo off
    echo cd %%~dp0
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

:delscriptconf
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

    If %delscrconf% == 1 goto delscriptconfy
    If %delscrconf% == 2 start "" "https://github.com/PIRANY1/DataSpammer" && goto delscriptconf 
    If %delscrconf% == 3 goto instdone100
    goto delscriptconf


:settingsmainscript
    :: Open Settings in Main Script
    set "settingsmainscriptvar=1"
    dataspammer.bat

:delscriptconfy
    :: Check if Script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto delscriptconfy2) else (goto noelev)

:delscriptconfy2
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
    cd %startMenuPrograms%
    if exist "Dataspammer.bat" del "Dataspammer.bat"
    echo 7/7 Files Deleted
    echo Uninstall Successfull
:instmain
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
    echo [1] Install in Custom Directory (For Experienced Users)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Install In the Default Programm Directory (Needs to run as Administrator)
    echo. 
    @ping -n 1 localhost> nul
    echo.
    echo.
    @ping -n 1 localhost> nul
    set /P programdrccustom=Choose an Option from Above:
    if %programdrccustom% == 1 goto customdirectory
    if %programdrccustom% == 2 goto stdprogdrc
    goto instmain

:stdprogdrc
    :: Some Pre-Install STuff
    set "directory=%ProgramFiles%"
    set "chdircheck=0"
    for /f %%A in ("!directory!") do (
    set "chdircheck=1"
    goto chdircheck4
    )
:chdircheck4
    :: check if directory contains a space - WHYYYY
    if !chdircheck! equ 1 (
        chdir %directory%
        goto stdprogdrc4
    ) else (
        cd /d %directory%
        goto stdprogdrc4
    )
:stdprogdrc4
    :: Check if script is elevated
    setlocal enableextensions ENABLEDELAYEDEXPANSION 
    net session >nul 2>&1
    if %errorLevel% == 0 (goto stdprogdrc3) else (goto noelev)
:stdprogdrc3
    :: Preset some Variables
    set "startmenushortcut=Not Included"
    set "desktopic=Not Included"
    set "autostart=Not Included"
:stdprogdrc1
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
    if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" & cls & goto stdprogdrc1
    if %avturnoff% == 2 cls & goto instmain
    if %avturnoff% == 3 cls & goto stdprogdrc2
    if %avturnoff% == 4 cls & goto cancel
    goto stdprogdrc1
:stdprogdrc2
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
    echo [1] %startmenushortcut% Startmenu Shortcut/All Apps List 
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo [2] %desktopic% Desktop Shortcut
    @ping -n 1 localhost> nul
    echo. 
    @ping -n 1 localhost> nul
    echo [3] %autostart% Start with Windows/Autostart
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
    if %stdprogdrcvar% == 4 goto gitins
    if %stdprogdrcvar% == 5 goto stdprogdrc
    goto stdprogdrc


    :n1varinst
    cls
    set "startmenushortcut=Included"
    set "startmenushortcut1=1"
    goto stdprogdrc2

    :n2varinst
    cls
    set "desktopic=Included"
    set "desktopic1=1"
    goto stdprogdrc2

    :n3varinst
    cls
    set "autostart=Included"
    set "autostart1=1"
    goto stdprogdrc2


:customdirectory
    :: Script Install Location
    @ping -n 1 localhost> nul
    echo Please specify the Directory where the Script should be installed.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo It can be any Directory as long as you have write/read access to it.
    @ping -n 1 localhost> nul
    set /p directory=Type Your Directory Here: 
    set "chdircheck=0"
    for /f %%A in ("!directory!") do (
        set "chdircheck=1"
        goto chdircheck1
    )
:chdircheck1
    :: Check if the Directory contains a space - why?
    if !chdircheck! equ 1 (
        chdir %directory%
        goto drcsetch
    ) else (
        cd /d %directory%
        goto drcsetch
    )


:drcsetch
    :: Installer Confirmation Dialog
    @ping -n 1 localhost> nul
    echo Are you sure you want to run the installer and move the Files into the specified Directory?
    @ping -n 1 localhost> nul
    set /p ynins=[y]Yes [n]No:
    If %ynins% == n goto cancel
    If %ynins% == y goto gitins
    goto instmain

:gitins
    :: Updater Install TLI
    echo.
    @ping -n 1 localhost> nul
    echo When you want the script to auto upgrade itself when you start it you can install Git, JQ , Jid and Scoop automaticly too.
    echo This will be fully automaticly.
    echo When you choose to Install Git too it needs Administrator privileges too.
    echo.
    @ping -n 1 localhost> nul
    echo [1] Install those Too
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] View Information about Git
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [3] View Information about Jid
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [4] View Information about JQ
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [5] View Information about Scoop
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [6] Dont install those Components.
    echo.
    @ping -n 1 localhost> nul
    echo.
    set /p menu3=Choose an Option from Above:
    If %menu3% == 1 set "gitinsyn=1"
    If %menu3% == 2 start "" "https://git-scm.com" | goto gitins
    If %menu3% == 3 start "" "https://github.com/simeji/jid" | goto gitins
    If %menu3% == 4 start "" "https://jqlang.github.io/jq/" | goto gitins
    If %menu3% == 5 start "" "https://scoop.sh/#/" | goto gitins
    If %menu3% == 6 goto insgo

:insgo
    :: Main install part
    set "directory9=%directory%\%foldername%\%gitver12%"
    mkdir "%directory9%" 
    xcopy "%~dp0\dataspammer.bat" "%directory9%" 
    xcopy "%~dp0\install.bat" "%directory9%"     
    set "chdircheck=0"
    for /f %%A in ("!directory9!") do (
        set "chdircheck=1"
        goto chdircheck2
    )
:chdircheck2
    :: check if directory contains a space?!
    if !chdircheck! equ 1 (
        chdir %directory9%
        goto insgo2
    ) else (
        cd /d %directory9%
        goto insgo2
    )

:insgo2
    :: Create Settings.txt
    setlocal enabledelayedexpansion
    set "insdonevar=insdone"
    set "stdfil=notused"
    set "stdrcch=notused"
    set "update=notused"
    set "file=settings.txt"
    echo !insdonevar! >> %file%
    echo !stdfil! >> %file%
    echo !stdrcch! >> %file%
    echo !update! >> %file%
    echo Settings.txt was created.
    cd %~dp0
    del dataspammer.bat
    cd %directory9%

:insdone
    :: Check if there where errors installing the base script
    if %errorlevel% equ 0 (
        echo Success.
        cls
        goto jqgitins
    ) else (
        echo There was an Error.
        echo Please Restart the Script.
        pause
        goto cancel
    )

:jqgitins
    :: Check if Libs need to be installed
    if defined gitinsyn (
        goto jqgitins1
    ) else (
        goto direcdone
    )

:jqgitins1
    :: Install Libs - Rework Needed - Not Working
    for /f "delims=" %%a in ('where git') do (
        set "where_output=%%a"
    )
    if defined where_output (
        echo Git is already installed!
    ) else (
        winget install --id Git.Git -e --source winget
    )

    for /f "delims=" %%a in ('where scoop') do (
        set "where_output=%%a"
    )
    if defined where_output (
        echo Scoop is already installed!
    ) else (
        PowerShell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser"
        PowerShell -Command "iex (irm https://get.scoop.sh)"
    )

    for /f "delims=" %%a in ('where jq') do (
        set "where_output=%%a"
    )
    if defined where_output (
        echo jq is already installed!
    ) else (
        scoop install jq
    )
    
    for /f "delims=" %%a in ('where jid') do (
        set "where_output=%%a"
    )
    if defined where_output (
        echo jid is already installed!
    ) else (
        scoop install jid
    )

:addupdcheck
    :: What is this ahh code doin?!?!
    set "chdircheck=0"
    for /f %%A in ("!directory9!") do (
        set "chdircheck=1"
        goto chdircheck3
    )
:chdircheck3
    :: What is this for????????
    if !chdircheck! equ 1 (
        chdir %directory9%
        goto insgo3
    ) else (
        cd /d %directory9%
        goto insgo3
    )

:insgo3
    :: Write Settings Template
    set "line1=insdone"
    set "line2=notused"
    set "line3=notused"
    set "line4=uy"
    set "setfile=settings.txt"
    if exist !setfile! (
        del !setfile!
    )
    (
        echo !line1!
        echo !line2!
        echo !line3!
        echo !line4!
    ) > !setfile!
    goto additionalsadd

:additionalsadd
    cd %directory9%
    set varlinkauto=%cd%
    if defined startmenushortcut1 (goto startmenuiconsetup) else (goto desktopiccheck)
:startmenuiconsetup
    :: Install Startmenu
    cd %ProgramData%\Microsoft\Windows\Start Menu\Programs
    (
    echo @echo off
    echo cd /d %varlinkauto%
    echo dataspammer.bat
    ) > DataSpammer.bat
    echo Added Startmenu Shortcut
:desktopiccheck
    if defined desktopic (goto desktopiconsetup) else (goto autostartdeskic)
:desktopiconsetup
    :: Desktop-IC Installer
    cd /d %userprofile%\Desktop
    (
    echo @echo off
    echo cd /d %varlinkauto%
    echo dataspammer.bat
    ) > DataSpammer.bat
    echo Added Desktop Shortcut                                                                                              
:autostartdeskic
    if defined autostart (goto addautostart) else (goto additionalsdone)
:addautostart
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
    goto additionalsdone
:additionalsdone
    :: Display a Finish Message
    echo Done!
    echo You might need to restart your Device in order for all changes to apply.
    pause 
	goto direcdone



:direcdone
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
    If %ynins1% == 1 goto listlicense
    If %ynins1% == 2 goto listreadme
    If %ynins1% == 3 goto dellisence
    If %ynins1% == 4 goto delreadme
    If %ynins1% == 5 goto copyreadlic
    If %ynins1% == 6 goto instdone1
    goto direcdone

:copyreadlic
    :: Copy readme and license to install directory
    if exist "%~dp0\LICENSE" xcopy "%~dp0\LICENSE" "%directory%\%foldername%\%gitver12%%" > nul
    if exist "%~dp0\README.md" xcopy "%~dp0\README.md" "%directory%\%foldername%\%gitver12%%" > nul  
    del %~dp0\LICENSE
    del %~dp0\README.md
    goto instdone1

:listlicense
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
    goto direcdone

:listreadme
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
    goto direcdone

:dellisence
    :: delete the license
    if exist "%~dp0\LICENSE" (
        del "%~dp0\LICENSE"
    ) else (
        goto direcdone
    )
    goto direcdone

:delreadme
    :: Delete readme 
    if exist "%~dp0\README.md" (
        del "%~dp0\README.md"
    ) else (
        goto direcdone
    )
    goto direcdone

:instdone1
    :: TLI for PATH
    cls
    echo Do you want to add the Script to PATH?
    @ping -n 1 localhost> nul
    echo Then you can open the Script by typing "dataspammer" in the Command Shell.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Yes (Needs to run as Administrator)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] No.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    set /P pathansw=Choose an Option from Above:
    if %pathansw% == 1 goto addpath
    if %pathansw% == 2 goto installerdone

:addpath
    :: Untested Unstable Ahh Code with a 0% chance of working accurately
    @echo off
    cd %~dp0
    (
    setlocal ENABLEDELAYEDEXPANSION
    color 02
    NET FILE 1>NUL 2>NUL
    if /I '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )  
:getPrivileges 
    if /I '%1'=='ELEV' (shif /It & goto gotPrivileges)  
    ECHO. 
    ECHO ****************
    ECHO Please Click Yes
    ECHO ****************
    timeout 10 
    setlocal DisableDelayedExpansion
    set "batchPath=%~0"
    setlocal EnableDelayedExpansion
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
    ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
    "%temp%\OEgetPrivileges.vbs" 
    exit /B 
:gotPrivileges 
    setx DataSpammer "%directory9%\dataspammer.bat"
    del install.bat
    del temp.bat
    cd %directory9%
    dataspammer.bat
    ) > temp.bat
    cd %~dp0
    pause
    del install.bat
    temp.bat


:installerdone
    :: Cleanup install directory and finish the installation
    echo Finishing Installation....
    cd %~dp0
    del install.bat
    cd %directory9%
    dataspammer.bat

:cancel
    :: When the Install got canceled
    echo The installer is now closing....
    exit


:exe-install 
:: When The Script got installled with setup.exe it executes this code (with elevated Rights)

@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto nodev) else (goto dtd)
:nodev
@title Script Installer by PIRANY
set "foldername=DataSpammerbyPIRANY"
set "gitver12=v2.6"
cd %~dp0
color 2
cls  
color 2
:gitupdtcheck
if "%setupaftgitcl%"=="1" (
    goto updateinstall
) else (
    goto instdone100
)

    SETLOCAL EnableDelayedExpansion
    SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
    SETLOCAL DisableDelayedExpansion

    %$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
    %$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
    %$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
    %$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
    %$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
    %$Echo% "                             |_|                                              |___/                                     


:instdone1
    cls
    echo Do you want to add the Script to PATH?
    @ping -n 1 localhost> nul
    echo Then you can open the Script by typing "dataspammer" in the Command Shell.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Yes (Needs to run as Administrator)
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] No.
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    set /P pathansw=Choose an Option from Above:
    if %pathansw% == 1 goto addpath
    if %pathansw% == 2 goto installerdone

:dtd
    :: Ass Developer Option (why is this here)
    set /p dtd1=.:.
    %dtd1%

exit