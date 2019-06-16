#!/bin/#!/usr/bin/env bash

#

# this script displays some host identification information for a simple Linux machine

#

# Sample output:

#   Hostname        : hostname

#   LAN Address     : 192.168.2.2

#   LAN Hostname    : host-name-from-hosts-file

#   External IP     : 1.2.3.4

#   External Name   : some.name.from.our.display

# Task 1: Add a section to the script to define variables which hold the output data for (( i = 0; i <
#         each output item and move the commands which generate the data to that section so that

#         the output command only outputs the labels and single variables.



# Task 2: Add output items for the default router's name and IP address,

#         adding a name to your /etc/hosts file as needed.

# e.g.

#   Router Address  : 192.168.2.1

#   Router Hostname : router-name-from-hosts-files

# Task 3: Add output items for the network's name and IP address, adding a name to your /etc/networks file as needed.

# e.g.

#   Network Number. : 192.168.2.0

#   Network Name    : network-name-from-networks-files

# we use the hostname command to get our system name

# the LAN name is looked up using the LAN address in case it is different from the system name

# finding external information relies on curl being installed and relies on live internet connection

# awk is used to extract only the data we want displayed from the commands which produce extra data

# this command is ugly done this way, so generating the output data into variables is recommended to make the script more readable.

# e.g.

#   interface_name=$(ip a |awk '/: e/{gsub(/:/,"");print $2}')

myhostname=$(hostname)

interface=$(ip a | awk '/: e/{gsub(/:/,"");print $2}')

lan_ipaddress=$(ip a s $interface | awk '/inet /{gsub(/\/.*/,"");print $2}')

lan_hostname=$(getent hosts $lan_ipaddress | awk '{print $2}')

router_address=$(route -n | grep 'UG[ \t]' | awk '{print $2}')

external_ip=$(curl -s icanhazip.com)

external_name=$(getent hosts $external_ip | awk '{print $2}')

router_hostname=$(route | grep "default" | awk '{ print $2 }')

network_number=$(cat /etc/networks | awk 'NR==3{print $2; exit}')

network_name=$(cat /etc/networks | awk 'NR==3{print $1; exit}')

#$(cat /etc/networks | grep  -E '^(192\.168|10\.|172\.1[6789]\.|172\.2[0-9]\.|172\.3[01]\.)')

#$(cat /etc/networks | grep "$router_hostname" | awk '{ print $2 }')

#Router   : $(ip route | grep default | awk '{print $3}')

#Router Name   : $(getent hosts `ip route|grep 'default '|awk '{print $3}'|sed 's,/.*,,'` | awk '{print $2}')

#Network   : $(ip route | awk '{print $1}' | grep 172 |sed 's,/.*,,')

#Network Name  : $(getent hosts `ip route|awk '{print $1}'|grep 172 |sed 's,/.*,,'` | awk '{print $2}')

cat <<EOF

Hostname        : $myhostname

LAN Address     : $lan_ipaddress
LAN Hostname    : $lan_hostname
External IP     : $external_ip
External Name   : $external_name
Router Address  : $router_address
Router Hostname : $router_hostname
Network Number  : $network_number
Network Name    : $network_name
EOF
