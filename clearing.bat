@echo off
chcp 1251 > nul
title Ultimate PC Optimizer (Admin Mode)
color 03
echo.
echo �==========================================�
echo �          ULTIMATE PC OPTIMIZER           �
echo �  (������� RAM, VRAM, ����� � �����)     �
echo L==========================================-
echo.
echo ������ �� ����� ��������������...
echo �������� ����...

:: �������� ��������� ����
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ! ������: ��������� �� ����� ��������������!
    pause
    exit
)

echo.
echo --------------------------------------------
echo ------------------------------------------
echo ---                                        --
echo --- 1. ������� ����������� ������ (RAM)   --
echo --- 2. ������� ����������� (VRAM)         --
echo --- 3. ������� ��������� ������           --
echo --- 4. ������� DNS � ������� �����        --
echo --- 5. ����������� �����                  --
echo --- 6. ������ ������� (��� �������)       --
echo ---                                        --
echo -----------------------------------------
echo --------------------------------------------
echo.

set /p choice="�������� �������� (1-6): "

:: �������
if "%choice%"=="1" goto RAM
if "%choice%"=="2" goto VRAM
if "%choice%"=="3" goto TEMP
if "%choice%"=="4" goto DNS
if "%choice%"=="5" goto DEFRAG
if "%choice%"=="6" goto FULL

:RAM
echo.
echo [v] ������� ����������� ������...
:: ���������� EmptyStandbyList �� Sysinternals
if exist "EmptyStandbyList.exe" (
    EmptyStandbyList.exe workingsets
    EmptyStandbyList.exe modifiedpagelist
    echo RAM ������� �������!
) else (
    echo ! ������: EmptyStandbyList.exe �� ������!
    echo �������� ���: https://live.sysinternals.com/EmptyStandbyList.exe
)
goto END

:VRAM
echo.
echo [v] ����� ����������� (VRAM)...
:: ����� PowerShell ������� ��� ��������
powershell -command "rundll32.exe dwmapi.dll,DwmFlush"
echo ����������� ��������!
goto END

:TEMP
echo.
echo [v] ������� ��������� ������...
del /q /f /s "%temp%\*"
del /q /f /s "%windir%\temp\*"
del /q /f /s "%systemdrive%\*.tmp"
echo ��������� ����� �������!
goto END

:DNS
echo.
echo [v] ������� ������� �����...
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo DNS � ������� ���� ��������!
goto END

:DEFRAG
echo.
echo [v] ����������� �����...
:: ��� HDD - ��������������, ��� SSD - TRIM
wmic volume get DriveLetter,FileSystem | find "NTFS" > nul
if %errorlevel%==0 (
    defrag /C /H /U /V
) else (
    echo ���� SSD - ��������� TRIM...
    powershell -command "Optimize-Volume -DriveLetter C -ReTrim -Verbose"
)
echo ����������� ���������!
goto END

:FULL
echo.
echo [!!!] ������ ������ �������...
call :RAM
call :VRAM
call :TEMP
call :DNS
call :DEFRAG
echo.
echo [v] ��� �������� ������� ���������!
goto END

:END
echo.
echo ========================================
echo ������ ����������: [Developer Noir]
echo ��������: [/��������:@noir_fa/]
echo ������: 2.0 (2025)
echo ========================================
pause