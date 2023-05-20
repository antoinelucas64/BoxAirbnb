#!/bin/bash

dir=`dirname $0`

source ${dir}/config

nbArg=$#
  
value=`gpio read ${GPIO_POWER}`

status="ON"
if [ $value -eq $OFF ]
then
	status="OFF"
fi

ladate=`date`

PASSWD=`grep -E "^psk" /etc/NetworkManager/system-connections/Hotspot.nmconnection | awk -F = '{print $2}'`

MSG="l'appartement est $status (password=${PASSWD}). Commandes: ON, OFF, OUVRE, REBOOT, PASSWORD xxxx. [ ${ladate} ]"



if [ $nbArg -eq 1 ]
then
	tel=$1
   	if [ $tel != $PROPRIO ]
	then
	    echo "send sms $tel $MSG" >> /var/log/smsbox
	    gammu-smsd-inject  TEXT $tel -text "$MSG" &>> /var/log/smsbox
	fi
else
    tel=$PROPRIO
fi

echo "send sms $PROPRIO $MSG" >> /var/log/smsbox

gammu-smsd-inject  TEXT $PROPRIO -text "$MSG" &>> /var/log/smsbox



