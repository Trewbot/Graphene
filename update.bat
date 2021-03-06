@echo off

echo.
echo updating code

echo reading config.json
for /f "delims=" %%i in ('node cfg.js mongoDir') do set mongoDir=%%i
for /f "delims=" %%i in ('node cfg.js database') do set database=%%i
for /f "delims=" %%i in ('node cfg.js serverDir') do set serverDir=%%i

echo fetching from github
git remote add origin https://github.com/Trewbot/Graphene.git >nul 2>&1
git fetch --all
git reset --hard origin/master

echo updating client changelog
%mongoDir%\mongorestore --drop --db %database% %serverDir%\changelog\webClientChanges.bson >nul 2>&1

echo updating server changelog
%mongoDir%\mongorestore --drop --db %database% %serverDir%\changelog\serverChanges.bson >nul 2>&1

echo running npm install
call npm install

echo running update commands
node update.js

backup