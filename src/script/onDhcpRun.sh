#!/bin/bash

dir=`dirname $0`

source ${dir}/config

gpio -1 write ${GPIO_SERRURE} $OUVERT
sleep 2
gpio -1 write ${GPIO_SERRURE} $FERME

#



