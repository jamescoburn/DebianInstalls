#!/bin/bash
########## PREREQUISITS ##########
apt intall sudo wget curl ca-certificates apt-transport-https

########## MONGODB ##########
# Install MongoDB Debian Dependancies
curl -sSL https://www.mongodb.org/static/pgp/server-3.6.asc  -o mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --import ./mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --export > ./mongoserver_key.gpg
mv mongoserver_key.gpg /etc/apt/trusted.gpg.d/
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list

# Run system update
apt update

# Install MongoDB on Debian11 Bullseye
apt install mongodb-org=3.6.23 mongodb-org-server=3.6.23 mongodb-org-shell=3.6.23 mongodb-org-mongos=3.6.23 mongodb-org-tools=3.6.23

# Enable and start MongoDB service
systemctl enable --now mongod
systemctl status mongod

########## UNIFI ##########
# Unifi repository gpg key
wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg
echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list

# Run system update
apt update

# Install Unifi Network Application
apt install unifi -y
