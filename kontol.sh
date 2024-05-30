#!/bin/bash

clear
echo "==================CREATED BY DOT AJA=================="
read -p "Masukkan alamat IP 1: " ip1
read -p "Masukkan alamat IP 2: " ip2
read -p "Masukkan alamat IP 3: " ip3
read -p "Masukkan alamat IP 4: " ip4

clear
echo "setup bahan coli..."

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

clear
echo "sukses..."

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

# Menetapkan metode autentikasi
method: username

# Daftar pengguna dengan password berbeda untuk setiap proxy
user.privileged: dot ens3 dot1
user.privileged: dot ens4 dot2
user.privileged: dot ens5 dot3
user.privileged: dot ens6 dot4

# Memberikan akses ke semua klien
client pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    log: connect disconnect error
}

# Memberikan izin akses ke semua koneksi
pass {
    from: 0.0.0.0/0 to: 0.0.0.0/0
    protocol: tcp udp
}

if [ -w "$CONFIG_FILE" ]; then
    # Menulis konfigurasi baru ke file
    echo "$NEW_CONFIG" > "$CONFIG_FILE"
    echo "ALAT COLI BERHASIL DI TERAPKAN"
else
    echo "ALAT COLI GAGAL DI TERAPKAN: $CONFIG_FILE"
    echo "Pastikan kamu memiliki izin yang diperlukan atau jalankan skrip ini dengan sudo."
fi

sudo systemctl restart danted
sudo systemctl enable danted

clear
echo "======================================================"
echo "SOCKS 1 : $ip1:1080:dot:dot1"
echo "SOCKS 2 : $ip2:1080:dot:dot2"
echo "SOCKS 3 : $ip3:1080:dot:dot3"
echo "SOCKS 4 : $ip4:1080:dot:dot4"
echo "==================CREATED BY DOT AJA=================="
