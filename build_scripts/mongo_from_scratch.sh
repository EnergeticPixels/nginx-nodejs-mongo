#!/usr/bin/env bash

set -e

# **** The below build utilities come from build_tools.sh in my project ****
# **** uncomment if you are running this without the script to install them ****
#sudo apt-get update
#sudo apt-get install -y build-essential git tree locate

#**************************************************************************
# Environment Variables: KEEP UP TO DATE WITH MOST RECENT VERSION NUMBERS
#
#   Directory where all downloaded tar ball files live temporarily. This 
#   directory and all contents will be removed after nginx is successfully
#   built and installed.
DOWNLOAD_FOLDER=/usr/local/DOWNLOAD
#****************************************************************************


echo "  ********  Build MongoDB from Source  ********"
echo "  ************  THE BASICS  ****************   "

# TEMPORARY requirements until I find source to compile from
sudo apt-get install -y liblzma5

sudo apt-get update
sudo mkdir -p $DOWNLOAD_FOLDER

#  DOWNLOAD THE SOURCE CODE FOR DEBIAN 10
cd $DOWNLOAD_FOLDER
# check files -> download
if [ ! -f mongodb-linux-x86_64-debian10-4.4.0.tgz ]; then
	echo "PCRE tar file does not exist! "
	echo "Begin download"
	wget -c https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian10-4.4.0.tgz
  mkdir -p /usr/bin/mongo
fi
# check files -> un-tar mongodb and save it in runable location
sudo tar -zxvf mongodb-linux-x86_64-debian10-4.4.0.tgz -C /usr/bin/mongo





