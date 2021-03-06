#!/bin/sh
# Maname daily build script, not for production builds.
# Needs fontmake, wkhtmltoimage and imagemagick and shyaml<https://github.com/0k/shyaml> to run this script
# Set-up build `config.yml`.

DATE=`date +%d%b%Y-%T`
CONFIG="config.yml"
VERSION=`cat $CONFIG | shyaml get-value info.version`
FAMILY=`cat $CONFIG  | shyaml get-value info.family`
NOTE=`cat $CONFIG  | shyaml get-value info.note`
DAILYSTATUSFILE=`cat $CONFIG  | shyaml get-value settings.daily-status-file`
SPECIMENFILE=`cat $CONFIG  | shyaml get-value settings.specimen-file`

ufonormalizer ../sources/*.ufo
cp -r ../sources/*.ufo ./
cp -r ../documentation/specimen-sources/ specimen-sources

fontmake --ufo-paths *.ufo --output otf ttf >log.txt --autohint
mv ./master_otf/* ../fonts/otf/
mv ./master_ttf/* ../fonts/ttf/
mv ./autohinted/* ../fonts/hinted/ttf/

weasyprint $SPECIMENFILE specimen.pdf
mv ./specimen.pdf ../documentation/specimen.pdf

wkhtmltoimage  $DAILYSTATUSFILE daily-status.png
convert daily-status.png  -gravity SouthEast -pointsize 25 \
   -fill black -annotate +10+5 "$NOTE $FAMILY $VERSION $DATE" daily-status.png
mv ./daily-status.png ../documentation/daily-status.png
