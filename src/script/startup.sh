#!/bin/sh -e

## run this script with a @reboot line in crontab, or with /etc/rc.local

dir=`dirname $0`

source ${dir}/config

gpio write ${GPIO_SERRURE} $FERME
gpio mode ${GPIO_SERRURE} out
## 0 change l'etat par rapport à pas de courant
gpio write ${GPIO_SERRURE} $FERME

GPIO21=$OFF
if [ -e ${dir}/ON ]
then
	GPIO21=$ON
fi

gpio write ${GPIO_POWER} $GPIO21
gpio mode ${GPIO_POWER} out
gpio write ${GPIO_POWER} $GPIO21

${dir}/sendSms.sh

