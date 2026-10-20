@echo off
setlocal
 title Burning Empires Equipment Only Installer
 echo.
 echo Burning Empires Equipment Only - v1.2 installer
 echo This installs a companion module and never modifies the original BurningEmpires folder.
 echo.
 where powershell.exe >nul 2>nul
 if errorlevel 1 (
   echo ERROR: Windows PowerShell was not found.
   pause
   exit /b 1
 )
 powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-EquipmentOnly.ps1"
 set "RC=%ERRORLEVEL%"
 echo.
 if not "%RC%"=="0" echo Installer exited with an error. Read the message above; your existing module was preserved unless the installer reported otherwise.
 if "%RC%"=="0" echo Installer completed.
 pause
 exit /b %RC%
