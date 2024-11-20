#!/bin/bash

# This script creates a cloud-init enabled Ubuntu template VM in Proxmox
# It will allow the user to configure the template VM interactively or via arguments.

set -e

# Enable logging
LOG_FILE="/var/log/create-ubuntu-template.log"
exec > >(tee -i $LOG_FILE)
exec 2>&1

# Function to handle errors
error_exit() {
  echo "Error on line $1"
  exit 1
}
trap 'error_exit $LINENO' ERR

# Default variables
VMID=9000
VM_NAME="ubuntu-cloudinit-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
CLOUD_USER="kellen"
CLOUD_PASSWORD="Prox_1408"
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK05OB4KjeAbM4wHENY4eUc10nkop6RCNwODrn5IITh+ descartes"

# Load credentials from .env file
if [ -f .env ]; then
  source .env
fi

# Display current credentials
echo "Using credentials for user: $CLOUD_USER"

# Function to prompt for credentials if not in .env
prompt_credentials() {
  if [ -z "$CLOUD_USER" ]; then
    read -p "Enter cloud-init username [kellen]: " CLOUD_USER
    CLOUD_USER=${CLOUD_USER:-kellen}
  fi

  if [ -z "$CLOUD_PASSWORD" ]; then
    read -s -p "Enter cloud-init password [hidden]: " CLOUD_PASSWORD
    CLOUD_PASSWORD=${CLOUD_PASSWORD:-Prox_1408}
    echo
  fi
}

# Get credentials from user if not set in .env
prompt_credentials

# Create template function
create_template() {
  echo "Creating template..."
  qm create $VMID --name $VM_NAME --memory 2048 --cores 2 --net0 virtio,bridge=$BRIDGE
  qm set $VMID --ciuser $CLOUD_USER --cipassword $CLOUD_PASSWORD
  qm set $VMID --sshkey <(echo "$SSH_PUBLIC_KEY")
  qm set $VMID --storage $STORAGE
  qm set $VMID --boot c --bootdisk scsi0
  qm template $VMID
}

# Run template creation
create_template

echo "Template created successfully with user $CLOUD_USER!"
