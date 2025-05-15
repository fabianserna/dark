\
@echo off
REM Simple wrapper to call the PowerShell script
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0..\scripts\dark.ps1" %*
