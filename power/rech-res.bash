#!/bin/bash -u

start=`date '+%F %R'`
end=`date -d "1 day ${start}" '+%Y%m%d%H%M'` 

file_date=`date '+%Y%m%d'`
file="/var/log/load/${file_date}.log"

tmp_file=`mktemp /var/log/load/ipmi_tmp.XXX`    

log_time=`date '+%H%M'`

echo "[YYYYMMDD] | [${log_time}]" > $tmp_file
ipmitool sdr list full | awk -F'|' -v OFS='|' '{print $1,$2}' >> $tmp_file

if [ -s $file ]
then
    # If the file is not empty (already the result is written),
    cp_file=`mktemp /var/log/load/ipmi_tmp.XXX`    

    cat $file > $cp_file
    join -t '|' $cp_file $tmp_file > $file

    rm -f $cp_file
else
    # If the file is empty (this is first wrriting),
    cat $tmp_file > $file
fi

if [ ! -s $file ]
then
    # When the the output of ipmi is not written in $file
    logger -ip local0.crit 'the result of ipmi cannnot be written in /var/log/load/`date +%Y%m%d`.log'
    exit 1
fi

rm -f $tmp_file
