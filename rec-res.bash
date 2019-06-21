#!/bin/bash -u

dir_date=`date '+%Y%m%d-%H'`
dir="/var/log/load/${dir_date:0:8}"
file="${dir}/${dir_date}.log"

if [ ! -d "${dir}" ]
then
    mkdir -p ${dir}
fi

date '+%Y/%d/%m %H:%M' >> $file
ipmitool sdr list full >> $file