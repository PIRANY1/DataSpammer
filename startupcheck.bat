@echo off
setlocal enabledelayedexpansion
set "error=0"
color 02
cd %~dp0
echo Checking for Data...

:1
rem StandartDirectoryCrash
if not exist "stdrcch.txt" (
    set /a "error+=1" 
    goto 2
)


:2
rem Installer DOne
if not exist "instdone.txt" (
    set /a "error+=1" 
    goto 3
)


:3
rem Standart Filename
if not exist "stdfil.txt" (
    set /a "error+=1" 
    goto finish
)


:finish

if !error! gtr 1 (
    goto error
) else (
    goto done
)

:error 
cls
echo There were %error% Error(s)
echo.
echo.
echo Do you want to install the Script or do you want to cancel?
echo.
echo.
echo [1] Open the Installer
echo.
echo.
echo [2] Close this Script/Cancel
echo.
echo.
set /p menu=Choose an Option from Above:
If %menu% == 1 goto openins
If %menu% == 1 goto done

:openins
cd %~dp0
install.bat
if %errorlevel% equ 0 (
    cls
    echo Installer is running....
) else (
    echo There was an Error. Please open the install.bat File manually.
)


:done 
servercrasher.bat

