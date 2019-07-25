#!/bin/bash

DATE=`date '+%F %R'`
F_DATE=`date '+%Y%m%d'`
FILE="/var/log/load/reboot_dir/test-rb_${F_DATE}.log"

num_line=`wc -l $FILE`

if [ -s $FILE ]
then
    if [ $num_line -ge 100 ]
    then
        echo "already rebooted 100 times. finished this script." >> $FILE
        exit 
    fi
fi    

CLK=`cat /sys/devices/system/clocksource/clocksource0/current_clocksource`
echo "[$DATE]: $CLK" >> $FILE

reboot