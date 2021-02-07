#!/bin/bash

# This script start the public OpenVPN server which doesn't allow clients to access 
# the local network

# $1: First argument - The configuration file
# $2: Secon argument - The configs directory [/server]
CONFIG=$1
CONFIG_DIR=${2:-/server}

# Get subnet ip & mask
SUBNET_IP=$(sed -nr 's/^server (.+?) (.+?)$/\1/p' ${CONFIG_DIR}/${CONFIG})
SUBNET_MASK=$(sed -nr 's/^server (.+?) (.+?)$/\2/p' ${CONFIG_DIR}/${CONFIG})

# Configure the  prohibited subnets if PROHIBITED_SUBNETS NOT NULL
DEFAULT_PROHIBITED_SUBNETS='10.0.0.0/8;172.16.0.0/12;192.168.0.0/16'
PROHIBITED_SUBNETS=${PROHIBITED_SUBNETS:-$DEFAULT_PROHIBITED_SUBNETS}

if [ -z "$ALLOW_ALL_SUBNETS" ]; then
    IFS=';' read -ra ARR <<< "$PROHIBITED_SUBNETS"
    for i in "${ARR[@]}"; do
        iptables -I INPUT -s ${SUBNET_IP}/${SUBNET_MASK} -d $i -j DROP
        iptables -I FORWARD -s ${SUBNET_IP}/${SUBNET_MASK} -d $i -j DROP
    done
fi

# Configure the allowed subnets if not NULL
# ALLOWED_SUBNETS=ip/mask;ip/mask;ip/mask
if [ ! -z "$ALLOWED_SUBNETS" ]; then
    IFS=';' read -ra ARR <<< "$ALLOWED_SUBNETS"
    for i in "${ARR[@]}"; do
        iptables -I INPUT -s ${SUBNET_IP}/${SUBNET_MASK} -d $i -j ACCEPT
        iptables -I FORWARD -s ${SUBNET_IP}/${SUBNET_MASK} -d $i -j ACCEPT
    done
fi

# Configure iptables to masquerate all vpn traffics
iptables -t nat -A POSTROUTING -s ${SUBNET_IP}/${SUBNET_MASK} -o eth0 -j MASQUERADE

# Run the openvpn command
openvpn --cd $CONFIG_DIR --config $CONFIG


