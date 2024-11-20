#!/bin/bash

# This script creates a new VM from an existing Ubuntu cloud-init template on Proxmox VE.
# It runs with default settings or prompts for input when using the `-i` flag.

set -e

# Enable logging
LOG_FILE="/var/log/create-ubuntu-vm.log"
exec > >(tee -i $LOG_FILE)
exec 2>&1

# Function to handle errors
error_exit() {
  echo "Error on line $1"
  exit 1
}
trap 'error_exit $LINENO' ERR

# Default variables
TEMPLATE_ID=9000
NEW_VMID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"  # Name of storage in Proxmox VE
SNIPPET_STORAGE="local"  # Storage for cloud-init snippets
BRIDGE="vmbr0"
USE_DHCP=true  # Default to DHCP
STATIC_IP=""
GATEWAY=""
DNS_SERVERS="8.8.8.8,8.8.4.4"

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

# Function to create the VM
create_vm() {
  echo "Creating VM..."
  qm create $NEW_VMID --name $VM_NAME --memory 2048 --cores 2 --net0 virtio,bridge=$BRIDGE
  qm set $NEW_VMID --ciuser $CLOUD_USER --cipassword $CLOUD_PASSWORD
  qm set $NEW_VMID --ipconfig0 ip=dhcp
  if [ "$USE_DHCP" == "false" ]; then
    qm set $NEW_VMID --ipconfig0 ip=$STATIC_IP,gw=$GATEWAY
  fi
  qm set $NEW_VMID --storage $STORAGE
  qm set $NEW_VMID --boot c --bootdisk scsi0
  qm set $NEW_VMID --sshkey <(echo "$SSH_PUBLIC_KEY")
  qm start $NEW_VMID
}

# Run the VM creation
create_vm

echo "VM created successfully with user $CLOUD_USER!"
