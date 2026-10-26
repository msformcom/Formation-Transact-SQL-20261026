@echo off
set MSG=%1
if "%MSG%"=="" set MSG="update auto"
git add .
git commit -m %MSG%
git push origin main
pause