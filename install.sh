NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[36;1m'
WB='\e[37;1m'

clear
echo -e "${GB}[ INFO ]${NC} ${YB}Setup and installing${NC}"

apt update > /dev/null 2>&1
apt install dante-server > /dev/null 2>&1

linkdot="https://raw.githubusercontent.com/DotAja/DOT-PROXY/main"

wget -O /usr/bin/menu $linkdot/menu.sh  > /dev/null 2>&1
wget -O /usr/bin/changeip $linkdot/changeip.sh  > /dev/null 2>&1

chmod +x /usr/bin/menu  > /dev/null 2>&1
chmod +x /usr/bin/changeip  > /dev/null 2>&1

echo 'clear' >> ~/.bashrc  > /dev/null 2>&1
echo 'menu' >> ~/.bashrc > /dev/null 2>&1

JALUR_DANTED="/etc/danted.conf"

NEW_DANTED="
logoutput: syslog /var/log/danted.log

internal: 0.0.0.0 port = 1080
external: ens3

method: none

clientmethod: none

client pass {
    from: 152.42.178.71/24 to: 0.0.0.0/0
    log: error
}

socks pass {
    from: 152.42.178.71/24 to: 0.0.0.0/0
    command: bind connect udpassociate
    log: error
}"

echo "$NEW_DANTED" | sudo tee "$JALUR_DANTED" > /dev/null

systemctl restart danted > /dev/null
systemctl enable danted > /dev/null

clear

echo -e "${GB}[ INFO ]${NC} ${YB}Sukses...${NC}"

sleep 10

clear
echo ""
echo ""
echo -e "${BB}—————————————————————————————————————————————————————————${NC}"
echo -e "                    ${WB}XRAY SCRIPT BY DOT${NC}"
echo -e "${BB}—————————————————————————————————————————————————————————${NC}"
echo -e "              ${WB}»»» Proxy Socks5 akses Ip only «««${NC}  "
echo -e "${BB}—————————————————————————————————————————————————————————${NC}"
echo -e "  ${GB}- NOTE : untuk menggunakan proxy socks wajib change ip${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo ""
echo ""
read -n 1 -s -r -p "Press any key to Reboot"
sleep 5
reboot
