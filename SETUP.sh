#!/bin/bash

clear

echo "setup dan install..."

apt update -y > /dev/null 2>&1
apt install dante-server -y > /dev/null 2>&1

clear

echo "sukses..."

wget -O /tmp/danted.conf raw.githubusercontent.com/DotAja/DOT-PROXY/main/danted.conf

sudo mv /tmp/danted.conf /etc/danted.conf

systemctl restart danted
systemctl enable danted

public_ip=$(curl -s ifconfig.me)

clear

echo "======================================================"
echo "SOCKS PROXY : $public_ip:1080"
echo "==================CREATED BY DOT AJA=================="
