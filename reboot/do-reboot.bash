#!/bin/bash -u

file="/var/log/load/do-reboot.log"
date_form=`date '+[%F %R:%S]'`
msg=`cat /sys/devices/system/clocksource/clocksource0/available_clocksource`

echo "${date_form} clocksource: $msg" >> $file

reboot