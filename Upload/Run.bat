@echo off
title Cloudflare IP Speed Tester Pro
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "test-Upload-v0.08.ps1"
pause
