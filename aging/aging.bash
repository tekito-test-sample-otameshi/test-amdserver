#!/bin/bash -u

test_time="86400"

# get info
thread=`grep '^processor[^:]*:' /proc/cpuinfo | wc -l`
mem=`grep --max-count=1 '^MemTotal:' /proc/meminfo | awk '{ print $2 }'`
mem_90=`echo "${mem} * 0.9" | bc | cut -d. -f1`

# main command
LOAD_CMS="stress --cpu ${thread} --vm 1 --vm-keep --vm-bytes ${mem_90} --hdd 2 --hdd-bytes 10G --timeout ${test_time}s &" 
## On the client, the command below is executed.
##      $ iperf -c 172.31.13.47 -t $test_time
#LOAD_NIC="iperf -s"

# main process
#${LOAD_CMS} & ${LOAD_NIC}
eval ${LOAD_CMS}  

exit 0