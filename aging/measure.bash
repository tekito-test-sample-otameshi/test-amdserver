#!/bin/bash -u

# recording files
log_dir="/home/load/aging"
mpstat_f="${log_dir}/mpstat/mpstat_`date +%Y%m%d%H%M`.log"
vmstat_f="${log_dir}/vmstat/vmstat_`date +%Y%m%d%H%M`.log"
iostat_f="${log_dir}/iostat/iostat_`date +%Y%m%d%H%M`.log"
loadavg_f="${log_dir}/loadavg/loadavg_`date +%Y%m%d%H%M`.log"

for DIR in mpstat vmstat iostat loadavg
do 
    if [ ! -d /home/load/aging/$DIR ]
    then
        mkdir -p /home/load/aging/$DIR 
    fi
done

# recording commands
MPSTAT="date '+----- %Y/%m/%d %H:%M:%S' >> ${mpstat_f} ; mpstat 1 10 >> ${mpstat_f}"
VMSTAT="date '+----- %Y/%m/%d %H:%M:%S' >> ${vmstat_f} ; vmstat 1 10 >> ${vmstat_f}"
IOSTAT="date '+----- %Y/%m/%d %H:%M:%S' >> ${iostat_f} ; iostat -x 1 10 >> ${iostat_f}"
LOADAVG () {
    for i in `seq 1 5`
    do
        date '+----- %Y/%m/%d %H:%M:%S' >> ${loadavg_f} 
        cat /proc/loadavg >> ${loadavg_f}
        sleep 5
    done
}

eval $MPSTAT & eval $VMSTAT & eval $IOSTAT & LOADAVG &
