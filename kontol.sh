#!/bin/bash

clear
echo "download danted..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear
echo "download sukses..."

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
    echo "danted berhasil di setup..."
else
    echo "danted gagal di setup: $CONFIG_FILE"
    echo "Pastikan kamu memiliki izin yang diperlukan atau jalankan skrip ini dengan sudo"
fi

sudo systemctl restart danted
sudo systemctl enable danted

ip1=$(ip addr show ens3 | grep -oP 'inet \K\S+')
ip2=$(ip addr show ens4 | grep -oP 'inet \K\S+')
ip3=$(ip addr show ens5 | grep -oP 'inet \K\S+')
ip4=$(ip addr show ens6 | grep -oP 'inet \K\S+')

clear

echo "======================================================"
echo "SOCKS1 : $ip1:1080 "
echo "SOCKS2 : $ip2:1080 "
echo "SOCKS3 : $ip3:1080 "
echo "SOCKS4 : $ip4:1080 "
echo "==================CREATED BY DOT AJA=================="
