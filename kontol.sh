#!/bin/bash

LICENSE_FILE=$(mktemp)

# Function to check if license is used
is_license_used() {
    local license=$1
    if grep -q "$license" "$LICENSE_FILE"; then
        return 0
    else
        return 1 
    fi
}

clear
read -p "Enter your license: " license

# Verify license
if ! curl -s -X POST -d "license=$license" https://dotaja.x10.bz/akses/validate.php | grep -q "valid"; then
    echo "Invalid or already used license."
    exit 1
fi

# Check if license is already used
if is_license_used "$license"; then
    echo "License has already been used."
    exit 1
fi

# Mark license as used
echo "$license" >> "$LICENSE_FILE"

# Check if license is in database
if ! curl -s -X POST -d "license=$license" https://dotaja.x10.bz/akses/check_license.php | grep -q "exists"; then
    echo "License not found in the database."
    exit 1
fi

echo "Script license is correct..."

sleep 5

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
