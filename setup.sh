#! /bin/bash

echo "This script must be run as root to setup AirPrint and CloudPrint"

apt-get update
echo "Updated packages lists"

apt-get -y upgrade
echo "Updated existing packages"

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


