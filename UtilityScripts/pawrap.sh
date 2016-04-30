#! /usr/bin/bash
#Wrapper script for Pulse Audio
#Get current volume
#Increase/Decrease Volume
#Toggle Mute
#Read Current Volume Level
#Get current Card in use forOutput
#Set Active Output

#Global Variables
CURR_VOL=
MUTE_STATUS=
SINK=
CARD_CNT=
CARD_NAME=

#Helper to get active sink number
get_active_sink_number(){
	SINK=`pacmd list-sinks | grep -n '*' | awk 'BEGIN {FS=":"} {print $3}' | sed 's/ //'`
}

#Helper to get status of mute
get_mute_status(){
	TEMP_LINE=`pacmd list-sinks | grep -n "index: $SINK" | awk 'BEGIN {FS=":"} {print $1}'`
	TEMP_LINE=`expr $TEMP_LINE + 11`
	MUTE_STATUS=`pacmd list-sinks | head -n $TEMP_LINE | tail -1 | awk 'BEGIN {FS=" "} {print $2}'`
	if [ $MUTE_STATUS == "yes" ]
	then
		MUTE_STATUS="M"
	fi
}

#VOL
get_volume_level(){
	get_mute_status
	if [ $MUTE_STATUS == "M" ]
	then
		CURR_VOL="M"
		echo $CURR_VOL
		return
	fi
	TEMP_LINE=`pacmd list-sinks | grep -n "index: $SINK" | awk 'BEGIN {FS=":"} {print $1}'`
	TEMP_LINE=`expr $TEMP_LINE + 7`
	CURR_VOL=`pacmd list-sinks | head -n $TEMP_LINE | tail -1 | awk 'BEGIN {FS=" "} {print $5}'`
	echo $CURR_VOL
}

#CARD NAME of active sink
get_card_name(){
	TEMP_LINE=`pacmd list-sinks | grep -n '*' | awk 'BEGIN {FS=":"} {print $1}'`
	TEMP_LINE=`expr $TEMP_LINE + 36`
	CARD_NAME=`pacmd list-sinks | head -n $TEMP_LINE | tail -1 | awk 'BEGIN {FS="="} {print $2}' | sed 's/"//g'`
	echo $CARD_NAME
}

#Helper to display cards and sink numbers
get_cards_and_sinks(){
	CARD_CNT=`pacmd list-sinks | grep -n 'index' | wc -l`
	if [ $CARD_CNT -eq 0 ] 
	then
		echo "Error: No avaialble output sinks, exiting." >&2; exit 1
	fi
	for((cnt=1;cnt<=$CARD_CNT;cnt++))
	do
		OUT_VAR="INDEX:"`pacmd list-sinks | grep -n 'index' | sed ''$cnt'q;d' | awk 'BEGIN {FS=":"} {print $3}' | sed 's/ //g'`
		OUT_VAR=$OUT_VAR" - CARD:"`pacmd list-sinks | grep -n 'alsa.card_name' | sed ''$cnt'q;d' | awk 'BEGIN {FS="="} {print $2}' | sed -e 's/"//g' -e 's/^ //g' -e 's/$ //g'`
		echo $OUT_VAR
	done
}

#SET_ACTIVE
set_active_sink(){
	get_cards_and_sinks
	get_active_sink_number
	echo "**Active SINK Index: "$SINK
	echo "Enter Index Numer of SINK to change the default sink: "
	read IN_SINK
	#Validate input is a number
	re='^[0-9]+$'   
	if ! [[ $IN_SINK =~ $re ]] ; then
		echo "Error: Not a number, exiting." >&2; exit 1
	fi
	#Validate if input is within the sink index range
	if [ $IN_SINK -ge $CARD_CNT ] 
	then
		echo "Error: Not a valid SINK number, exiting." >&2; exit 1
	fi
	pacmd set-default-sink $IN_SINK
	get_active_sink_number
	echo "Current Active SINK Index: "$SINK
	sleep 3
}

#INC
increase_volume(){
	get_volume_level
	#IF mute then unmute
	if [ $MUTE_STATUS == "M" ]
	then
		toggle_volume_mute
		get_volume_level
	fi
	VOL_NUM=`echo $CURR_VOL | sed 's/%//'`
	NEW_VOL=`expr $VOL_NUM + $1`
	if [ $NEW_VOL -gt 100 ]
	then
		NEW_VOL=100
	fi
	pactl set-sink-mute $SINK false ; pactl -- set-sink-volume $SINK $NEW_VOL%
	echo $NEW_VOL
}	

#DEC
decrease_volume(){
	get_volume_level
	#IF mute then unmute
	if [ $MUTE_STATUS == "M" ]
	then
		toggle_volume_mute
		get_volume_level
	fi
	VOL_NUM=`echo $CURR_VOL | sed 's/%//'`
	NEW_VOL=`expr $VOL_NUM - $1`
	if [ $NEW_VOL -gt 100 ]
	then
		NEW_VOL=100
	fi
	pactl set-sink-mute $SINK false ; pactl -- set-sink-volume $SINK $NEW_VOL%
	echo $NEW_VOL
}	

#TOGGLE
toggle_volume_mute(){
	pactl set-sink-mute $SINK toggle
	get_mute_status
	if [ $MUTE_STATUS == "M" ]
	then
		echo $MUTE_STATUS
	else
		get_volume_level
	fi
}

if [ ! -n "$1" ]
then
	echo "Usage: `basename $0` VOL|INC|DEC|MUTE_TOG [INCR %AGE|DEC %AGE]|CARD|SET_ACTIVE" >&2; exit 1
fi  
#Store active sink number upfront
get_active_sink_number
case $1 in
	VOL) get_volume_level ;;
	INC) increase_volume $2;;
	DEC) decrease_volume $2;;
	MUTE_TOG) toggle_volume_mute;;
	CARD) get_card_name;;
	SET_ACTIVE) set_active_sink;;
	*) echo "Usage: `basename $0` VOL|INC %|DEC %|MUTE_TOG|CARD|SET_ACTIVE" >&2; exit 1
esac
exit 0
