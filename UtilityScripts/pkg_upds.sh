#!/bin/bash

get_official_update_count(){
	cnt=`pacman -Q -u | wc -l`
	echo $cnt
}

get_aur_update_count(){
	cnt=`cower -u | wc -l`
	echo $cnt
}

case $1 in
	OFFICIAL) get_official_update_count ;;
	AUR) get_aur_update_count;;
esac
exit 0
