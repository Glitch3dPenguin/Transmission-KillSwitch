# transmission-daemon Kill Switch

This is a fail safe script that will automatically kill transmission-daemon on a Ubuntu container if it detects that there is a problem with the OpenVPN service OR connection.

## OpenVPN Requirement

This scrip will only work with OpenVPN configurations set to use a static IP address. If your OpenVPN configuration frequently changes IP address, then it may not be idea for for. This script also does not have a configuration option for multiple IP addresses.... YET. 

## Discord Integration

This script also has the ability to post messages to a Discord server in order to alert you if the script nees to kill Transmission. 

## How To Use

1) Make sure that you have OpenVPN & Transmission-daemon installed and running. 
2) Make sure that OpenVPN is configured to not switch IP addresses. Any time it changes, you will need to make sure that kill-switch.sh is configured properly.
3) Once all the requirements are in place run the simple one-liner
  
`wget https://raw.githubusercontent.com/Glitch3dPenguin/Transmission-KillSwitch/main/installer.sh && chmod +x installer.sh && sudo ./installer.sh`
