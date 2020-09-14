#!/usr/bin/env bash


# SETS-UP replica set ability.  Will need appropriate
# rs.initiate() function call and appropriate config
# file entry to make it work. Same keyfile shared between
# various replica set entities.
echo "     KEYFILE MOVING!!      "
mkdir -p /var/mongodb/pki/
cp ../../vagrant/build_scripts/keyfile /var/mongodb/pki/
sudo chown -R mongodb.mongodb /var/mongodb/pki/
sudo chmod -R 600 /var/mongodb/pki/keyfile