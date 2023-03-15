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
  set "video_sample=%%b"
  set "youtube_link=%%c"
)
set "no_spaces=%name: =%"

if not "!youtube_link!" == "" (
	echo var1: %no_spaces%
	echo var2: %video_sample%
	echo var3: %youtube_link%
)

if "!youtube_link!" == "" (
	set /p youtube_link="Insert youtube link: "

	echo ID  Description
	echo --------------------------
	setlocal enabledelayedexpansion
	set /a i=0
	for %%d in ("motivation,training,outdoor" "car,drift,phonk" "DJ,disco,techno" "DJ,techno,mixer" "city in night,mood" "party,people dancing" "DJ,mixer,people dancing in background" "endless loop" "fireplace,dark,mood aesthetic" "disco ball,girl standing and moving it" "endless rain loop" "pomp up,training,gym" "drift,car" "dancing,flowers,girl" "flowers,aesthetic,old film" "dark,red,girl standing,slow cam" "sad,dark,slow cam" "party,one person dancing" "party,people's faces,pills" "gaming" "gaming keyboard") do (
	    set /a i+=1
	    set "desc=%%d"
	    set "desc=!desc:,= | !"
		if !i! leq 9 (
			echo !i!  #  !desc!
		) else (
			echo !i! #  !desc!
		)
	)
	echo --------------------------

	set /p video_sample="Which sample use?(1-21) "
	set /p user_input="Enter final file name: "
	set "no_spaces=%user_input: =%"
)

echo Downloading from Youtube...
youtube-dl --verbose --extract-audio --audio-format mp3 --output "%no_spaces%_audio.%%(ext)s" %youtube_link%

echo Getting audio duration info...
ffprobe -i %no_spaces%_audio.mp3 -show_entries format=duration -v quiet -of csv="p=0" > %no_spaces%_duration.tmp
set /p duration=<%no_spaces%_duration.tmp
del %no_spaces%_duration.tmp

echo duration: %duration

echo Creating video with audio...
set /a duration_rounded=%duration%
ffmpeg -stream_loop -1 -i "%script_path%samples\%video_sample%.mp4" -i %no_spaces%_audio.mp3 -t %duration% -map 0:v:0 -map 1:a:0 -c:v libx264 -c:a aac -b:a 192k -shortest -strict -2 -f mp4 -y %no_spaces%.mp4


del "%no_spaces%_audio.mp3"
echo "File %no_spaces%_audio.mp3 has been removed"

echo Finished! You will find Your final file in "%ready_to_upload_dir%\%no_spaces%.mp4"
pause
