@echo off
setlocal enabledelayedexpansion
set "gitver12=v1.5.1"
set "foldername=ServerCrasherbyPIRANY"
set "error=0"
@title Starting Up...
echo Starting Up....
echo Checking for Files...

if not exist "start.bat" (
    goto Error
) else (
    if not exist "install.bat" (
    goto Error
    ) else (
        if not exist "servercrasher.bat" (
        goto Error
        ) else (
        if not exist "startupcheck.bat" (
            goto Error
            ) else (  
            goto start
            )
        )  
    ) 
)



:start
setlocal enabledelayedexpansion 
set "owner=PIRANY1"
set "repo=DataSpammer"
set "api_url=https://api.github.com/repos/%owner%/%repo%/releases/latest"
echo Getting Git Url....
@ping -n 1 localhost> nul
for /f "usebackq tokens=*" %%i in (`curl -s %api_url% ^| jq -r ".tag_name"`) do (
    set "latest_version=%%i"
)
echo Script Version is %gitver12%
@ping -n 1 localhost> nul
echo Scanning for Newest Version....
@ping -n 1 localhost> nul
if %latest_version% == %gitver12% (goto UpToDate) else (goto gitverout)

:UpToDate
@ping -n 1 localhost> nul
echo The Version you are currently Using is the newest one (%latest_version%)
goto done

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
If %menu4% == 2 done

:gitupt
cd ..
mkdir %latest_version%
cd %latest_version%
git clone https://github.com/PIRANY1/DataSpammer %cd%
echo Downloaded
set "source_dir_start=%~dp0"
set "setupaftgitcl=1"
install.bat


:error 
echo There was an Error. There are important Files missing.
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
If %menu3% == 2 goto done
If %menu3% == 1 start "" "https://github.com/PIRANY1/DataSpammer"

:done 
set "noerror=1000"
startupcheck.bat
