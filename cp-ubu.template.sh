#!/bin/bash
set -e

# Configuration
TEMPLATE_ID=9000
VMID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
USE_DHCP=true
STATIC_IP=""
GATEWAY=""
DNS="1.1.1.1 8.8.8.8"

echo "Creating VM from template with the following settings:"
echo "VM ID: $VMID"
echo "VM Name: $VM_NAME"

# Clone template
qm clone $TEMPLATE_ID $VMID --name $VM_NAME --full

# Configure VM
qm set $VMID --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

if [ "$USE_DHCP" = false ]; then
  echo "Setting static IP configuration..."
  qm set $VMID --ipconfig0 ip=$STATIC_IP,gw=$GATEWAY --nameserver "$DNS"
fi

qm start $VMID
echo "VM creation completed successfully."
