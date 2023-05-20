#!/bin/bash

dir=`dirname $0`

ladate=`date`
source ${dir}/config
echo "read SMS ${ladate}" >> /var/log/smsbox


if [ ! -d $INBOX ]
then
    echo "Configuration Error, check INBOX dir ${INBOX}" >> /var/log/smsbox
    exit
fi


count=`ls $INBOX | wc -l `
if [ $count -ne 1 ]
then
	echo "multiple messages - ignored" >> /var/log/smsbox
	rm $INBOX/*
	exit
fi
tel=`ls $INBOX |awk -F"_" '{print $4}' `
echo $tel | grep "^${PROPRIO}" |grep -v "+338"
retVal=$?
if [ $retVal -eq 1 ]
then
	echo "Tel ignored ${tel}" >> /var/log/smsbox 
	rm $INBOX/*
	exit
fi

grep -i ouvre $INBOX/*
retVal=$?

if [ $retVal -eq 0 ]
then
    echo "ouvre" >> /var/log/smsbox
    gpio write ${GPIO_SERRURE} $OUVERT
    sleep  10
    gpio write ${GPIO_SERRURE} $FERME
fi

grep -i OFF $INBOX/*
retVal=$?

if [ $retVal -eq 0 ]
then
    echo "off" >> /var/log/smsbox
    rm ${dir}/ON
    touch ${dir}/OFF
    gpio write ${GPIO_POWER} $OFF
fi

grep -i ON $INBOX/*
retVal=$?

if [ $retVal -eq 0 ]
then
    echo "on" >> /var/log/smsbox
    rm ${dir}/OFF
    touch ${dir}/ON
    gpio write ${GPIO_POWER} $ON
fi

grep -i REBOOT $INBOX/*
retVal=$?

if [ $retVal -eq 0 ]
then
    echo "reboot" >> /var/log/smsbox
    reboot
    exit
fi

grep -i password $INBOX/*
retVal=$?
if [ $retVal -eq 0 ]
then
    echo "change password" >> /var/log/smsbox
    PASSWD=`awk '{print $2}' ${INBOX}/*`
    echo $PASSWD >> /var/log/smsbox
    CON_NAME=Hotspot
    
    nmcli con down $CON_NAME
    nmcli con modify $CON_NAME wifi-sec.psk "${PASSWD}"
    nmcli con up $CON_NAME
fi

${dir}/sendSms.sh $tel


rm $INBOX/*


