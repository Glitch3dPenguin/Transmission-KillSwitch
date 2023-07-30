# transmission-daemon Kill Switch

This is a fail safe script that will automatically kill transmission-daemon on a Ubuntu container if it detects that there is a problem with the OpenVPN service OR connection.

## OpenVPN Requirement

This scrip will only work with OpenVPN configurations set to use a static IP address. If your OpenVPN configuration frequently changes IP address, then it may not be idea for for. This script also does not have a configuration option for multiple IP addresses.... YET. 

## Discord Integration

This script also has the ability to post messages to a Discord server in order to alert you if the script nees to kill Transmission. 
