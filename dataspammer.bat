:: Use only under MIT License
:: If you want to Publish a modified Version please mention the Original Creator PIRANY and link the GitHub Repo
@color 02
@if not defined debug_assist (@ECHO OFF) else (@echo on)
if not defined devtools (goto topppp) else (goto dtd)
setlocal enableextensions ENABLEDELAYEDEXPANSION 
net session >nul 2>&1
if %errorLevel% == 0 (cd %~dp0) else (goto topppp)
:topppp
setlocal enabledelayedexpansion
set "gitver12=v2.6"
@title Starting Up...
echo Checking for Data...
if not exist "settings.txt" goto Error1
echo Checking for Files...
if not exist "install.bat" (goto Error) else (goto updtsearch)

:updtsearch
setlocal enabledelayedexpansion
set "batchfile=settings.txt"
set "linenumber=4"
set "searchtext=uy"

for /f "tokens=1* delims=:" %%a in ('findstr /n "^" "%batchfile%"') do (
    if %%a equ %linenumber% (
        set "line=%%b"
        set "line=!line:*:=!"
        if "!line!" equ "%searchtext%" (
            goto gitvercheck
        ) else (
            goto ulttop
        )
    )
)
:gitvercheck
set "owner=PIRANY1"
set "repo=DataSpammer"
set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
echo Fetching Git Url....
@ping -n 1 localhost> nul
for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
if %latest_version% equ v2.6 (goto UpToDate) else (goto gitverout)

:UpToDate
@ping -n 1 localhost> nul
echo The Version you are currently Using is the newest one (%latest_version%)
goto ulttop


:gitverout
echo.
@ping -n 1 localhost> nul
echo Version Outdated!
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Please consider downloading the new Version. 
@ping -n 1 localhost> nul
echo The Version you are currently using is %gitver12%
@ping -n 1 localhost> nul 
echo The newest Version avaiable is %latest_version%
@ping -n 1 localhost> nul
echo.
echo [1] Update
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Continue Anyways
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu4=Choose an Option from Above:
If %menu4% == 1 goto gitupt
If %menu4% == 2 goto ulttop
goto gitverout

:gitupt
set gitverold=%gitver12%
cd %~dp0
set "source_dir_start=%cd%"
cd ..
mkdir %latest_version%
cd %latest_version%
git clone https://github.com/PIRANY1/DataSpammer %cd%
echo Downloaded
set "setupaftgitcl=1"
install.bat


