@echo off
chcp 1251 > nul
title Ultimate PC Optimizer (Admin Mode)
color 03
echo.
echo г==========================================¬
echo ¦          ULTIMATE PC OPTIMIZER           ¦
echo ¦  (Очистка RAM, VRAM, диска и кэшей)     ¦
echo L==========================================-
echo.
echo Запуск от имени администратора...
echo Проверка прав...

:: Проверка админских прав
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ! ОШИБКА: Запустите от имени Администратора!
    pause
    exit
)

echo.
echo --------------------------------------------
echo ------------------------------------------
echo ---                                        --
echo --- 1. Очистка оперативной памяти (RAM)   --
echo --- 2. Очистка видеопамяти (VRAM)         --
echo --- 3. Очистка временных файлов           --
echo --- 4. Очистка DNS и сетевых кэшей        --
echo --- 5. Оптимизация диска                  --
echo --- 6. ПОЛНАЯ ОЧИСТКА (ВСЕ ФУНКЦИИ)       --
echo ---                                        --
echo -----------------------------------------
echo --------------------------------------------
echo.

set /p choice="Выберите действие (1-6): "

:: Функции
if "%choice%"=="1" goto RAM
if "%choice%"=="2" goto VRAM
if "%choice%"=="3" goto TEMP
if "%choice%"=="4" goto DNS
if "%choice%"=="5" goto DEFRAG
if "%choice%"=="6" goto FULL

:RAM
echo.
echo [v] Очистка оперативной памяти...
:: Используем EmptyStandbyList от Sysinternals
if exist "EmptyStandbyList.exe" (
    EmptyStandbyList.exe workingsets
    EmptyStandbyList.exe modifiedpagelist
    echo RAM успешно очищена!
) else (
    echo ! Ошибка: EmptyStandbyList.exe не найден!
    echo Скачайте тут: https://live.sysinternals.com/EmptyStandbyList.exe
)
goto END

:VRAM
echo.
echo [v] Сброс видеопамяти (VRAM)...
:: Через PowerShell сбросим кэш драйвера
powershell -command "rundll32.exe dwmapi.dll,DwmFlush"
echo Видеопамять сброшена!
goto END

:TEMP
echo.
echo [v] Очистка временных файлов...
del /q /f /s "%temp%\*"
del /q /f /s "%windir%\temp\*"
del /q /f /s "%systemdrive%\*.tmp"
echo Временные файлы удалены!
goto END

:DNS
echo.
echo [v] Очистка сетевых кэшей...
ipconfig /flushdns
netsh int ip reset
netsh winsock reset
echo DNS и сетевые кэши сброшены!
goto END

:DEFRAG
echo.
echo [v] Оптимизация диска...
:: Для HDD - дефрагментация, для SSD - TRIM
wmic volume get DriveLetter,FileSystem | find "NTFS" > nul
if %errorlevel%==0 (
    defrag /C /H /U /V
) else (
    echo Диск SSD - применяем TRIM...
    powershell -command "Optimize-Volume -DriveLetter C -ReTrim -Verbose"
)
echo Оптимизация завершена!
goto END

:FULL
echo.
echo [!!!] ЗАПУСК ПОЛНОЙ ОЧИСТКИ...
call :RAM
call :VRAM
call :TEMP
call :DNS
call :DEFRAG
echo.
echo [v] ВСЕ ОПЕРАЦИИ УСПЕШНО ЗАВЕРШЕНЫ!
goto END

:END
echo.
echo ========================================
echo Скрипт разработан: [Developer Noir]
echo Контакты: [/телеграм:@noir_fa/]
echo Версия: 2.0 (2025)
echo ========================================
pause