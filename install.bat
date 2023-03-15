@echo off

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges. Please run it as an administrator.
    echo Press any key to continue...
    pause >nul
    exit
)

set script_path=%~dp0
echo The path of this script is %script_path%

REM Create a directory for the downloaded files
set download_dir=%script_path%libraries

REM Download the latest FFmpeg
set ffmpeg_url=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip
bitsadmin /transfer mydownloadjob /download /priority normal "%ffmpeg_url%" "%download_dir%\ffmpeg.zip"

REM Download the latest youtube-dl
set youtube_dl_url=https://github.com/yt-dlp/yt-dlp/releases/download/2023.03.04/yt-dlp.exe
bitsadmin /transfer mydownloadjob /download /priority normal "%youtube_dl_url%" "%download_dir%\youtube-dl.exe"

REM Extract FFmpeg
set ffmpeg_zip=%download_dir%\ffmpeg.zip
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "$zip = Get-Item '%ffmpeg_zip%'; Expand-Archive $zip.FullName -DestinationPath '%download_dir%'; $extractedDir = Get-ChildItem -Path '%download_dir%' -Directory | Select-Object -First 1; Rename-Item -Path $extractedDir.FullName -NewName 'ffmpeg'; Remove-Item -Path $zip.FullName"

REM Move libraries to Program Files and set PATH
set program_dir=%ProgramFiles%\grzojda
mkdir "%program_dir%"
move "%download_dir%" "%program_dir%\libraries"
move "%download_dir%\..\samples" "%program_dir%\libraries\samples"
setx PATH "%program_dir%\libraries\ffmpeg\bin;%program_dir%\libraries;" /M
icacls "%program_dir%" /grant:r %username%:(OI)(CI)F /t
echo FFmpeg and youtube-dl have been downloaded and added to PATH with allInOne script.

set regPath=HKCU\SOFTWARE\Classes\MyURI
set regKey=URL Protocol
set regValue=""

set regCmd=reg add "%regPath%" /f /v "%regKey%" /t REG_SZ /d %regValue%
echo %regCmd%
%regCmd%

set regKey=shell\open\command
set regValue="\"%program_dir%\libraries\allInOne.bat\" \"%%1\""

set regCmd=reg add "%regPath%\%regKey%" /f /v "" /t REG_SZ /d %regValue%
echo %regCmd%
%regCmd%

echo URI scheme registered successfully!
echo ----------------DONE--------------------
pause