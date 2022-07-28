@echo off
title wfpw
mode con cols=30 lines=30
:st
cls
cd /d %temp%
if exist wfpw rd /s /q wfpw
md wfpw
cd wfpw
for /f "tokens=2 delims=:" %%a in ('netsh wlan show profiles') do (echo%%a>>1.txt)

for /f "skip=1 tokens=* delims= " %%i in (1.txt) do (
(netsh wlan show profiles key=clear name="%%i")>2.txt
findstr /b /c:" " 2.txt>>3.txt
findstr /b /c:" " 2.txt>3a.txt
)

for /f "tokens=2 delims=:" %%a in ('find /c /v "" 3.txt') do set lng=%%a
for /f "tokens=2 delims=:" %%a in ('find /c /v "" 3a.txt') do set this-lth=%%a
set/a lng/=%this-lth%

echo Total saved WIFI count : %lng%

set skp=1

:lp1
if %skp% gtr %lng% goto :fin1

set/a pwa=%skp%*%this-lth%-%this-lth%+2
for /f "skip=%pwa% tokens=* delims= " %%i in (3.txt) do (
set wfn=%%~i
goto :out1
)
:out1
set/a pwa=%skp%*%this-lth%-2
for /f "skip=%pwa% tokens=* delims= " %%i in (3.txt) do (
set adq=%%~i
goto :show
)

:show
echo.
echo WIFI %skp% :
for /f "tokens=2 delims=:" %%a in ('echo %wfn%') do (echo id :%%a)
for /f "tokens=2 delims=:" %%a in ('echo %adq%') do (echo pw :%%a)

set/a skp+=1
goto :lp1

:fin1
cd..
rd /s /q wfpw
echo.
echo "press any key to refresh"
pause>nul
goto :st