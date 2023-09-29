@echo off
setlocal enabledelayedexpansion
set "error=0"
color 02
cd %~dp0
echo Checking for Data...
if NOT defined noerror (start.bat) else (goto :noerr)
@echo off
:noerr
if not exist "stdrcch.txt" (
    goto Error
) else (
    if not exist "stdfil.txt" (
    goto Error
    ) else (
        if not exist "instdone.txt" (
        goto Error
        ) else (
        if not exist "gitver.txt" (
            goto Error
            ) else (  
            goto start
            )
        )  
    ) 
)

:error 
cls
echo There was an Error. 
@ping -n 1 localhost> nul
echo Please consider rerunning the installer to make sure the script can run accurately.
@ping -n 1 localhost> nul
echo Do you want to reinstall the Script or do you want to cancel?
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [1] Open the Installer
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [2] Cancel
@ping -n 1 localhost> nul
echo.
@ping -n 1 localhost> nul
echo [3] Open the Script anyways
@ping -n 1 localhost> nul
set /p menu=Choose an Option from Above:
If %menu% == 1 goto openins
If %menu% == 2 exit
If %menu% == 3 goto openanyways

:openins
cd %~dp0
install.bat
if %errorlevel% equ 0 (
    cls
    echo Installer is running....
    cls
) else (
    echo There was an Error. Please open the install.bat File manually.
)


:openanyways
set "noerror2=10000"
servercrasher.bat

