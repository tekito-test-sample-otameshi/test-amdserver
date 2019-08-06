#!/bin/bash -u

start=`date '+%F %R'`
end=`date -d "1 day ${start}" '+%Y%m%d%H%M'` 

file_date=`date '+%Y%m%d'`
file="/home/load/${file_date}.log"

while [ `date +%Y%m%d%H%M` -le "$end" ]
do
    tmp_file=`mktemp /home/load/ipmi_tmp.XXX`    

    #log_date=`date '+%Y%m%d'`
    log_time=`date '+%H%M'`

    echo "[ITEM] | [${log_time}]" > $tmp_file
    ipmitool sdr list full | awk -F'|' -v OFS='|' '{print $1,$2}' | sort >> $tmp_file

    if [ -s $file ]
    then
        # If the file is not empty (already the result is written),
        cp_file=`mktemp /home/load/ipmi_tmp.XXX`    

	    #cat  $file > $cp_file
	    awk -F'|' -v OFS='|' '{print $2}' $tmp_file > $cp_file
        #join -t '|' $cp_file $tmp_file > $file
        paste -d '|' $file $cp_file

        rm -f $cp_file
    else
        # If the file is empty (this is first wrriting),
        cat $tmp_file > $file
    fi

    if [ ! -s $file ]
    then
        # When the the output of ipmi is not written in $file
        logger -ip local0.crit 'the result of ipmi cannnot be written in /home/load/`date +%Y%m%d`.log'
        exit 1
    fi

    rm -f $tmp_file

    sleep 600
done

#trap "rm -f $file" 2
