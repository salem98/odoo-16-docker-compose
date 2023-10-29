#!/bin/bash
DESTINATION=$1
PORT=$2
CHAT=$3

# Clone Odoo directory
git clone --depth=1 https://github.com/salem98/odoo-16-docker-compose $DESTINATION
rm -rf $DESTINATION/.git

# Set permission
mkdir -p $DESTINATION/postgresql
sudo chmod -R 777 $DESTINATION

# Config
if grep -qF "fs.inotify.max_user_watches" /etc/sysctl.conf; then 
    echo $(grep -F "fs.inotify.max_user_watches" /etc/sysctl.conf)
else 
    echo "fs.inotify.max_user_watches = 524288" | sudo tee -a /etc/sysctl.conf
fi
sudo sysctl -p

# Update docker-compose.yml with the specified ports
sed -i 's/8069/'$PORT'/g' $DESTINATION/docker-compose.yml
sed -i 's/20016/'$CHAT'/g' $DESTINATION/docker-compose.yml

# Run Odoo
sudo docker-compose -f $DESTINATION/docker-compose.yml up -d

# Output the result
echo 'Started Odoo @ http://localhost:'$PORT' | Master Password: lemdev.tech | Live chat port: '$CHAT
