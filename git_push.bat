@echo off
set GIT="C:\Program Files\Git\bin\git.exe"

cd /d "C:\SQL_Monitoring\ddl_exports" || exit /b 1

:: Init repo if needed
if not exist ".git" (
    %GIT% init
    %GIT% branch -M main
    %GIT% remote add origin https://ghp_FOaj4YARp6M7cvE6vH5aAWclODkk912k7GY@github.com/Manikantahs1993/SQLDDL.git
) else (
    %GIT% remote set-url origin https://ghp_FOaj4YARp6M7cvE6vH5aAWclODkk912k7GY@github.com/Manikantahs1993/SQLDDL.git
)

:: Stage files
%GIT% add -A

:: Check if anything changed and commit if yes
%GIT% diff --cached --quiet
if not %errorlevel%==0 (
    %GIT% commit -m "DDL Backup %date% %time%"
    %GIT% push origin main
) else (
    echo No changes to commit.
)

exit /b 0
