#!/bin/bash

set -e

# Variables
TEMPLATE_ID=9000
NEW_VMID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
USE_DHCP=true
STATIC_IP=""
GATEWAY=""
DNS_SERVERS="1.1.1.1 8.8.8.8"

# Dependencies
apt-get update -y && apt-get install -y cloud-init

echo "Creating Ubuntu VM with the following settings:"
echo "VM ID: $NEW_VMID"
echo "VM Name: $VM_NAME"
echo "Template ID: $TEMPLATE_ID"

# Step 1: Clone from template
qm clone $TEMPLATE_ID $NEW_VMID --name $VM_NAME --full

# Step 2: Set VM configurations
qm set $NEW_VMID --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

# Step 3: Configure cloud-init networking
if [ "$USE_DHCP" = true ]; then
  qm set $NEW_VMID --ipconfig0 ip=dhcp --nameserver $DNS_SERVERS
else
  qm set $NEW_VMID --ipconfig0 ip=$STATIC_IP,gw=$GATEWAY --nameserver $DNS_SERVERS
fi

# Step 4: Start the VM
qm start $NEW_VMID

echo "Ubuntu VM created successfully!"
