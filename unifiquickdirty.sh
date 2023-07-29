# Install MongoDB Debian Dependancies
sudo apt-get install gnupg2 wget -y
echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update -y

# Integrate GPG key for MongoDB
curl -sSL https://www.mongodb.org/static/pgp/server-5.0.asc  -o mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --import ./mongoserver.asc
gpg --no-default-keyring --keyring ./mongo_key_temp.gpg --export > ./mongoserver_key.gpg
sudo mv mongoserver_key.gpg /etc/apt/trusted.gpg.d/

# Run system update
sudo apt update

# Install MongoDB on Debian11 Bullseye
sudo apt install mongodb-org

# Enable and start MongoDB service
sudo systemctl enable --now mongod
sudo systemctl status mongod
