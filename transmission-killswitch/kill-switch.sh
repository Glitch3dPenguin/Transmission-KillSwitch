#!/bin/bash

#Import the config file
#Configure the config file in the same folder
source /etc/transmission-killswitch/killswitch.config
echo If you do NOT see a config conformation then it was misconfigured. 
pause 2

# CODE: (Do not edit)
while true; do
    current_ip=$(curl -s https://checkip.amazonaws.com)

    if [[ "$current_ip" = "$predefined_ip" ]]; then
        echo "Public IP Address changed unexpectedly!"
        echo "Shutting down transmission-daemon!"
        service transmission-daemon stop
        # Send Discord Alert
        generate_post_data() {
            cat <<EOF
{
  "content": "Woah! OpenVPN disconnected!",
  "embeds": [{
    "title": "Ragetti",
    "description": "The Transmission Daemon has been killed due to the VPN failing! A server restart will be needed!",
    "color": "45973"
  }]
}
EOF
        }

        # POST request to Discord Webhook
        curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" "$discord_url"
        # end of Discord code
        echo "Discord Alert has been sent!"
        sleep 2
        echo "Shutting down the script."
        sleep 2
        exit 1
    fi

    if ! pgrep openvpn > /dev/null; then
        echo "OpenVPN connection failed"
        echo "Shutting down service transmission-daemon"
        service transmission-daemon stop
        echo "transmission-daemon has been halted!"
        sleep 2
        echo "Now sending Discord alert!"

        # Discord code
        generate_post_data() {
            cat <<EOF
{
  "content": "Woah! OpenVPN stopped running!",
  "embeds": [{
    "title": "Ragetti",
    "description": "The Transmission server's internet has been killed due to the connection to PIA failing! A server restart will be needed!",
    "color": "45973"
  }]
}
EOF
        }

        # POST request to Discord Webhook
        curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" "$discord_url"
        # end of Discord code
        echo "Discord Alert has been sent!"
        sleep 2
    else
        echo "VPN Connection Stable"
    fi

    echo Killswitch passsed IP checks. Sleeping for 5 seconds before next check. 
    sleep 5
done