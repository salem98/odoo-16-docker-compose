#!/bin/bash

LOG_FILE="/tmp/bootstrap.log"

exec > >(tee -a $LOG_FILE) 2>&1

set -e  # Exit immediately if a command exits with a non-zero status.

echo "Updating package database..."
sudo yum update -y

echo "Installing essential packages..."
sudo yum install -y docker curl git

echo "Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker

echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Verifying installations..."
docker --version
/usr/local/bin/docker-compose --version

echo "Adding user to Docker group..."
sudo usermod -aG docker $(whoami)

echo "Cloning Odoo directory..."
DESTINATION="odoo-one"
PORT="8069"
CHAT="20016"
git clone --depth=1 https://github.com/salem98/odoo-16-docker-compose $DESTINATION
rm -rf $DESTINATION/.git

echo "Setting permissions..."
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION

echo "Configuring system..."
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then 
    echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf)
else 
    echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p

echo "Updating docker-compose.yml with specified ports..."
sed -i 's/8069/'$PORT'/g' $DESTINATION/docker-compose.yml
sed -i 's/20016/'$CHAT'/g' $DESTINATION/docker-compose.yml

echo "Running Odoo..."
sudo /usr/local/bin/docker-compose -f $DESTINATION/docker-compose.yml up -d

echo "Started Odoo @ http://localhost:$PORT | Master Password: lemdev.tech | Live chat port: $CHAT"

