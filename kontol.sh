#!/bin/bash

clear
echo "==================CREATED BY DOT AJA=================="
read -p "Masukkan alamat IP 1: " ip1
read -p "Masukkan alamat IP 2: " ip2
read -p "Masukkan alamat IP 3: " ip3
read -p "Masukkan alamat IP 4: " ip4

clear
echo "download danted..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear
echo "download sukses..."

CONFIG_FILE="/etc/danted.conf"

clear
echo "setup network..."

ip addr add $ip2/24 dev ens4 > /dev/null 2>&1
ip addr add $ip3/24 dev ens5 > /dev/null 2>&1
ip addr add $ip4/24 dev ens6 > /dev/null 2>&1

clear
echo "sukses..."

NEW_CONFIG="
internal: ens3 port = 1080
external: ens3

internal: ens4 port = 1080
external: ens4

internal: ens5 port = 1080
external: ens5

internal: ens6 port = 1080
external: ens6

method: none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
}"

if [ -w "$CONFIG_FILE" ]; then
    # Menulis konfigurasi baru ke file
    echo "$NEW_CONFIG" > "$CONFIG_FILE"
    echo "setup sukses..."
else
    echo "setup gagal: $CONFIG_FILE"
    echo "Pastikan kamu memiliki izin yang diperlukan atau jalankan skrip ini dengan sudo"
fi

sudo systemctl restart danted

sudo systemctl enable danted

clear

echo "======================================================"
echo "SOCKS1 : $ip1:1080: "
echo "SOCKS2 : $ip2:1080: "
echo "SOCKS3 : $ip3:1080: "
echo "SOCKS4 : $ip4:1080: "
echo "==================CREATED BY DOT AJA=================="
