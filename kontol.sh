#!/bin/bash

clear
echo "==================CREATED BY DOT AJA=================="
read -p "Masukkan alamat IP 1: " ip1
read -p "Masukkan alamat IP 2: " ip2
read -p "Masukkan alamat IP 3: " ip3
read -p "Masukkan alamat IP 4: " ip4

clear

echo "Setup jaringan..."

ip addr add $ip2/24 dev ens4
ip addr add $ip3/24 dev ens5
ip addr add $ip4/24 dev ens6

clear

echo "Sukses..."
clear
echo "Setup paket..."

# Memastikan untuk menggunakan apt-get untuk distribusi yang tidak menggunakan apt
if [ -x "$(command -v apt-get)" ]; then
    apt-get update > /dev/null 2>&1
    apt-get install -y dante-server > /dev/null 2>&1
elif [ -x "$(command -v yum)" ]; then
    yum update -y > /dev/null 2>&1
    yum install -y dante-server > /dev/null 2>&1
else
    echo "Manajer paket tidak didukung."
    exit 1
fi

clear

echo "Sukses..."

CONFIG_FILE="/etc/danted.conf"

NEW_CONFIG="
internal: ens3 port = 1080
external: ens3

internal: ens4 port = 1080
external: ens4

internal: ens5 port = 1080
external: ens5

internal: ens6 port = 1080
external: ens6

method: username

user.privileged: dot ens3 dot1
user.privileged: dot ens4 dot2
user.privileged: dot ens5 dot3
user.privileged: dot ens6 dot4

client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
}

if [ -w "$CONFIG_FILE" ]; then
    # Menulis konfigurasi baru ke file
    echo "$NEW_CONFIG" > "$CONFIG_FILE"
    echo "Konfigurasi Dante berhasil diterapkan."
else
    echo "Gagal menerapkan konfigurasi Dante: $CONFIG_FILE"
    echo "Pastikan Anda memiliki izin yang sesuai atau jalankan skrip ini dengan sudo."
fi

# Restart dan aktifkan layanan Dante

sudo systemctl restart danted

sudo systemctl enable danted

clear

echo "======================================================"
echo "SOCKS1 : $ip1:1080:dot:dot1"
echo "SOCKS2 : $ip2:1080:dot:dot2"
echo "SOCKS3 : $ip3:1080:dot:dot3"
echo "SOCKS4 : $ip4:1080:dot:dot4"
echo "================ CREATED BY DOT AJA =================="
