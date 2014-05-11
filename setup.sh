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

#apt-get update
clear
echo "######################"
echo "Updated packages lists"
echo "######################"

apt-get -y upgrade
clear
echo "#########################"
echo "Updated existing packages"
echo "#########################"

echo "Installing base packages"
echo "This may take sometime"
apt-get -y install build-essential python0dev libcups2-dev python-pip cups python-cups avahi-daemon
echo "Done installing apt packages"

echo "Compling and installing cloudprint base"
pip install cloudprint pycups

echo "Getting init.d config files from pastebin for cloudprint"
wget -O /etc/init.d/gcloudprint "http://pastebin.com/raw.php?i=xftMPUeD"

chmod +x /etc/init.d/gcloudprint
update-rc.d gcloudprint defaults
echo "Installed CloudPrint"

echo "Preparing Installation of AirPrint"
usermod -aG lpadmin pi
usermod -aG lpadmin root

service cups start
service avahi-daemon start

service cups stop
echo "Downloading Cups config file"
rm /etc/cups/cupsd.conf
wget -O /etc/cups/cupsd.conf https://raw.githubusercontent.com/GLOS-UK/Print-Servers/master/cupsd.conf

service cups start
mkdir /opt/airprint
wget -O /opt/airprint airprint-gen.py --no-check-certificate https://raw.github.com.com/tjfontaine/airprint-genertae/master/airprint-generate.py
chmod 755 /opt/airprint/airprint-gen.py

echo "#########################"
echo "Please now visit https:///locahost:631 on your pi or https://<PI IP ADDRESS>:631"
echo "Please have your printer connected and use the menus to add a printer to the system"
echo "Once you have added your printer please run ./setup2.sh"
echo "#########################"
exit 1
