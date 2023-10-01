@echo off
set "gitver12=v1.3"
:targetdirset
cd ..
cd %gitver12%
set "target_dir=%cd%""

:sourcedirset
set "source_dir=source_dir_start"

:actionnn1233
copy %source_dir%\instdone.txt %target_dir%
copy %source_dir%\stdfil.txt %target_dir%
copy %source_dir%\stdrcch.txt %target_dir%
cd %~dp0

echo Update was Successful
start.bat

