@echo off
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
        echo y
        pause
        )
        )  
    ) 
)

:Error 
echo y
pause