#!/bin/bash -u

start=`date -d '5 minutes' '+%F %R'`
start_24=`date -d "1 day ${start}" '+%Y%m%d%H%M'` # the argument for get-ipmi.bash
path="/var/tmp/load/aging"

## Main
sleep 86400 & \
sleep 300 ; \
{ ${path}/get-ipmi.bash ${start_24} ; \
${path}/measure.bash ; } ; \
sleep 43200 ; \
${path}/measure.bash ; \
sleep 43200 ; \
${path}/measure.bash  