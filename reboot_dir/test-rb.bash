#!/bin/bash

DATE=`date '+%F %R'`
F_DATE=`date '+%Y%m%d'`
FILE="/home/load/reboot_dir/test-rb_${F_DATE}.log"

num_line=`cat $FILE | wc -l`

if [ -s $FILE ]
then
    if [ $num_line -ge 101 ]
    then
        echo "already rebooted 100 times. finished this script." >> $FILE
        exit 
    fi
fi    

CLK=`cat /sys/devices/system/clocksource/clocksource0/current_clocksource`
echo "[$DATE]: $CLK" >> $FILE

reboot
