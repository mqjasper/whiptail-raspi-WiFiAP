#!/bin/bash

OPTION=$(
whiptail --title "+++ WiFi Access Point Management +++" --menu "Choose an option" 25 78 16 \
"1] Change SSID"  "Change the AP's name" \
"2] Show SSID"  "View the name of your AP" \
"3] Show psk"   "View the password for the AP" \
"4] Show IP" "View the IP to SSH into" \
"5] Exit"	"Exit this menu" 3>&2 2>&1 1>&3)
echo $OPTION


result=$(OPTION)
case $OPTION in
    "1] Change SSID")
    SSID=$(whiptail --inputbox "Enter new SSID: " 10 40 --title "SSID Entry" 3>&2 2>&1 1>&3)
    if [ ! -z "${SSID}" ]
	then
		sudo nmcli connection down "WiFiAP"
		sudo nmcli connection modify "WiFiAP" ssid "${SSID}"
		sudo nmcli connection up "WiFiAP"
	else
		whiptail --title "Warning"  --msgbox "You must enter a new SSID Name" 20 78
	fi;;
    "2] Show SSID")
    whiptail --title "Show SSID" --msgbox "$(sudo grep -w ssid /etc/NetworkManager/system-connections/WiFiAP.nmconnection | sed 's!^ssid=!!')" 20 78;;
    "3] Show psk")
    whiptail --title "Show password" --msgbox "$(sudo grep ^psk /etc/NetworkManager/system-connections/WiFiAP.nmconnection | sed 's!^psk=!!')" 20 78;;
    "4] Show IP")
    whiptail --title "Show SSH IP" --msgbox "$(sudo grep -w address1 /etc/NetworkManager/system-connections/WiFiAP.nmconnection | sed 's!^address1=!pi@!' |sed 's!/24$!!')" 20 78;;
esac
