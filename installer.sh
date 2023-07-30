#!/bin/bash

#Let's stop the script if anything errors out. 
echo Script will stop if error detected. 
set -o errexit

#Let's start by making sure we are up to date
echo Making sure system is up-to-date.
sudo apt update && sudo apt upgrade

#make sure wget is installed 
sudo apt install wget

#Install the Transmission Killswitch script
mkdir /etc/TransmissionKillswitch
cd /etc/TransmissionKillswitch/
wget https://raw.githubusercontent.com/Glitch3dPenguin/Transmission-KillSwitch/main/transmission-killswitch/kill-switch.sh
cd 

#Set up the auto run script
echo Installing Killswitch Service to /etc/systemd/system/killswitch.service
cat <<EOF > /etc/systemd/system/killswitch.service
[Unit]
Description=Manual Transmission Killswitch
After=openvpn.service

[Service]
Type=simple
ExecStartPre=/usr/bin/sleep 30
ExecStart=/root/kill-switch.sh

[Install]
WantedBy=multi-user.target
EOF

#Enabled the service for systemctl
sudo systemctl enable killswitch

#Script completed 
echo Done! 
done
