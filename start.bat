@echo off
:topppp
setlocal enabledelayedexpansion
set "gitver12=v1.7"
@title Starting Up...
echo Checking for Files...
if not exist "start.bat" (
    set "errorlvlstart=1"
		goto Error
) else (
    if not exist "install.bat" (
		set "errorlvlstart=2"
		goto Error
    ) else (
        if not exist "servercrasher.bat" (
				set "errorlvlstart=3"
				goto Error
        ) else (
        echo Files are Ok
        if exist "updt.txt" (echo Checking For Updates | goto gitvercheck) else (goto seclaytr)
        )  
    ) 
)
:gitvercheck
:set_version
set "owner=PIRANY1"
set "repo=DataSpammer"
set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
echo Fetching Git Url....
@ping -n 1 localhost> nul
for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (set "latest_version=%%i")
if %latest_version% == v1.6 (goto UpToDate) else (goto gitverout)

:UpToDate
@ping -n 1 localhost> nul
echo The Version you are currently Using is the newest one (%latest_version%)
goto seclaytr


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
If %menu4% == 2 goto seclaytr

:gitupt
cd ..
mkdir %latest_version%
cd %latest_version%
git clone https://github.com/PIRANY1/DataSpammer %cd%
echo Downloaded
set "source_dir_start=%~dp0"
set "setupaftgitcl=1"
install.bat


:Error 
if %errorlvlstart% == 1 echo Error Code 12
if %errorlvlstart% == 2 echo Error Code 13
if %errorlvlstart% == 3 echo Error Code 14
echo View README.md for more Details.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Open GitHub for Versions.
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Continue Anyways(Script has a very high Chance of not working)
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] GitHub Error Info
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
set /p menu3=Choose an Option from Above:
If %menu3% == 2 goto seclaytr
If %menu3% == 1 start "" "https://github.com/PIRANY1/DataSpammer"
If %menu3% == 3 goto readmeopen

:readmeopen
echo Opening....
start "" "https://github.com/PIRANY1/DataSpammer/blob/main/README.md"
goto Error

:seclaytr
    echo Checking for Data...
    if not exist "stdrcch.txt" (
        set "errorlvlstart2=1"
        goto Error1
    ) else (
        if not exist "stdfil.txt" (
            set "errorlvlstart2=2"
            goto Error1
        ) else (
            if not exist "instdone.txt" (
                set "errorlvlstart2=3"
                goto Error1
            ) else (
                goto start1
            )
        )
    )

:error1
    cls
    if %errorlvlstart% == 1 echo Error Code 15
    if %errorlvlstart% == 2 echo Error Code 16
    if %errorlvlstart% == 3 echo Error Code 17
    echo Please view README.md for more Details about Error Codes.
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
    If %menu% == 2 goto start1

:openins
    cd %~dp0
    install.bat
    if %errorlevel% equ 0 (cls | echo Installer is running....) else (echo There was an Error. Please open the install.bat File manually.)
:start1
    set "noerror2=true"
    ".\servercrasher.bat"
