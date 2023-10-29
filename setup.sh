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

echo "Setup completed!"
