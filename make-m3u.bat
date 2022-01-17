@echo off

SETLOCAL

SET "directoryName=%~1"
SET tempVar=%2
SET /A numberOfFiles=0

@REM Handles commas in the main-directory name
if defined tempVar (
    SET directoryName=%*
)

CALL :GetPlaylistName "%directoryName%" playlistName
echo # > "%playlistName%"

FOR /R "%directoryName%" %%i IN (*.mp4 *.mkv) DO (
    set /a numberOfFiles+=1
    echo %%i >> "%playlistName%"
)

echo "Added %numberOfFiles% files to %playlistName%"

pause

:GetPlaylistName
SET %~2=%~n1.m3u
goto:eof