:Error 
echo The "Install.bat" doesnt exist. Please redownload the Script.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Open GitHub for Versions.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Continue Anyways(Script has a Chance of not working
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu3=Choose an Option from Above:
If %menu3% == 2 goto ulttop
If %menu3% == 1 goto gitopen
goto Error

:gitopen
start "" "https://github.com/PIRANY1/DataSpammer"
goto Error

:error1
    cls
    echo The File "settings.txt" doesnt exist. 
    @ping -n 1 localhost> nul
    echo Theres a high Chance that the Installer didnt run yet.
    @ping -n 1 localhost> nul
    echo Please consider rerunning the installer to make sure the script can run accurately.
    @ping -n 1 localhost> nul
    echo Do you want to reinstall the Script or do you want to open the Script anyways?
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [1] Open the Installer
    @ping -n 1 localhost> nul
    echo.
    @ping -n 1 localhost> nul
    echo [2] Open the Script anyways
    @ping -n 1 localhost> nul
    set /p menu=Choose an Option from Above:
    If %menu% == 1 goto openins
    If %menu% == 2 goto ulttop
    goto error1

:openins
    cd %~dp0
    install.bat
    if %errorlevel% equ 0 (cls | echo Installer is running....) else (echo There was an Error. Please open the install.bat File manually.)

rem --------------------------------------------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------------------------------------------
rem -------------------------------------------------Start.bat  <- Transition -> DataSpammer.bat------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------------------------------------------
rem --------------------------------------------------------------------------------------------------------------------------------------------------
:ulttop
color 2
if "%settingsmainscriptvar%" == "1" goto setting

SETLOCAL EnableDelayedExpansion
SET $Echo=FOR %%I IN (1 2) DO IF %%I==2 (SETLOCAL EnableDelayedExpansion ^& FOR %%A IN (^^^!Text:""^^^^^=^^^^^"^^^!) DO ENDLOCAL ^& ENDLOCAL ^& ECHO %%~A) ELSE SETLOCAL DisableDelayedExpansion ^& SET Text=
SETLOCAL DisableDelayedExpansion

setlocal enabledelayedexpansion
set "file=settings.txt"
set nr=0
for /l %%i in (1,1,5) do (
    set "line%%i="
)
for /f "delims=" %%a in (%file%) do (
    set /a "nr+=1"
    set "line!nr!=%%a"
)
set "insdonevar1=!line1!"
set "stdfile=!line2!"
set "stdrc1=!line3!"
if not defined devtools (goto menu) else (goto dtd)

:menu
cls
%$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
%$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
%$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
%$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
%$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
%$Echo% "                             |_|                                              |___/                                     



@ping -n 1 localhost> nul
echo Made by PIRANY 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Info
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Start
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Cancel
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Credits/Contact
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [5] Settings
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [6] Autostart/Desktop Icon
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [7] Check for Script-Updates
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [8] Check for Library Updates (may take some time)
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [9] Open GitHub-Repo
echo.
echo.
set /p menu1=Choose an Option from Above:

If %menu1% == 1 goto info
If %menu1% == 2 goto start
If %menu1% == 3 goto cancel
If %menu1% == 4 goto credits
If %menu1% == 5 goto setting
If %menu1% == 6 goto autostartdeskic
If %menu1% == 7 goto checkgitupdt
If %menu1% == 8 goto checklibupdt
If %menu1% == 9 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto menu
goto menu

:checkgitupdt
set "owner=PIRANY1"
set "repo=DataSpammer"
set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
echo Fetching Git Url....
@ping -n 1 localhost> nul
for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
if %latest_version% equ v2.6 (goto UpToDate) else (goto gitverout)

:UpToDate
@ping -n 1 localhost> nul
echo The Version you are currently Using is the newest one (%latest_version%)
pause 
goto menu 

:checklibupdt
echo Checking for Updates...
start cmd /k "scoop update"
start cmd /k "scoop update jq"
start cmd /k "scoop update jid"
start cmd /k "winget upgrade --id Git.Git -e --source winget"
goto menu

:info
cls
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo No liability for any Damages on your Software.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo If you want to use this Script on a Server you have to be able to write something in the Folder you want to use.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Go back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Exit
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu2=Choose an Option from Above:
If %menu2% == 1 goto menu
If %menu2% == 2 goto cancel
goto info

:credits
cls 
echo.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo This Script is made by PIRANY for Educational Use only.
@ping -n 1 localhost> nul
echo The whole Code is made by PIRANY  
@ping -n 1 localhost> nul
echo If you found any Bugs/Glitches or have a Problem With this software please 
@ping -n 1 localhost> nul
echo Create a Issue on the Github-Repo
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Go back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Open the Github-Repo
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Exit
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu3=Choose an Option from Above:
If %menu3% == 1 goto menu
If %menu3% == 3 goto cancel
If %menu3% == 2 start "" "https://github.com/PIRANY1/DataSpammer" | cls | goto credits
goto credits

:setting
cls 
echo ========
echo Settings
echo ========
echo.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Standart Filename (Will have a Number behind.)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Standard Directory to Spam(idk why you would need this but here you go)
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Go back
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul


set /p menu4=Choose an Option from Above:
If %menu4% == 1 goto filenamechange
If %menu4% == 2 goto stddirectorycrash
If %menu4% == 3 goto menu
goto setting

:filenamechange
cls 
echo The Filename cant have the following Character(s):\ / : * ? " < > |"
set /p mainfilename=Type in the Filename you want to use.
setlocal enabledelayedexpansion
set "file=settings.txt"
set "tmpfile=temp.txt"
set linenumber=0
(for /f "tokens=*" %%a in (!file!) do (
    set /a "linenumber+=1"
    if !linenumber! equ 2 (
        echo !mainfilename!
    ) else (
        echo %%a
    )
)) > !tmpfile!
move /y !tmpfile! !file!
echo The Standart Filename was saved!
cls
goto setting


:stddirectorycrash
cls 
echo.
echo.
set /p directory0=Type Your Directory Here:
if exist %directory0% (goto stddirectorycrash2) else (goto stddirectorycrash3)
:stddirectorycrash2
setlocal ENABLEDELAYEDEXPANSION
set "setfile=settings.txt"
set "tmpfile=temp.txt"
set "lineCounter=0"

(
  for /f "tokens=*" %%a in (!setfile!) do (
    set /a "lineCounter+=1"
    if !lineCounter! equ 3 (
      echo !directory0!
    ) else (
      echo %%a
    )
  )
) > !tmpfile!
move /y !tmpfile! !setfile!
echo The Directory was saved!
cls
goto setting

:stddirectorycrash3
echo The Directory is invalid!
pause
goto stddirectorycrash

:autostartdeskic
echo.
cls
echo.
echo ==================
echo Autostart/Desktopicon Settings
echo ==================
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Setup 
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Delete Autostart
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Delete DesktopIcon
echo.
@ping -n 1 localhost> nul
echo [4] Back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [5] Settings
echo.
echo.
set /p menu000=Choose an Option from Above:

If %menu000% == 1 goto autostartsetup
If %menu000% == 2 goto autostartdelete
If %menu000% == 4 goto menu
If %menu000% == 3 goto desktopicdel
If %menu000% == 5 goto autostartdesktsett
goto autostartdeskic

:autostartsetup
echo This Setup will lead you trough the Autostart/Desktopicon Setup.
@ping -n 1 localhost> nul
echo If you are not sure what that is please take a look at the Information.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Start Setup for Autostart
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Start Setup for DesktopIcon
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] View Information
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Go Back
@ping -n 1 localhost> nul
echo.
set /p menu123134=Choose an Option from Above:

If %menu123134% == 3 goto viewdocs 
If %menu123134% == 1 goto autostartsetupconfyy
If %menu123134% == 4 goto autostart
If %menu123134% == 2 goto desktopiconsetup
goto autostartsetup

:viewdocs 
@ping -n 1 localhost> nul
echo If you put for example Links or Programms into your Autostart Folder 
@ping -n 1 localhost> nul
echo They will automaticly launch if you boot your Device.
@ping -n 1 localhost> nul
echo Your System cant be more vulnerable if you do this.
@ping -n 1 localhost> nul
echo You can create an Desktop Icon too if you dont want the Script to open 
@ping -n 1 localhost> nul
echo Every time you boot.
@ping -n 1 localhost> nul
echo Please note that if you change the Directory you also need to change it in the Autostart Settings.
@ping -n 1 localhost> nul
echo [1] Go back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Open Desktop Icon Setup.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Open AutostartSetup
echo.
@ping -n 1 localhost> nul
set /p viewdocsmenu=Choose an Option from above:

If %viewdocsmenu% == 1 goto autostartsetup
If %viewdocsmenu% == 2 goto desktopiconsetup
If %viewdocsmenu% == 3 goto autostartsetupconfyy
goto viewdocs

:autostartdelete
setlocal enableextensions ENABLEDELAYEDEXPANSION 
net session >nul 2>&1
if %errorLevel% == 0 (goto autostartdelete2) else (goto noelev)
:autostartdelete2
echo Autostart is getting detected as a Virus from some antivirus Programs. 
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
if %avturnoff% == 1 start "" "https://www.security.org/antivirus/turn-off/" | cls | goto autostartdelete2
if %avturnoff% == 2 cls | goto viewdocs 
if %avturnoff% == 3 cls | goto autostartdelete3
if %avturnoff% == 4 cls | goto cancel
goto autostartdelete2

:autostartdelete3
@ping -n 1 localhost> nul
cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
del autostart.bat
cd /d %~dp0

:autostartsetupconfyy
setlocal enableextensions ENABLEDELAYEDEXPANSION 
net session >nul 2>&1
if %errorLevel% == 0 (goto autostartsetupconfyy2) else (goto noelev)
:autostartsetupconfyy2
@ping -n 1 localhost> nul
echo The Setup for Autostart is now starting...
cd /d C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup
@ping -n 1 localhost> nul
echo. > DataSpammer.bat
set "varlinkauto=%~dp0"
(
echo @echo off
echo cd /d %varlinkauto%
dataspammer.bat
) > autostart.bat
cd /d %~dp0


:desktopiconsetup
setlocal enableextensions ENABLEDELAYEDEXPANSION 
net session >nul 2>&1
if %errorLevel% == 0 (goto desktopiconsetup2) else (goto noelev)
:desktopiconsetup2
cd %userprofile%\Desktop
echo. > DataSpammer.bat
set "varlinkauto=%~dp0"
(
echo @echo off
echo cd /d %varlinkauto%
dataspammer.bat
) > DataSpammer.bat
echo Done!
pause
goto autostartdeskic
                                                                                                    

:autostartdesktsett
echo.
@ping -n 1 localhost> nul
echo If you have moved the Directory please Delete the Autostart and Then Set it up new
@ping -n 1 localhost> nul
pause
goto autostartdeskic


:start
cls
set "verify=%random%"
echo Please Verify that you want to use a Spam Method.
echo Please have in Mind that this can make your Installation Unusable.
echo Please enter %verify% in the Field Below
set /p verifyans=Type %verify%:
if "%verifyans%"=="%verify%" (
    goto start187
) else (
    goto start
)

:start187
echo Choose the Method you want to use:
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] .txt Spam in custom Directory
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Desktop Icon Spam
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Remote Spam (Under developement)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [4] Go Back
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
set /p spammethod=Choose an Option from Above:

If %spammethod% == 1 goto txtspamchose
If %spammethod% == 2 goto deskiconspam
If %spammethod% == 3 goto remotespam
If %spammethod% == 4 goto menu
goto start187

:remotespam
echo In Order to work the Remote Spam Method needs 6 components.
@ping -n 1 localhost> nul
echo 1: The IP of the Device you want to spam
@ping -n 1 localhost> nul
echo 2: The Account you want to Use
@ping -n 1 localhost> nul
echo 3: The Passwort of the Account you want to spam
@ping -n 1 localhost> nul
echo 4: A Filename
@ping -n 1 localhost> nul
echo 5: The Directory you want to Spam.
@ping -n 1 localhost> nul
echo 6: How many Files you want to create
@ping -n 1 localhost> nul
echo The Device has to be turned on too and has to be connected to the Internet.
@ping -n 1 localhost> nul
echo.
echo. 
echo [1] Continue
echo.
echo [2] Back
echo.
set /P remotespamchoose=Choose an Option from above:
if %remotespamchoose% == 1 goto remotespamsetupfirst
if %remotespamchoose% == 2 goto start187

:remotespamsetupfirst
echo Please specify the IP of the Device
@ping -n 1 localhost> nul
echo Down Below are a Few IPs in your Network. 
arp -a 
@ping -n 1 localhost> nul
echo If you need help finding the IP type "help"
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
set /P remotespamip=Enter the IP:
if %remotespamip% == help (
    start "" "https://support.ucsd.edu/services?id=kb_article_view&sysparm_article=KB0032480"
) else (
    goto remotespamsetup
)
:remotespamsetup
setlocal enabledelayedexpansion
echo !remotespamip! | findstr /R "^([0-9]{1,3}\.){3}[0-9]{1,3}$"
if %errorlevel% equ 0 (
    goto remotespamsetup2
) else (
    echo The IP you entered doesnt seem Valid. Please try again.
    pause
    goto remotespamsetupfirst
)

:remotespamsetup2
set /P remotespamaccname=Enter an Account Name:
set /P remotespampasswrd=Enter the Password of the Account:
set /P remotespamdrc=Enter the Directory:
echo The Filename cant include the following Character(s):\ / : * ? " < > |"
set /P remotespamfilename=Enter a Filename:
set /P remotespamfilecount=How many files do you want to create:
:remotespamverify
cls
set "verify=%random%"
echo Please Verify that you want to this Spam Method.
set /p verifyans=Type %verify%:
if "%verifyans%"=="%verify%" (
    goto startremotespam
) else (
    goto remotespamverify
)

:startremotespam
set "assetcount=1"
:assetcounttop
color 02
@ping -n 1 localhost> nul
echo Loading Assets(%assetcount%/32)
set /a "assetcount+=1"
If %assetcount% == 33 (goto remotespamstart) else (goto assetcounttop)

:remotespamstart
echo 3
@ping -n 2 localhost> nul
echo 2
@ping -n 2 localhost> nul
echo 1
@ping -n 2 localhost> nul
echo Starting.....
@ping -n 2 localhost> nul
set "remotespamcount=1"
scp file.txt root@serverip:~/file.txt
scp C:\Pfad\zur\Lokalen\Datei.txt Benutzer@Zielserver:/Pfad/Auf/Ziel/Server


:deskiconspam
@ping -n 1 localhost> nul
echo This Method will Spam your Desktop with Files
@ping -n 1 localhost> nul
echo You can customise four things here. 
@ping -n 1 localhost> nul
echo 1:Filename
@ping -n 1 localhost> nul
echo 2:Format of the File (for example .txt or .bat)
@ping -n 1 localhost> nul
echo 3:The Text in the File
@ping -n 1 localhost> nul
echo 4:Count of Files
@ping -n 1 localhost> nul
echo.
echo [1] Start 
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Go Back
@ping -n 1 localhost> nul
echo.
echo.
set /p menu1877=Choose an Option from Above:
If %menu1877% == 2 goto start
If %menu1877% == 1 goto deskiconspam1
goto deskiconspam

:deskiconspam1
echo How Should the Files be named?
@ping -n 1 localhost> nul
echo The Filename cant include one of the following Character(s):\ / : * ? " < > |"
@ping -n 1 localhost> nul
set /p "deskiconspamname=Choose a Filename:"
goto deskiconspam2

:deskiconspam2
echo Now Choose the Format of the File
@ping -n 1 localhost> nul
echo If you are not sure type txt
@ping -n 1 localhost> nul
echo Please not include the dot
@ping -n 1 localhost> nul
set /p "deskiconspamformat=Choose the Format:"
goto deskiconspam3

:deskiconspam3
echo Now Choose the Content the File should include
@ping -n 1 localhost> nul
set /p "deskiconspamcontent=Type something in:"
goto deskiconspam4

:deskiconspam4
echo Now Choose how many files should be created 
@ping -n 1 localhost> nul
echo Leave empty if you want infinite.
@ping -n 1 localhost> nul
set /p "deskiconspamamount=Type a Number:"
goto deskiconspamwdata

:deskiconspamwdata
echo All set. 
@ping -n 1 localhost> nul
echo Please confirm that you want to Spam your Desktop.
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [y] Yes
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [n] No, Cancel
@ping -n 1 localhost> nul
set /p deskicspamconf11=Choose an Option from Above:
If %deskicspamconf11% == y goto deskiconspamconfdata
If %deskicspamconf11% == n goto menu
goto deskiconspamwdata

:deskiconspamconfdata
set "assetcount=1"
:assetcounttop
color 02
@ping -n 1 localhost> nul
echo Loading Assets(%assetcount%/32)
set /a "assetcount+=1"
If %assetcount% == 33 (goto deskiconspamsetdonestart) else (goto assetcounttop)


:deskiconspamsetdonestart
cls
color 02
echo The Desktopiconspammer is about to start....
@ping -n 2 localhost> nul
echo 3 Seconds Left
echo If you want to stop this, Simply close the CMD-Window
@ping -n 2 localhost> nul
echo 2 Seconds Left
@ping -n 2 localhost> nul
echo 1 Seconds Left
@ping -n 1 localhost> nul
echo Starting.....
cd /d %userprofile%\Desktop
if not defined deskiconspamamount (
    goto infinitespam
) else (
    goto limitedspam
)

exit
:infinitespam
:deskspamtop
echo %deskiconspamcontent% > %deskiconspamname%.%deskiconspamformat%
goto deskspamtop
exit

:limitedspam
color 02
set "deskspamlimitedvar=1"
:limitedspam1
If %deskspamlimitedvar% == %deskiconspamamount% (goto done2) else (goto limitedspam2)
:limitedspam2
echo Created %deskspamlimitedvar% File(s)
echo %deskiconspamcontent% > %deskiconspamname%%deskspamlimitedvar%.%deskiconspamformat%
set /a "deskspamlimitedvar+=1"
goto limitedspam1

:txtspamchose
if stdrc1 equ notused (goto novarset) else (cd /d %stdrc1% && goto nameset)

:novarset
cls
echo Please enter the Directory of the Folder/Server you want to Spam.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo You can find the Directory by Clicking on the Path in you Explorer (on top) and copy it in here. 
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo It should look something like this: C:\User\Dokuments\SpamFolder
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo You can use your User Directory if you are using a Server. This works in most Cases but it sometimes doesnt work. Why dont you try?
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [1] Use User Directory
@ping -n 1 localhost> nul
echo. 
@ping -n 1 localhost> nul
echo [2] Enter a Directory
@ping -n 1 localhost> nul
set /p menu5=Choose an Option from Above:
If %menu5% == 1 goto userdrc
If %menu5% == 2 goto manualcd

:userdrc 
cd /d %userprofile%

:manualcd
echo.
echo.
set /p directory1=Type Your Directory Here:

cd /d %directory1%

if %ERRORLEVEL% neq 0 (
    echo There was an Error. Please check if the Directory is correct or retry later. 
) else (
    echo The Directory was Correct!
    goto nameset
)

:nameset
if %stdfile% equ notused (goto nameset2) else (goto timerask)

:nameset2
cls
echo Now You have to choose a filename. It can be anything as long as the 
echo Filename doesnt have the following Character(s):\ / : * ? " < > |"
set /p stdfile=Type in the Filename you want to use.
setlocal enabledelayedexpansion
goto timerask

:timerask
cls
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Do you want to set how many files should be created?
@ping -n 1 localhost> nul
echo If you choose No the script will run for eternity.
@ping -n 1 localhost> nul
set /p menu6=Yes[y]  No [n]:
If %menu6% == y goto timerset
If %menu6% == n goto cddone
goto timerask

:timerset 
cls
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo How many Files should be created?
set /p filecount=Type a Number:
goto cddone

:cddone
cls
echo. 
echo.
echo Please confirm.
pause
echo Loading...
@ping -n 2 localhost> nul
echo 5 Seconds left
@ping -n 2 localhost> nul
echo 4 Seconds left
@ping -n 2 localhost> nul
echo 3 Seconds left
@ping -n 2 localhost> nul
echo 2 Seconds left
@ping -n 2 localhost> nul
echo 1 Second left
@ping -n 2 localhost> nul
echo Starting......
echo If you want to stop this script simply close the Command Windows or press ALT F4
:top
set /a x+=1
echo. > %stdfile%%x%.txt
echo Created %x% File(s).
if %x% equ %filecount% (goto done) else (goto top)


:done
cls
echo.
%$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
%$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
%$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
%$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
%$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
%$Echo% "                             |_|                                              |___/                                                                                                                                     

@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo The Script Created %filecount% Files.
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Do you want to Close the Script or Go to the Menu?
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Close
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Menu
echo.
@ping -n 1 localhost> nul
set /p menu9=Choose an Option from Above:
If %menu9% == 1 goto cancel
If %menu9% == 2 goto menu
goto done

:done2
echo.
%$Echo% "   ____        _        ____                                            _           ____ ___ ____      _    _   ___   __
%$Echo% "  |  _ \  __ _| |_ __ _/ ___| _ __   __ _ _ __ ___  _ __ ___   ___ _ __| |__  _   _|  _ \_ _|  _ \    / \  | \ | \ \ / /
%$Echo% "  | | | |/ _` | __/ _` \___ \| '_ \ / _` | '_ ` _ \| '_ ` _ \ / _ \ '__| '_ \| | | | |_) | || |_) |  / _ \ |  \| |\ V / 
%$Echo% "  | |_| | (_| | || (_| |___) | |_) | (_| | | | | | | | | | | |  __/ |  | |_) | |_| |  __/| ||  _ <  / ___ \| |\  | | |  
%$Echo% "  |____/ \__,_|\__\__,_|____/| .__/ \__,_|_| |_| |_|_| |_| |_|\___|_|  |_.__/ \__, |_|  |___|_| \_\/_/   \_\_| \_| |_|  
%$Echo% "                             |_|                                              |___/                                     
                                                                                              

@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo The Script Created %deskspamlimitedvar% Files.
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo Do you want to Close the Script or Go to the Menu?
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Close
echo.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Menu
echo.
@ping -n 1 localhost> nul
set /p menu9=Choose an Option from Above:
If %menu9% == 1 goto cancel
If %menu9% == 2 goto menu
goto done2

:noelev
echo Please start the Script as Administrator in order to install.
echo To do this right click the install.bat File and click "Run As Administrator"
pause
exit

:cancel 
exit
exit

:dtd
set /p dtd1=.:.
%dtd1%
