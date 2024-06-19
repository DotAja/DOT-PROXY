#!/bin/bash

# URL untuk memverifikasi lisensi
VERIF_URL="https://dotaja.x10.bz/lisence/verify_lisence.php"
# URL untuk menghapus lisensi
DELET_URL="https://dotaja.x10.bz/lisence/delete_lisence.php"

# Fungsi untuk memverifikasi lisensi dengan server
verify_license() {
    LICENSE_KEY=$1
    clear
    RESPONSE=$(curl -s -X POST -d "license_key=$LICENSE_KEY" $VERIF_URL)
    if [ "$RESPONSE" == "valid" ]; then
        return 0
    else
        return 1
    fi
}

# Fungsi untuk menghapus lisensi di server setelah digunakan
remove_license_from_server() {
    LICENSE_KEY=$1
    curl -s -X POST -d "license_key=$LICENSE_KEY" $DELET_URL
}

# Meminta input dari pengguna untuk kunci lisensi
clear
echo "==================CREATED BY DOT AJA=================="
read -p "Masukkan FREE lisensi: " LICENSE_KEY

# Verifikasi lisensi
if verify_license "$LICENSE_KEY"; then
    bash -c "$(wget -qO- https://raw.githubusercontent.com/DotAja/DOT-PROXY/main/kontol.sh)"
    
    remove_license_from_server "$LICENSE_KEY"
else
    echo "==================CREATED BY DOT AJA=================="
    echo "            UNTUK MENDAPATKAN FREE LISENCE"
    echo "                https://dotaja.x10.bz"
    echo "            UNTUK SCRIPT VIP BISA HUBUNGI"
    echo "             https://bit.ly/buy_socks-dot"
    echo "======================================================"
fi
