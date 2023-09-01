
#!/bin/bash
## lecture d'un message
cd /var/spool/gammu/inbox

## On récupère le numéro de téléphone par le nom du fichier :
## IN20230610_160718_00_+33612345678_00.txt
tel=`ls | awk -F"_" '{print $4}' `

command="Inconnu"

grep -i ON *
retVal=$?

if [ $retVal == 0 ]
then
    command="ON"
    gpio -1 write 12 1
fi

grep -i OFF *
retVal=$?

if [ $retVal == 0 ]
then
    command="OFF"
    gpio -1 write 12 0
fi
 
grep -i PASSWORD *
retVal=$?

if [ $retVal == 0 ]
then
    command="PASSWORD"
    PASSWD=`awk '{print $2}' * `
    CON_NAME=hotspot
    
    nmcli con down $CON_NAME
    nmcli con modify $CON_NAME wifi-sec.psk "${PASSWD}"
    nmcli con up $CON_NAME
fi

## suppression du message
rm *

## on envoie le SMS
msg="Receive message ${command}"
gammu-smsd-inject TEXT $tel -text "$msg"
