#!/bin/bash

# Memastikan bahwa skrip dijalankan dengan izin root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Periksa apakah dialog sudah terinstal, jika tidak, instal dialog
if ! command -v dialog &> /dev/null; then
    echo "dialog could not be found, installing..."
    apt-get update
    apt-get install -y dialog
fi

# Buat skrip menu di /usr/bin
MENU_SCRIPT_PATH="/usr/bin/menu"
cat << 'EOF' > $MENU_SCRIPT_PATH
#!/bin/bash

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="DOT TERMINAL"
TITLE="DOT PROXY"
MENU="PILIH ALAT:"

OPTIONS=(
    1 "Start danted"
    2 "Stop danted"
    3 "BELOM JADI"
    4 "Exit"
)

while true; do
    CHOICE=$(dialog --clear \
                    --backtitle "$BACKTITLE" \
                    --title "$TITLE" \
                    --menu "$MENU" \
                    $HEIGHT $WIDTH $CHOICE_HEIGHT \
                    "${OPTIONS[@]}" \
                    2>&1 >/dev/tty)

    clear

    case $CHOICE in
        1)
            echo "Starting danted service..."
            sudo systemctl start danted
            echo "danted service started."
            ;;
        2)
            echo "Stopping danted service..."
            sudo systemctl stop danted
            echo "danted service stopped."
            ;;
        3)
            echo "You chose Option 3"
            # Tambahkan perintah untuk Option 3 di sini
            ;;
        4)
            echo "Exiting"
            break
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
    read -p "Press [Enter] to continue..."
done
EOF

# Beri izin eksekusi pada skrip
chmod +x $MENU_SCRIPT_PATH

# Tambahkan skrip ke ~/.bashrc jika belum ada
BASHRC_LINE='if [ -t 1 ]; then /usr/bin/menu; fi'
grep -qxF "$BASHRC_LINE" /home/$SUDO_USER/.bashrc || echo "$BASHRC_LINE" >> /home/$SUDO_USER/.bashrc

# Sumber ulang ~/.bashrc
source /home/$SUDO_USER/.bashrc

echo "Installation complete. Open a new terminal to see the menu."
