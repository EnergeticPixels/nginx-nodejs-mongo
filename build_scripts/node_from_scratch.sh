#!/usr/bin/env bash

VERSION=node_12.x
DISTRO="$(lsb_release -s -c)"

echo "-*-*-*   INSTALL prerequisites   -*-*-*"
sudo apt-get update
sudo apt-get install -y git python g++ make python3-distutils build-essential libssl-dev manpages-dev software-properties-common

echo "-*-*-*   REMOVE old PPA if it exists   -*-*-*"
sudo add-apt-repository -y -r ppa:chris-lea/node.js
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save

echo "-*-*-*   ADD NodeSource package Signing Key   -*-*-*"
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -

echo "-*-*-*   ADD Desired NodeSource repo   -*-*-*"
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list

echo "-*-*-*   UPDATE package lists and install NodeJS   -*-*-*"
sudo apt-get update
sudo apt-get install -y nodejs

echo "-*-*-*   PAUSE to finish Installing NodeJS/NPM   -*-*-*"
sleep 5

echo "-*-*-*   COPY 2 Sample APIs for initial setup testing   -*-*-*"
#mkdir -p /opt/api1
#mkdir -p /opt/api2
#cp ../../vagrant/build_scripts/server1.js /opt/api1
#cp ../../vagrant/build_scripts/server2.js /opt/api2

echo "-*-*-*   INSTALL Global NodeJS/NPM Installs   -*-*-*"
sudo npm install --global --no-optional pm2

pm2 start /opt/api1/server1.js --watch
pm2 start /opt/api2/server2.js