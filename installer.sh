#!/bin/bash

# Define color codes 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

#Let's stop the script if anything errors out. 
echo -e "${GREEN}Script will stop if error detected.${NC}"
set -o errexit

#Check if script has been ran with sudo
if [ "$EUID" -ne 0 ]; then
  echo "${RED}This script must be run with sudo or as root.${NC}"
  exit 1
fi

#Let's start by making sure we are up to date
echo "${YELLOW}Making sure system is up-to-date.${NC}"
apt update && sudo apt upgrade

#make sure wget and git is installed 
apt install wget git

#Install the Transmission Killswitch script
git clone https://github.com/Glitch3dPenguin/Transmission-KillSwitch.git
cd Transmission-KillSwitch 
mv transmission-killswitch/ /etc/transmission-killswitch

#Set up the auto run script
echo "${GREEN}Installing Killswitch Service to /etc/systemd/system/killswitch.service${NC}"
cat <<EOF > /etc/systemd/system/killswitch.service
[Unit]
Description=Manual Transmission Killswitch
After=openvpn.service

[Service]
Type=simple
ExecStartPre=/usr/bin/sleep 30
ExecStart=/etc/transmission-killswitch/kill-switch.sh

[Install]
WantedBy=multi-user.target
EOF

#Allow scripts to be ran
chmod +x /etc/systemd/system/killswitch.service
chmod +x /etc/transmission-killswitch.sh

#Enabled the service for systemctl
systemctl enable killswitch

#Inform user of script configuration
echo "${GREEN}Transmission-Killswitch fully installed!${NC}"
echo "${YELLOW}Please edit /etc/transmission-killswitch/config before starting${NC}"
echo "${GREEN}Once config has been edited, start with${NC}"
echo "${GREEN}sudo service killswitch start${NC}"

#Script completed 
echo "${GREEN}Done!${NC}" 
done