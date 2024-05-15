#!/bin/bash

clear

echo "setup dan install..."

apt update -y > /dev/null 2>&1
apt install dante-server -y > /dev/null 2>&1

clear

echo "sukses..."

URL_GH="raw.githubusercontent.com/DotAja/DOT-PROXY/main"
JALUR_DANTED="/etc/danted.conf"
JALUR_SERVICE="/etc/systemd/system/danted.service"

wget -q "$URL_GH/danted.conf" -O "$JALUR_DANTED"
wget -q "$URL_GH/danted.service" -O "$JALUR_SERVICE"

systemctl restart danted
systemctl enable danted

public_ip=$(curl -s ifconfig.me)

clear

echo "======================================================"
echo "SOCKS PROXY : $public_ip:1080"
echo "==================CREATED BY DOT AJA=================="
