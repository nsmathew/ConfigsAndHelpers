#!/usr/bin/bash
#AccuWeather (r) RSS weather tool for conky
#
#USAGE: weather.sh <locationcode>
#
#(c) Michael Seiler 2007

METRIC=1 #Should be 0 or 1; 0 for F, 1 for C

#Changed the script name - NM
#Changed the script to take a city name instead of location code and then extract the location code from Accu weather code list file

if [ -z "$1" ]; then
    echo
    echo "USAGE: weatherforconky.sh <City>"
    echo
    exit 0;
fi

ACCWEATHER_FILE="/home/nsm09/scripts/resources/AccuweatherLocationDatabase.txt"
LOC_CODE=`grep "$1" $ACCWEATHER_FILE | head -n1 | awk -F '"' '{print $4}'`
echo -n "$1, " 
curl -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=${METRIC}\&locCode\=$LOC_CODE | perl -ne 'if (/Currently/) {chomp;/\<title\>Currently: (.*)?\<\/title\>/; print "$1"; }'

