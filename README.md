# OpenVPN-KillSwitch
This is a fail safe script that will automatically kill transmission-daemon on a Ubuntu container if it detects that there is a problem with the OpenVPN service OR connection. 

I will need this for documentation later: 

```
[Unit]
Description=Manual Transmission Killswitch
After=openvpn.service

[Service]
Type=simple
ExecStartPre=/usr/bin/sleep 30
ExecStart=/root/kill-switch.sh

[Install]
WantedBy=multi-user.target
```
