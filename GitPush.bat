@echo off
title Git Auto Push
color 0A
echo ================================
echo     GIT AUTO PUSH TOOL
echo ================================
echo.

set /p commit_msg=Enter commit message: 

echo.
echo Adding all changes...
git add .

echo.
echo Committing with message: "%commit_msg%"
git commit -m "%commit_msg%"

echo.
echo Pushing to GitHub...
git push

echo.
echo ✅ Push complete!
pause
