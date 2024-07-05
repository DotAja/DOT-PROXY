#!/bin/bash

NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[36;1m'
WB='\e[37;1m'
PORT=1080
DATE=$(date -R | cut -d " " -f -4)
MYIP=$(curl -sS ipv4.icanhazip.com)

# Function to check danted status
check_danted_status() {
    if systemctl is-active --quiet danted; then
        echo -e "${GB}RUNNING${NC}"
    else
        echo -e "${RB}STOPPED${NC}"
    fi
}

# Function to get daily bandwidth usage
get_daily_bandwidth() {
    vnstat -d | grep "`date +%d` " | awk '{print $8, $9}'
}

clear
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "           ${WB}----- [ PROXY SOCKS DOT ] -----${NC}              "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${YB}IP:PORT${NC}          ${WB}: $MYIP:$PORT${NC}"
echo -e " ${YB}DATE${NC}             ${WB}: $DATE${NC}"
echo -e " ${YB}STATUS${NC}           ${WB}: $(check_danted_status)${NC}"
echo -e " ${YB}BANDWIDTH HARI INI${NC} ${WB}: $(get_daily_bandwidth)${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                ${WB}----- [ MENU ] -----${NC}               "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${MB}[1]${NC} ${YB}START SOCKS5${NC}"
echo -e " ${MB}[2]${NC} ${YB}STOP SOCKS5${NC}"
echo -e " ${MB}[3]${NC} ${YB}INSTAL SOCKS5${NC}"
echo -e " ${MB}[4]${NC} ${YB}Lanjutannya${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e ""
read -p " Select Menu :  "  opt
echo -e ""
case $opt in
1) clear
   sudo systemctl start danted
   echo "SOCKS BERJALAN"
   echo ""
   read -n 1 -s -r -p "Press any key to back on menu"
   echo ""
   echo ""
   menu ;;
2) clear
   sudo systemctl stop danted
   echo "SOCKS BERHENTI"
   echo ""
   read -n 1 -s -r -p "Press any key to back on menu"
   echo ""
   echo ""
   menu ;;
3) bash -c "$(wget -qO- raw.githubusercontent.com/DotAja/DOT-PROXY/main/sockauthip.sh)" ;;
4) clear
   echo ""
   echo ""
   read -n 1 -s -r -p "Press any key to back on menu"
   echo ""
   echo ""
   menu ;;
x) exit ;;
*) echo -e "${YB}salah input${NC}" ; sleep 1 ; menu ;;
esac
