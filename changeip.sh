#!/bin/bash

clear
# Meminta input IP baru dari pengguna
read -p "Masukkan IP Akses: " changeip

# Variabel jalur file konfigurasi danted
JALUR_DANTED="/etc/danted.conf"

# Konfigurasi danted baru
NEW_DANTED="
logoutput: syslog /var/log/danted.log

internal: 0.0.0.0 port = 1080
external: ens3

method: none

clientmethod: none

client pass {
    from: $changeip/24 to: 0.0.0.0/0
    log: error
}

socks pass {
    from: $changeip/24 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: error
}"

# Menulis konfigurasi baru ke file danted.conf
echo "$NEW_DANTED" | sudo tee "$JALUR_DANTED" > /dev/null

# Restart layanan danted untuk menerapkan perubahan
sudo systemctl restart danted > /dev/null
