#!/bin/bash

clear
echo "==================CREATED BY DOT AJA=================="
echo "NOTE: masukan alamat ip sesuai urutan dari cloudsigma"
read -p "Masukkan alamat IP 1: " ip1
read -p "Masukkan alamat IP 2: " ip2
read -p "Masukkan alamat IP 3: " ip3
read -p "Masukkan alamat IP 4: " ip4

sleep 3

clear
read -p "Socks name: " ngaran
read -p "Socks pass: " sentot

clear
echo "Sedang instalasi..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear
echo "Setup network..."

sudo ip addr add $ip2/24 dev ens4 > /dev/null 2>&1
sudo ip addr add $ip3/24 dev ens5 > /dev/null 2>&1
sudo ip addr add $ip4/24 dev ens6 > /dev/null 2>&1

clear
echo "Network sukses..."

JALUR_DANTED="/etc/danted.conf"
JALUR_SOCKD="/etc/pam.d/sockd"

NEW_DANTED="
internal: ens3 port = 1080
external: ens3

internal: ens4 port = 1080
external: ens4

internal: ens5 port = 1080
external: ens5

internal: ens6 port = 1080
external: ens6

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

clear

echo "======================PROXY SOCKS====================="
echo "$ip1:1080:$ngaran:$sentot"
echo "$ip2:1080:$ngaran:$sentot"
echo "$ip3:1080:$ngaran:$sentot"
echo "$ip4:1080:$ngaran:$sentot"
echo "==================CREATED BY DOT AJA=================="
