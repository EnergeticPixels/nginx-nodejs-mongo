#!/bin/bash

echo "Provision script for mongodb (basics)"

if [ ! -f /etc/mongod.conf ]; 
then 
echo "**************   MONGODB NOT LOADED *************"
sleep 3
# import public key
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
# create list file for Debian 10 "buster"
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
# reload local package db
sudo apt-get update
# install mongodb
sudo apt-get install -y mongodb-org

# *******************  FOLDERS FOR MONGODB ***************************
# ********************************************************************
# By default and from using the above method,
# data files will be in /var/lib/mongodb
# log files will be in /var/log/mongodb
# unless specified in systemLog.path and storage.dbPath
# of the /etc/mongod.conf file
# ******************  END OF FOLDER SETUP  **************************
# *******************************************************************

 else echo "*****************   MONGODB LOADED  ********************"

fi
sleep 1

# **********  START MONGOD ***************
sudo systemctl start mongod
sleep 2
sudo systemctl status mongod

# ***********  ENSURE MONGODB restarts upon system reboot ***********
sudo systemctl enable mongod