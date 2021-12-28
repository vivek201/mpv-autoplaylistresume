@echo off

SETLOCAL

SET directoryName=%*
SET /A numberOfFiles=0

CALL :GetPlaylistName "%directoryName%" playlistName
@REM SET playlistName=%~n1.m3u
@REM echo %playlistName%
echo # > "%playlistName%"

FOR /R "%directoryName%" %%i IN (*.mp4 *.mpv) DO (
    set /a numberOfFiles+=1
    echo %%i >> "%playlistName%"
)

echo "Added %numberOfFiles% files to %playlistName%"

pause

:GetPlaylistName
SET %~2=%~n1.m3u
goto:eof
