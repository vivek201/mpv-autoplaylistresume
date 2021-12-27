@echo off

SET directoryName=%1
SET /A numberOfFiles=0
SET playlistName=%~n1.m3u
echo %playlistName%
echo # > "%playlistName%"

FOR /R %directoryName% %%i IN (*.mp4 *.mpv) DO (
    set /a numberOfFiles+=1
    echo %%i >> "%playlistName%"
)

echo Added %numberOfFiles% files to %playlistName%

pause
