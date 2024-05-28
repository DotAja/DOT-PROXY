#!/bin/bash

clear

echo "setup dan install..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear

echo "sukses..."

CONFIG_FILE="/etc/danted.conf"

NEW_CONFIG="
internal: ens3 port = 443
external: ens3

method: username none

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: connect disconnect error
}"

if [ -w "$CONFIG_FILE" ]; then
    # Menulis konfigurasi baru ke file
    echo "$NEW_CONFIG" > "$CONFIG_FILE"
    echo "Konfigurasi Dante telah berhasil diperbarui."
else
    echo "Tidak dapat menulis ke file konfigurasi: $CONFIG_FILE"
    echo "Pastikan kamu memiliki izin yang diperlukan atau jalankan skrip ini dengan sudo."
fi

sudo systemctl restart danted

public_ip=$(curl -s ifconfig.me)

clear

echo "======================================================"
echo "SOCKS PROXY : $public_ip:443"
echo "==================CREATED BY DOT AJA=================="
