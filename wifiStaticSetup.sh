#!/bin/sh
# first line tells it it's a shell script

# Sets the file to be altered
FILE="/etc/wpa_supplicant/wpa_supplicant.conf"


# Nice friendly user message... don't panic / 42
echo "Working on the Wifi setup....."

# bin/cat is the command we use, EOM is the "End of message"
# we use to tell when the command is done (can be anything) 
# $FILE calls the file we defined
# The  <<EOM > send all text untill the "EOM" part to the file
# Known as a "here document" for one > all is replaced in the file
# to append, use >>$FILE
# Followed by the the code we actually want to replace everything in the file with

/bin/cat <<EOM >$FILE



ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=DK

network={
        ssid="ITEK 1st"
        psk="Itek.E20a.Autumn"
}



EOM

# friendly message

echo "done"

read -p "Enter your designated end IP 10.110.0.:"  IP

echo "Working on the static ip-address...."

#start on replacing the next file contend, same procedure as every year james
#all the org content, included commented parts are included, just for safety

FILE="/etc/dhcpcd.conf"


/bin/cat <<EOM >$FILE



# A sample configuration for dhcpcd.
# See dhcpcd.conf(5) for details.

# Allow users of this group to interact with dhcpcd via the control socket.
#controlgroup wheel

# Inform the DHCP server of our hostname for DDNS.
hostname

# Use the hardware address of the interface for the Client ID.
clientid
# or
# Use the same DUID + IAID as set in DHCPv6 for DHCPv4 ClientID as per RFC4361.
# Some non-RFC compliant DHCP servers do not reply with this set.
# In this case, comment out duid and enable clientid above.
#duid

# Persist interface configuration when dhcpcd exits.
persistent

# Rapid commit support.
# Safe to enable by default because it requires the equivalent option set
# on the server to actually work.
option rapid_commit

# A list of options to request from the DHCP server.
option domain_name_servers, domain_name, domain_search, host_name
option classless_static_routes
# Respect the network MTU. This is applied to DHCP routes.
option interface_mtu

# Most distributions have NTP support.
#option ntp_servers

# A ServerID is required by RFC2131.
require dhcp_server_identifier

# Generate SLAAC address using the Hardware Address of the interface
#slaac hwaddr
# OR generate Stable Private IPv6 Addresses based from the DUID
slaac private

# Example static IP configuration:
#interface eth0
#static ip_address=192.168.0.10/24
#static ip6_address=fd51:42f8:caae:d92e::ff/64
#static routers=192.168.0.1
#static domain_name_servers=192.168.0.1 8.8.8.8 fd51:42f8:caae:d92e::1

# It is possible to fall back to a static IP if DHCP fails:
# define static profile
#profile static_eth0
#static ip_address=192.168.1.23/24
#static routers=192.168.1.1
#static domain_name_servers=192.168.1.1

# fallback to static profile on eth0
#interface eth0
#fallback static_eth0

interface wlan0
static ip_address=10.110.0.$IP/24
static routers=10.110.0.1
static domain_name_servers=1.1.1.1

interface eth0
static ip_address=10.110.0.$IP/24
static routers=10.110.0.1
static domain_name_servers=1.1.1.1


EOM


echo "Done!"

