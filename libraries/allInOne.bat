@echo off
setlocal EnableDelayedExpansion

set script_path=%~dp0

cd %script_path%

REM Set the default directory for "readyToUpload"
set default_dir=%ProgramFiles%\grzojda\readyToUpload

REM Load the previous directory from file (if it exists)
if exist last_dir.txt (
    set /p last_dir=<last_dir.txt
    set ready_to_upload_dir=%last_dir%
) else (
    set last_dir=

    set /p user_dir="Enter directory for readyToUpload [%last_dir%] (default=%default_dir%)":

    REM Set the directory to the user's input, or the default if no input was provided
    if not "%user_dir%" == "" (
        set ready_to_upload_dir=%user_dir%
    ) else if not "%last_dir%" == "" (
        set ready_to_upload_dir=%last_dir%
    ) else (
        set ready_to_upload_dir=%default_dir%
    )

    REM Save the current directory to file for future executions
    echo "%ready_to_upload_dir%" > "%script_path%last_dir.txt"

    REM Create the "readyToUpload" directory if it doesn't already exist
    if not exist "%ready_to_upload_dir%" mkdir "%ready_to_upload_dir%\readyToUpload"
)

cd %ready_to_upload_dir%

set "uri=%~1"
set "query=!uri:*?=!"

for /F "tokens=1,2,3 delims=&" %%a in ("%query%") do (
  set "name=%%a"
  set "image_query=%%b"
  set "youtube_link=%%c"
)
set "no_spaces=a%name: =%"

if not "!youtube_link!" == "" (
	echo var1: %no_spaces%
	echo var2: %image_query%
	echo var3: %youtube_link%
)

if "!youtube_link!" == "" (
	set /p youtube_link="Insert youtube link: "
	set /p image_query="Enter image query(for multiple words use ',' semicol): "
	set /p user_input="Enter final file name: "
	set "no_spaces=%user_input: =%"
)

echo Downloading from Youtube...
youtube-dl --verbose --extract-audio --audio-format mp3 --output "%no_spaces%_audio.%%(ext)s" %youtube_link%

echo Downloading image
ffmpeg -i https://source.unsplash.com/random/1920x1080?%image_query% -frames:v 1 -update 1 %no_spaces%_image.jpg

echo Creating video with audio...
ffmpeg -i %no_spaces%_audio.mp3 -loop 1 -framerate 30 -i %no_spaces%_image.jpg -filter_complex "[0:a]aformat=channel_layouts=mono,showwaves=size=1920x500:mode=cline:rate=30:colors=white[v];[1:v][v]overlay=format=auto:x=(W-w)/2:y=H-h/2,format=yuv420p[outv]" -map "[outv]" -map 0:a -c:v libx265 -preset superfast -c:a copy -shortest %no_spaces%.mp4

del "%no_spaces%_audio.mp3"
echo "File %no_spaces%_audio.mp3 has been removed"

del "%no_spaces%_image.jpg"
echo "File %no_spaces%_image.jpg has been removed"

echo Finished! You will find Your final file in "%ready_to_upload_dir%\%no_spaces%.mp4"
pause
