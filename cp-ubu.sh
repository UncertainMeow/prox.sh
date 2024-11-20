#!/bin/bash

# cp-ubu.sh - Create a new Ubuntu VM from a Proxmox VE cloud-init template

set -e

# Load credentials from .env file
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create one with CLOUD_USER, CLOUD_PASSWORD, and SSH_PUBLIC_KEY."
  exit 1
fi

# Default variables
TEMPLATE_ID=9000
VMID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"  # Storage is now set to 'local-lvm'
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
USE_DHCP=true
IP_ADDRESS=""
GATEWAY=""
DNS_SERVERS="8.8.8.8 8.8.4.4"

# Function to display help
show_help() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -i            Interactive mode for custom configuration"
  echo "  -h            Display this help message"
  echo "  -?            Display the embedded man page"
}

# Function to display man page
show_man() {
  cat << EOF
NAME
    cp-ubu.sh - Create a new Ubuntu VM from a Proxmox VE cloud-init template

SYNOPSIS
    ./cp-ubu.sh [OPTIONS]

DESCRIPTION
    This script automates the creation of a new Ubuntu VM from an existing cloud-init template in Proxmox VE.

OPTIONS
    -i
        Run the script in interactive mode to customize configuration.

    -h
        Display a brief help message.

    -?
        Display this man page.

EXAMPLES
    ./cp-ubu.sh
        Run the script with default settings.

    ./cp-ubu.sh -i
        Run the script in interactive mode.

AUTHOR
    Provided by [Your Name].

EOF
}

# Parse command-line options
while getopts "ih?" opt; do
  case "$opt" in
    i)
      # Interactive mode
      read -p "Enter New VM ID [${VMID}]: " input
      VMID=${input:-$VMID}

      read -p "Enter VM Name [${VM_NAME}]: " input
      VM_NAME=${input:-$VM_NAME}

      read -p "Enter Bridge Name [${BRIDGE}]: " input
      BRIDGE=${input:-$BRIDGE}

      read -p "Enter Memory (in MB) [${MEMORY}]: " input
      MEMORY=${input:-$MEMORY}

      read -p "Enter Number of CPU Cores [${CORES}]: " input
      CORES=${input:-$CORES}

      read -p "Use DHCP? (yes/no) [yes]: " input
      input=${input:-yes}
      if [[ $input == "no" ]]; then
        USE_DHCP=false
        read -p "Enter Static IP Address (e.g., 192.168.1.100/24): " IP_ADDRESS
        read -p "Enter Gateway IP Address: " GATEWAY
        read -p "Enter DNS Servers (space-separated): " DNS_SERVERS
      else
        USE_DHCP=true
      fi
      ;;
    h)
      show_help
      exit 0
      ;;
    \?)
      show_man
      exit 0
      ;;
  esac
done

echo "Creating Ubuntu VM with the following settings:"
echo "VM ID: ${VMID}"
echo "VM Name: ${VM_NAME}"
echo "Template ID: ${TEMPLATE_ID}"
echo "Storage: ${STORAGE}"
echo "Bridge: ${BRIDGE}"
echo "Memory: ${MEMORY} MB"
echo "Cores: ${CORES}"
echo "Cloud User: ${CLOUD_USER}"

if [ "$USE_DHCP" = true ]; then
  echo "Network Configuration: DHCP"
else
  echo "Network Configuration: Static IP"
  echo "IP Address: ${IP_ADDRESS}"
  echo "Gateway: ${GATEWAY}"
  echo "DNS Servers: ${DNS_SERVERS}"
fi

# Clone VM from template
qm clone ${TEMPLATE_ID} ${VMID} --name "${VM_NAME}"

# Set VM parameters
qm set ${VMID} --memory ${MEMORY} --cores ${CORES} --net0 virtio,bridge=${BRIDGE}

# Configure cloud-init network settings
if [ "$USE_DHCP" = true ]; then
  qm set ${VMID} --ipconfig0 ip=dhcp
else
  qm set ${VMID} --ipconfig0 ip=${IP_ADDRESS},gw=${GATEWAY}
  qm set ${VMID} --nameserver "${DNS_SERVERS}"
fi

# Start the VM
qm start ${VMID}

echo "VM ${VM_NAME} (ID: ${VMID}) created and started successfully!"

