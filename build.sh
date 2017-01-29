#!/bin/sh
# Maname daily build script
# Needs fontmake, wkhtmltoimage and imagemagick and shyaml<https://github.com/0k/shyaml> to run this script
# Update VERSION.txt to increment version on the png.

DATE=`date +%d%b%Y-%T`
VERSION=`cat config.yml | shyaml get-value info.version`
FAMILY=`cat config.yml | shyaml get-value info.family`
NOTE=`cat config.yml | shyaml get-value info.note`
SAMPLE=`cat config.yml | shyaml get-value settings.sample-file`

ufonormalizer ../sources/*.ufo
cp -r ../sources/*.ufo ./
fontmake --ufo-paths *.ufo --output otf ttf >log.txt
wkhtmltoimage  ./samples/$SAMPLE daily-status.png
convert daily-status.png  -gravity SouthEast -pointsize 25 \
   -fill black -annotate +10+5 "$NOTE $FAMILY $VERSION $DATE" daily-status.png
mv ./daily-status.png ../documentation/daily-status.png
mv ./master_otf/* ../fonts/otf/
mv ./master_ttf/* ../fonts/ttf/
