@echo off
setlocal enabledelayedexpansion

REM Set the root directory of the UCF101 dataset
set "root_dir=E:\UCF-101"

REM Set the output directory, ensuring you make the root output folder first
set "output_root=%root_dir%\output"

REM Create the output directory if it doesn't exist
if not exist "%output_root%" mkdir "%output_root%"

REM Navigate to the dataset root directory
cd /d "%root_dir%"

REM Loop through each action directory
for /d %%a in (*) do (
    REM Ensure we're not processing the output directory
    if /i not "%%a"=="output" (
        echo Processing category: %%a

        REM Create a corresponding directory in the output folder
        if not exist "%output_root%\%%a" mkdir "%output_root%\%%a"

        REM Loop through each AVI file in the action directory
        for %%f in ("%%a\*.avi") do (
            echo Converting %%f...

            REM Extract filename without path
            set "filename=%%~nf"

            REM Execute FFmpeg conversion ensuring no path issues to AV1 encoding
            ffmpeg -y -i "%%f" -c:v libaom-av1 -crf 30 -b:v 0 -c:a copy "%output_root%\%%a\!filename!.mp4" 2>> conversion_errors.log
        )
    )
)

endlocal
