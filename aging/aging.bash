#!/bin/bash -u

# Description
#   Main script of aging test.
#   You need other scripts below when executing this script.
#        + measure.bash
#        + get-ipmi.bash

test_time="86400"

## get info
#thread=`grep '^processor[^:]*:' /proc/cpuinfo | wc -l`
#mem=`grep --max-count=1 '^MemTotal:' /proc/meminfo | awk '{ print $2 }'`
#mem_90=`echo "${mem} * 0.9" | bc | cut -d. -f1`

# main command
#LOAD_CMS="stress --cpu ${thread} --vm 1 --vm-keep --vm-bytes ${mem_90} --hdd 2 --hdd-bytes 10G --timeout ${test_time}s &" 
IPMI_VAL="/var/tmp/load/aging/get-ipmi.bash"

MEASURE () {
    measure="/var/tmp/load/aging/measure.bash"

    for i in {1..3}
    do
        eval ${measure}
        sleep 43200
    done
}

# main process
sleep 86400 & sleep 300 
eval ${IPMI_VAL} & MEASURE

exit 0
