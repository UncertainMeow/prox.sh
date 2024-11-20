#!/bin/bash
set -e

# Configuration
DEFAULT_TEMPLATE_ID=9000
DEFAULT_VMID=100
DEFAULT_VM_NAME="ubuntu-vm"
DEFAULT_STORAGE="local-lvm"
DEFAULT_BRIDGE="vmbr0"
DEFAULT_MEMORY=2048
DEFAULT_CORES=2
DEFAULT_USE_DHCP=true
DEFAULT_STATIC_IP=""
DEFAULT_GATEWAY=""
DEFAULT_DNS="1.1.1.1 8.8.8.8"

# Interactive mode
if [[ "$1" == "-i" ]]; then
  read -p "Template VM ID [$DEFAULT_TEMPLATE_ID]: " TEMPLATE_ID
  TEMPLATE_ID=${TEMPLATE_ID:-$DEFAULT_TEMPLATE_ID}

  read -p "New VM ID [$DEFAULT_VMID]: " VMID
  VMID=${VMID:-$DEFAULT_VMID}

  read -p "VM Name [$DEFAULT_VM_NAME]: " VM_NAME
  VM_NAME=${VM_NAME:-$DEFAULT_VM_NAME}

  read -p "Storage [$DEFAULT_STORAGE]: " STORAGE
  STORAGE=${STORAGE:-$DEFAULT_STORAGE}

  read -p "Network Bridge [$DEFAULT_BRIDGE]: " BRIDGE
  BRIDGE=${BRIDGE:-$DEFAULT_BRIDGE}

  read -p "Memory (MB) [$DEFAULT_MEMORY]: " MEMORY
  MEMORY=${MEMORY:-$DEFAULT_MEMORY}

  read -p "Cores [$DEFAULT_CORES]: " CORES
  CORES=${CORES:-$DEFAULT_CORES}

  read -p "Use DHCP (true/false) [$DEFAULT_USE_DHCP]: " USE_DHCP
  USE_DHCP=${USE_DHCP:-$DEFAULT_USE_DHCP}

  if [[ "$USE_DHCP" == "false" ]]; then
    read -p "Static IP Address: " STATIC_IP
    read -p "Gateway: " GATEWAY
    read -p "DNS Servers [$DEFAULT_DNS]: " DNS
    DNS=${DNS:-$DEFAULT_DNS}
  fi
else
  TEMPLATE_ID=$DEFAULT_TEMPLATE_ID
  VMID=$DEFAULT_VMID
  VM_NAME=$DEFAULT_VM_NAME
  STORAGE=$DEFAULT_STORAGE
  BRIDGE=$DEFAULT_BRIDGE
  MEMORY=$DEFAULT_MEMORY
  CORES=$DEFAULT_CORES
  USE_DHCP=$DEFAULT_USE_DHCP
  STATIC_IP=$DEFAULT_STATIC_IP
  GATEWAY=$DEFAULT_GATEWAY
  DNS=$DEFAULT_DNS
fi

echo "Creating VM from template with the following settings:"
echo "VM ID: $VMID"
echo "VM Name: $VM_NAME"

# Clone template
qm clone $TEMPLATE_ID $VMID --name $VM_NAME --full

# Configure VM
qm set $VMID --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE

if [[ "$USE_DHCP" == "false" ]]; then
  echo "Setting static IP configuration..."
  qm set $VMID --ipconfig0 ip=$STATIC_IP,gw=$GATEWAY --nameserver "$DNS"
fi

# Generate cloud-init ISO
qm set $VMID --ide2 $STORAGE:cloudinit --boot order=scsi0

# Start VM
qm start $VMID
echo "VM creation completed successfully."
