#!/bin/bash

clear
read -p "Socks name: " ngaran
read -p "Socks pass: " sentot

clear
echo "Sedang instalasi..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

JALUR_DANTED="/etc/danted.conf"
JALUR_SOCKD="/etc/pam.d/sockd"

NEW_DANTED="
internal: ens3 port = 1080
external: ens3

method: username

clientmethod: none
user.privileged: root
user.notprivileged: nobody
user.libwrap: nobody

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
}"

NEW_SOCKD="
auth       required     pam_unix.so
account    required     pam_unix.so
"

echo "$NEW_DANTED" | sudo tee "$JALUR_DANTED" > /dev/null

sudo useradd -m -s /bin/false $ngaran
echo "$ngaran:$sentot" | sudo chpasswd

echo "$NEW_SOCKD" | sudo tee "$JALUR_SOCKD" > /dev/null

sudo systemctl restart danted > /dev/null
sudo systemctl enable danted > /dev/null

public_ip=$(curl -s ifconfig.me)

clear

echo "======================PROXY SOCKS====================="
echo "$public_ip:1080:$ngaran:$sentot"
echo "==================CREATED BY DOT AJA=================="
