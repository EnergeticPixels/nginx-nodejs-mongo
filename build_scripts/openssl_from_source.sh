#!/usr/bin/env bash

set -e

OPENSSL_VER=1.1.1g

# portions of this came from https://askubuntu.com/questions/1126893/how-to-install-openssl-1-1-1-and-libssl-package/1127228#1127228

##########################################################################
# Environment Variables: KEEP UP TO DATE WITH MOST RECENT VERSION NUMBERS
#
#   Directory where all downloaded tar ball files live temporarily:
DOWNLOAD_FOLDER=/usr/local/DOWNLOAD
#   Name of the folder where un-tar'd source files will be stored and used to
#   compile NGINX.  This directory and all contents will be removed after nginx
#   is successfully built and installed. 
SRC_FOLDER=/usr/local/src_files
#
###########################################################################

###########################################################################
# BEGIN SCRIPT EXECUTION
############################################################################

sudo apt-get update

sudo mkdir -p $SRC_FOLDER
sudo mkdir -p $DOWNLOAD_FOLDER
sudo mkdir /opt/openssl
cd $DOWNLOAD_FOLDER

# check files -> download
if [ ! -f openssl-${OPENSSL_VER}.tar.gz ]; then
	echo "OPENSSL tar file does not exist! "
	echo "Begin download"
	wget -c https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz
fi

sudo tar zxvf openssl-${OPENSSL_VER}.tar.gz -C /opt/openssl
export LD_LIBRARY_PATH=/opt/openssl/lib
#echo $LD_LIBRARY_PATH

# **** COMPILE and INSTALL OPENSSL ****
cd /opt/openssl/openssl-${OPENSSL_VER}
sudo ./config --prefix=/opt/openssl --openssldir=/opt/openssl/ssl
sudo make
#sudo make test
sudo make install

# **** REMOVING openssl from /usr/bin ****
cd /usr/bin
ls -l openssl
sudo mv openssl openssl.old

# **** SET PATH variable ****
sudo touch /etc/profile.d/openssl.sh
echo '#!/bin/sh' | sudo tee -a /etc/profile.d/openssl.sh
echo 'PATH=/opt/openssl/bin:${PATH}' | sudo tee -a /etc/profile.d/openssl.sh
echo 'LD_LIBRARY_PATH=/opt/openssl/lib:${LD_LIBRARY_PATH}' | sudo tee -a /etc/profile.d/openssl.sh
# MAKE openssl.sh executable
sudo chmod +x /etc/profile.d/openssl.sh
# execute the script
source /etc/profile.d/openssl.sh

# **** REBOOT MACHINE for path to take effect ****
# ****  MAKE THIS A TODO.  DOES NOT WANT TO REBOOT WHEN UNDER THE CONTROL OF VAGRANT
#sudo systemctl reboot

# **** FOR FOR TESTING ASSISTANCE ****
echo $PATH
#which openssl
#openssl version

# ****  CLEAN UP  ******
cd /usr/local/DOWNLOAD
sudo rm -rf *.tar.gz
cd /usr/local
sudo rm -rf src_files
