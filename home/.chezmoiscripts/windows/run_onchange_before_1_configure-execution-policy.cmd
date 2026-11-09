@echo off

echo INFO: Configure PowerShell execution policy
powershell.exe -NoProfile -Command "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction Stop"
exit /b %ERRORLEVEL%
