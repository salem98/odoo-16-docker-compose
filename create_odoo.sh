#!/bin/bash

# Check if correct number of arguments is provided
if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 <destination> <port> <chat>"
    exit 1
fi

DESTINATION=$1
PORT=$2
CHAT=$3

# Clone Odoo directory
echo "Cloning Odoo directory..."
if ! git clone --depth=1 https://github.com/minhng92/odoo-16-docker-compose "$DESTINATION"; then
    echo "Failed to clone repository. Exiting..."
    exit 1
fi
rm -rf "$DESTINATION/.git"

# Set permission
echo "Setting permissions..."
mkdir -p "$DESTINATION/postgresql"
sudo chmod -R 777 "$DESTINATION"

# Configure system for Odoo
echo "Configuring system..."
if ! grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then
    echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p

# Update docker-compose.yml with the specified ports
echo "Updating docker-compose.yml..."
sed -i "s/10016/$PORT/g" "$DESTINATION/docker-compose.yml"
sed -i "s/20016/$CHAT/g" "$DESTINATION/docker-compose.yml"

# Run Odoo
echo "Starting Odoo..."
if ! docker-compose -f "$DESTINATION/docker-compose.yml" up -d; then
    echo "Failed to start Odoo. Exiting..."
    exit 1
fi

echo "Started Odoo @ http://localhost:$PORT | Master Password: minhng.info | Live chat port: $CHAT"
