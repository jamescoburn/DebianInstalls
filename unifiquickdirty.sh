# Install MongoDB Debian Dependancies
#sudo apt-get install gnupg2 wget -y
echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/3.6 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
sudo apt-get update -y

# Integrate GPG key for MongoDB
curl -sSL https://www.mongodb.org/static/pgp/server-3.6.asc  -o mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --import ./mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --export > ./mongoserver_key.gpg
sudo mv mongoserver_key.gpg /etc/apt/trusted.gpg.d/

# Run system update
sudo apt update

# Install MongoDB on Debian11 Bullseye
sudo apt install mongodb-org=3.6.23 mongodb-org-server=3.6.23 mongodb-org-shell=3.6.23 mongodb-org-mongos=3.6.23 mongodb-org-tools=3.6.23

# Enable and start MongoDB service
sudo systemctl enable --now mongod
sudo systemctl status mongod
