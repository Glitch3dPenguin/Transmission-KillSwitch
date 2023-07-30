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
  echo -e "${RED}This script must be run with sudo or as root.${NC}"
  exit 1
fi

#Let's start by making sure we are up to date
echo -e "${YELLOW}Making sure system is up-to-date.${NC}"
apt update && sudo apt upgrade

#make sure wget and git is installed 
apt install wget git

#Install the Transmission Killswitch script
echo -e "${YELLOW}Fetching install files from github repo${NC}"
git clone https://github.com/Glitch3dPenguin/Transmission-KillSwitch.git
cd Transmission-KillSwitch 
echo -e "${GREEN}Repo fetched!${NC}"
mv transmission-killswitch/ /etc/transmission-killswitch
echo -e "${GREEN}Killswitch files installed!${NC}"

#Set up the auto run script
echo -e "${GREEN}Installing Killswitch Service to /etc/systemd/system/killswitch.service${NC}"
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
echo -e "${GREEN}Killswitch service installed${NC}"

#Allow scripts to be ran
echo -e "${YELLOW}Allowing killswitch files to be ran with chmod${NC}"
chmod +x /etc/systemd/system/killswitch.service
chmod +x /etc/transmission-killswitch/kill-switch.sh

#Enabled the service for systemctl
echo -e "${YELLO}Enabling the killswitch service${NC}"
systemctl enable killswitch
echo =r "${GREEN}Killswitch enabled but not started yet!${NC}"

#Inform user of script configuration
echo -e "${GREEN}Transmission-Killswitch fully installed!${NC}"
echo -e "${YELLOW}Please edit /etc/transmission-killswitch/config before starting${NC}"
echo -e "${GREEN}Once config has been edited, start with${NC}"
echo -e "${GREEN}sudo service killswitch start${NC}"

#Script completed 
echo -e "${GREEN}Done!${NC}" 
exit 0