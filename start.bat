@echo off
setlocal enabledelayedexpansion
set "gitver12=v1.1"
echo %gitver12% > "gitver.txt"
set "error=0"
@title Starting Up...
echo Starting Up....
echo Checking for Files...
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
if not exist "startupcheck.bat" (
    set /a "error+=1" 
    goto finish
)

:finish

if !error! gtr 1 (
    goto error
) else (
    goto done
)

setlocal enabledelayedexpansion
set "owner=PIRANY"
set "repo=DataSpammer"
set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (
    set "latest_version=%%i"
)
set "text_file=gitver.txt"
for /f "delims=" %%j in (%text_file%) do (
    set "text_content=%%j"
)

if "%text_content%"=="%latest_version%" (
    echo Version Up-To-Date
) else (
    echo Version Outdated!
    echo Please consider downloading the new Version. 
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
    If %menu4% == 2 done
)

endlocal

:gitupt
git clone https://github.com/PIRANY1/DataSpammer %~dp0
echo Update done!
pause
goto done

:error 
echo There was an Error (%error%)
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
set /p menu3=Choose an Option from Above:
If %menu3% == 1 exit
If %menu3% == 2 start "" "https://github.com/PIRANY1/DataSpammer"

:done 
startupcheck.bat
