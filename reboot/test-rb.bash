#!/bin/bash

DATE=`date '+%F %R'`
F_DATE=`date '+%Y%m%d'`
FILE="/var/log/load/reboot_dir/test-rb_${F_DATE}.log"

num_line=`wc -l $FILE`

if [ $num_line -lt 100 ]
then
    CLK=`cat /sys/devices/system/clocksource/clocksource0/current_clocksource`
    echo "[$DATE]: $CLK" >> $FILE

    reboot
else
    echo "already rebooted 100 times. finished this script." >> $FILE
fi
