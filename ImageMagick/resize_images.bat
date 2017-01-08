@ECHO OFF
SETLOCAL

REM ref - http://www.rubblewebs.co.uk/imagemagick/batch.php

IF "%1" EQU "" (GOTO _BAD_ARGS)

SET _INPUT_DIR=%1
SET _OUTDIR=out

IF NOT EXIST %_OUTDIR% (MKDIR %_OUTDIR%)
IF NOT EXIST temp (MKDIR temp)

DEL %_OUTDIR%\*.png

:: Read all the jpg images from the directory, resize them, add some text and save as a png in a different directory
for %%f in (%_INPUT_DIR%\*.jpg) do ( ECHO %%f... && magick convert "%%f" -resize 800x600 -auto-orient "%_OUTDIR%\%%~nf.png" )

REM text does not work on 1st test image :-( - so use watermark image instead...

REM create the watermark image
SET _TEXT=sean ryan
REM using file so can get the (c) symbol
magick convert -size 110x25 -background grey30 -fill grey70 -font Arial -pointsize 20 -gravity center label:@copyright.txt temp\stamp_fgnd.png
magick convert -size 110x25 xc:black -font Arial -pointsize 20 -gravity center -draw "fill white  text  1,1  '%_TEXT%' text  0,0  '%_TEXT%' fill black  text -1,-1 '%_TEXT%'" +matte temp\stamp_mask.png
magick composite -compose CopyOpacity  temp\stamp_mask.png  temp\stamp_fgnd.png  temp\stamp.png
REM magick mogrify -trim +repage temp\stamp.png

REM apply the watermark
for %%f in (%_OUTDIR%\*.png) do ( ECHO %%f... && magick composite -gravity southeast -geometry +10+10 -watermark 30x100 temp\stamp.png "%%f" "%%f" )

DIR %_OUTDIR%

EXPLORER %_OUTDIR%

GOTO _DONE

:_BAD_ARGS
ECHO Bad args!
ECHO USAGE: resize_images {input directory}
__error_occurred

:_DONE
ECHO [done]
