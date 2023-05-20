<h1 align="center">
  <br>
  <a href="https://www.associés.fr"><img src="doc/logo.png" alt="Antoine & Associés" width="300"></a>
</h1>

<h4 align="center">Box Airbnb -- domotics with SMS and Wifi</h4>

## Overview

Box Airbnb provides :

### Domotics by SMS messages

Based on gammu software, this allows to start/stop relay, by example to shut down power of an appartement when no one live there. Shutting down power can in cascade turn off watter by placing an electrovanne in the appartement 

### Door opening by selecting a wifi network with correct password

With a wifi network set as an access point, dhcp server can monitor when a wifi client as been connected. With this project: it opens a relay that can open a door.

## Hardware Requirement

### Informatics

Box Airbnb is designed for small Raspberry Pi cards with Wifi & GSM (2G, 3G) capabilities or with USB dongle if CPU cards does not supply wifi and / or GSM.

### Domotics

Some relay, adapted to GPIO 3V & 5V.

Dépending on your needs : an electronic locker, an electro-vanne...

## Software requirement

A linux, with isc-dhcp-server and gammu.

`apt-get install isc-dhcp-server gammu`

Utility "gpio" like [WiringPi](https://github.com/orangepi-xunlong/wiringOP "Gpio utility")

## Installation

Copy files in a directory

### Modify gammu configuration file, in `/etc/gammu-smsdrc`, in section `[smsd]` add

`RunOnReceive=/script/parseSMS.sh`

### Set wifi network as an access point

```
CON_NAME=Appartement_Antoine
nmcli con modify $CON_NAME 802-11-wireless.mode ap  802-11-wireless.band bg ipv4.method manual ipv4.addresses "192.168.10.1"
nmcli con modify $CON_NAME wifi-sec.key-mgmt wpa-psk
nmcli con modify $CON_NAME wifi-sec.psk password
nmcli con up $CON_NAME
```

### Modify dhcpd configuration

```
subnet 192.168.10.0 netmask 255.255.255.0 {
  range 192.168.10.10 192.168.10.100;
} 

on commit {
  execute("/script/onDhcpRun.sh", "commit", "","");
}
```
