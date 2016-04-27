#!/bin/bash - 
#===============================================================================
#
#          FILE: toggle-process.sh
# 
#         USAGE: ./toggle-process.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Nitin Mathew (), nitn.mathew2000@hotmail.com
#  ORGANIZATION: 
#       CREATED: 14/03/2016 22:50
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
if pgrep -x $1 > /dev/null; then
	pkill $1
else
	$1 &
fi

