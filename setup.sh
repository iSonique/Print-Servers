#! /bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "################################################################"
	echo "This script must be run as root to setup AirPrint and CloudPrint"
	echo "################################################################"
	exit 1
fi
echo "#######################################"
echo "##Updating package lists and packages##"
echo "#######################################"

apt-get update >&-
apt-get -y upgrade >&-
echo "#########################"
echo ""
echo "Updated existing packages"
echo "########################"
echo "Installing base packages"
echo ""
apt-get -y install build-essential libcups2-dev python-pip cups python-cups avahi-daemon >&-
echo ""
echo ""
echo "Compling and installing cloudprint base"
echo "#######################################"
pip install cloudprint pycups 
echo "########################################################"
echo "Getting init.d config files from pastebin for cloudprint"
if [[ -f /etc/init.d/gcloudprint ]]; then
	rm /etc/init.d/gcloudprint
fi
wget --quiet -O /etc/init.d/gcloudprint "http://pastebin.com/raw.php?i=xftMPUeD" >&-
chmod +x /etc/init.d/gcloudprint
update-rc.d gcloudprint defaults >&-

usermod -aG lpadmin pi
usermod -aG lpadmin root
service cups start
service avahi-daemon start
service cups stop
echo "Downloading Cups config file"
if [[ -f /etc/cups/cupsd.conf ]]; then
	rm /etc/cups/cupsd.conf
fi
wget --quiet -O /etc/cups/cupsd.conf https://raw.githubusercontent.com/GLOS-UK/Print-Servers/master/cupsd.conf
service cups start

echo "##############################################################################################"
echo "Please now visit https:///locahost:631 on your pi or https://<PI IP ADDRESS>:631             #"
echo "Please have your printer connected and use the menus to add a printer to the system          #"
echo "Once you have added your printer please run ./setup2.sh"					   #"
echo "##############################################################################################"
exit 1
