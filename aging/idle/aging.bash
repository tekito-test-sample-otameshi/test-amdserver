#!/bin/bash -u

# Description
#   Main script of aging test.
#   You need other scripts below when executing this script.
#        + measure.bash
#        + get-ipmi.bash

test_time="86400"

# main command
IPMI_VAL="/var/tmp/load/aging/get-ipmi.bash"

MEASURE () {
    measure="/var/tmp/load/aging/measure.bash"

    for i in {1..2}
    do
        eval ${measure}
        sleep 43200
    done
}

# main process
sleep 86400 & sleep 300 
eval ${IPMI_VAL} & MEASURE

cat /var/log/messages > /var/log/load/aging/messages_`date +%Y%m%d`.log

exit 0
