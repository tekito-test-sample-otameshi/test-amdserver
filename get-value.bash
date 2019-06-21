#!/bin/bash -u

FUNC () {
    echo "$list" | while read file
    do
        echo "$item" | while read item_line
        do
            grep $item_line $file | awk -F' ' '{print $3}' >> /var/log/load/ipmi_${item_line}.tmp
        done
    done
}

cd /var/log/load/20190531
list=`ls -A -1`
samp_file=`echo "$list" | head -n 1`
item=`awk -F' ' '{print $1}' $samp_file | sort | uniq | grep -v "/"`
FUNC

cd /var/log/load/20190601
list=`ls -A -1 | head -n 18`
FUNC
