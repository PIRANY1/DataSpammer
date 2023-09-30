@echo off
setlocal enabledelayedexpansion
set "gitver12=v1.3"
echo %gitver12% > "gitver.txt"
set "error=0"
@title Starting Up...
echo Starting Up....
echo Checking for Files...
cd %~dp0

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
    goto gitverout
)

:gitverout
echo.
echo Version Outdated!
echo.
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


endlocal

:gitupt
set "foldername=ServerCrasherbyPIRANY"
cd ..
mkdir %gitver12%
git clone https://github.com/PIRANY1/DataSpammer %cd%
echo Downloaded
cd %~dp0\%gitver12%
cls
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
