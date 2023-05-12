#!/bin/bash
local o=$IFS
IFS=$(echo -en "\n\b")

MP4FILE=$(ls . |grep .mp4)
for filename in $MP4FILE
do
name="${filename%.*}"
ffmpeg -i ./$filename -b:a 192K -vn ./$name.mp3
done

IFS=o
