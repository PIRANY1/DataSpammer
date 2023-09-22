@echo off
setlocal enabledelayedexpansion
set "error=0"
@title Starting Up...
echo Starting Up....
cd %~dp0

:1
rem StandartDirectoryCrash
if not exist "start.bat" (
    set /a "error+=1" 
    goto 2
)

:2
rem StandartDirectoryCrash
if not exist "install.bat" (
    set /a "error+=1" 
    goto 3
)

:3
rem StandartDirectoryCrash
if not exist "servercrasher.bat" (
    set /a "error+=1" 
    goto 4
)

:4
rem StandartDirectoryCrash
if not exist "stdrcch.txt" (
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
echo There was an Error (%error%)
echo Please redownload the Script.
rem ////Downloadlink

:done 
startupcheck.bat