#!/bin/bash

clear

echo "setup dan install..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear

echo "sukses..."

JALUR_DANTED="/etc/danted.conf"

NEW_DANTED="
logoutput: syslog /var/log/danted.log

internal: 0.0.0.0 port = 1080
external: ens3

method: none

clientmethod: none
user.privileged: root
user.notprivileged: nobody
user.libwrap: nobody

client pass {
    from: 103.181.182.227 to: 0.0.0.0/0
    log: error
}

socks pass {
    from: 103.181.182.227 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: error
}"

echo "$NEW_DANTED" | sudo tee "$JALUR_DANTED" > /dev/null

sudo systemctl restart danted > /dev/null
sudo systemctl enable danted > /dev/null

public_ip=$(curl -s ifconfig.me)

clear

echo "======================================================"
echo "SOCKS PROXY"
echo "$public_ip:1080"
echo "==================CREATED BY DOT AJA=================="
