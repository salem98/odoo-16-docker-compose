#!/bin/bash 

# Get instance IPs from Terraform output
IPs=$(terraform output -json instance_public_ips | jq -r '. | to_entries[] | .value')

# Write to inventory.ini
echo "[odoo]" > inventory.ini
for ip in $IPs; do
  echo "$ip ansible_ssh_user=ec2-user ansible_ssh_private_key_file=/home/ubuntu22/.ssh/id_rsa" >> inventory.ini #PLEASE UPDATE /home/ubuntu22/.ssh/id_rsa with your private key path
done