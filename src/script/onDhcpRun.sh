#!/bin/bash

dir=`dirname $0`

source ${dir}/config

gpio write ${GPIO_SERRURE} $OUVERT
sleep 2
gpio write ${GPIO_SERRURE} $FERME

#



