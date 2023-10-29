#!/bin/bash

# Update package database
sudo yum update -y

# Install Docker
sudo yum install -y docker

# Start Docker service
sudo systemctl start docker

# Enable Docker to start at boot
sudo systemctl enable docker

# Install Curl
sudo yum install -y curl

# Install Git
sudo yum install -y git

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installations
docker --version
docker-compose --version

# Add user to Docker group
sudo usermod -aG docker $(whoami)

# Activate group changes and execute the remaining commands in a sub-shell
newgrp docker <<EONG
# Fetch script
curl -s https://raw.githubusercontent.com/salem98/odoo-16-docker-compose/main/run.sh -o run.sh
chmod +x run.sh

# Run script
./run.sh odoo-one 8069 20016
EONG

