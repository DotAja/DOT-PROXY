#!/bin/bash

clear

echo "Loading..."

sudo apt update
sudo apt install dante-server

CONFIG_FILE="/etc/danted.conf"

NEW_CONFIG="
internal: ens3 port = 1080
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
echo "██████╗  ██████╗ ████████╗     █████╗      ██╗ █████╗"
echo "██╔══██╗██╔═══██╗╚══██╔══╝    ██╔══██╗     ██║██╔══██╗"
echo "██║  ██║██║   ██║   ██║       ███████║     ██║███████║"
echo "██║  ██║██║   ██║   ██║       ██╔══██║██   ██║██╔══██║"
echo "██████╔╝╚██████╔╝   ██║       ██║  ██║╚█████╔╝██║  ██║"
echo "╚═════╝  ╚═════╝    ╚═╝       ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚═╝"
echo "=============created By Hendi Kusnandi================"
echo "GUNAKAN AKSES SSH YANG SUPPORT PORT 22"
echo "SOCKS PROXY : $public_ip:1080"
echo "======================================================"
