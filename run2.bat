@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

rem RBG                    %color%{R};{G};{B}m
rem RETURN TO NORMAL                  %ESC%[0m
rem SET CURSOR POS              %ESC%[{X};{Y}H

set PlayerX=5
set PlayerY=5
set ESC=
set color=%ESC%[48;2;

(set \n=^
%=Do not remove this line=%
)

call videos/Never.bat 224 8
echo %color%0;0;0m
cls

:menu
call images/Menu.bat 192 20
call images/Image.bat 192 50

call colorableImages/Quit.bat 100 100 100 192 100
call colorableImages/Test.bat 100 100 255 576 100

:Menu
call :getKey x
if %x%==" " goto :graphicsTest
call colorableImages/Quit.bat 100 100 255 192 100
call colorableImages/Test.bat 100 100 100 576 100
call :getKey x
if %x%==" " goto :stop
goto Menu

REM These are the functions


REM getKey output

:getKey
set "key="
for /F "delims=" %%K in ('2^>nul xcopy /L /W /I "%~f0" "%TEMP%"') do (
    if not defined key set "key=%%K"
)
set lastChar="!key:~-1!"
set %~1=!lastChar!
goto :eof

REM setPosition {x} {y} output

:setPosition
set x=%~2
set y=%~3
if defined x (
    set x=!x!
) else (
    set x=0
)
if defined y (
    set y=%ESC%[H%ESC%[!y!B
)
set %~1=%y%%ESC%[%x%C
goto :eof

REM drawLine {length} {r} {g} {b} {x} {y}

:drawLine
set length=%~1
set drawline=%color%%~2;%~3;%~4m
call :setPosition x %~5 %~6
for /l %%i in (1,1,%length%) do (
    set drawline=!drawline! 
)
echo %x%%drawline%%ESC%[0m
goto :eof

REM drawVertLine {length} {r} {g} {b} {x} {y}

:drawVertLine
set length=%~1
set lineColor=%color%%~2;%~3;%~4m
call :setPosition x %~5 %~6
set /a length=%length%-1
for /l %%i in (0,1,%length%) do (
    set /a x=%%i+%~6
    call :setPixel %~2 %~3 %~4 %~5 !x!
)
goto :eof

REM setPixel {r} {g} {b} {x} {y}

:setPixel
call :setPosition x %~4 %~5
echo %x%%color%%~1;%~2;%~3m %ESC%[0m
goto :eof

:graphicsTest
set line=%ESC%[H
for /l %%r in (0, 1, 255) do (
    for /l %%b in (0, 1, 255) do (
        set line=!line!%ESC%[48;2;%%r;%%b;%%bm    
    )
    echo %ESC%[48;2;%%r;0;0!line!%ESC%[0m
    set line=
)
call images/Continue.bat 192 220
timeout -1 > nul
echo %ESC%[2J%ESC%[H
goto :menu

:idle
timeout -1
goto :idle
:stop
