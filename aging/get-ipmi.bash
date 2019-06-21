#!/bin/bash -u

# *** Please set one value, the time after 24 hours since you start this script with the form of XXXXYYMM ***
#    Example: When you start this script at 2019-06-06 10:30,
#             execute "./get-ipmi.bash 201906071030"

end=${1:?}
file_date=`date '+%Y%m%d'`
file="/var/log/load/${file_date}.log"

while [ `date +%Y%m%d%H%M` -le "$end" ]
do
    tmp_file=`mktemp /var/log/load/ipmi_tmp.XXX`    
    cp_file=`mktemp /var/log/load/ipmi_tmp.XXX`    

    log_date=`date '+%Y%m%d'`
    log_time=`date '+%H%M'`

    echo "[${log_date}] | [${log_time}]" > $tmp_file
    ipmitool sdr list full | awk -F'|' -v OFS='|' '{print $1,$2}' >> $tmp_file

    if [ -s $file ]
    then
        # If the file is not empty (already the result is written),
	cat $file > $cp_file
        join -t '|' $cp_file $tmp_file > $file
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
    rm -f $cp_file

    sleep 600
done

#trap "rm -f $file" 2
