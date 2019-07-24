#!/bin/bash

DATE=`date '+%F %R'`
F_DATE=`date '+%Y%m%d'`
FILE="/var/log/load/reboot_dir/test-rb_${F_DATE}.log"

CLK=`cat /sys/devices/system/clocksource/clocksource0/current_clocksource`
echo "[$DATE]: $CLK" >> $FILE

reboot