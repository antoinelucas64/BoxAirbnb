#!/bin/bash

dir=`dirname $0`

ladate=`date`
source ${dir}/config
echo "read SMS ${ladate}" >> /var/log/smsbox

cd /var/spool/gammu/inbox
count=`ls | wc -l `
if [ $count -ne 1 ]
then
	echo "multiple messages - ignored" >> /var/log/smsbox
	rm *
	exit
fi
tel=`ls  |awk -F"_" '{print $4}' `
echo $tel | grep "^${PROPRIO}" |grep -v "+338"
retVal=$?
if [ $retVal -eq 1 ]
then
	echo "erreur tel" >> /var/log/smsbox 
	rm *
	exit
fi

echo "get it ${tel}" >> /var/log/smsbox

grep -i ouvre /var/spool/gammu/inbox/*
retVal=$?

if [ $retVal -eq 0 ]
then
	echo "ouvre" >> /var/log/smsbox
	gpio write ${GPIO_SERRURE} $OUVERT
	sleep  10
        gpio write ${GPIO_SERRURE} $FERME

fi

grep -i OFF /var/spool/gammu/inbox/*
retVal=$?

if [ $retVal -eq 0 ]
then
	rm ${dir}/ON
	touch ${dir}/OFF
	gpio write ${GPIO_POWER} $OFF
fi

grep -i ON /var/spool/gammu/inbox/*
retVal=$?

if [ $retVal -eq 0 ]
then
	rm ${dir}/OFF
	touch ${dir}/ON
        gpio write ${GPIO_POWER} $ON
fi

grep -i REBOOT /var/spool/gammu/inbox/*
retVal=$?

if [ $retVal -eq 0 ]
then
	reboot
	exit
fi

grep -i password  /var/spool/gammu/inbox/*
retVal=$?
if [ $retVal -eq 0 ]
then
	PASSWD=`awk '{print $2}' /var/spool/gammu/inbox/*`
	echo $PASSWD >> /var/log/smsbox
	CON_NAME=Hotspot

	nmcli con down $CON_NAME
	nmcli con modify $CON_NAME wifi-sec.psk "${PASSWD}"
	nmcli con up $CON_NAME

fi

${dir}/sendSms.sh $tel


rm *


