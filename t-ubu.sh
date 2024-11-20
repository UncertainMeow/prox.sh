#!/bin/bash

# t-ubu.sh - Create an Ubuntu cloud-init template in Proxmox VE

set -e

# Ensure necessary dependencies are installed
if ! command -v qm &> /dev/null; then
  echo "Error: Proxmox 'qm' command not found. Please ensure you're running this script on a Proxmox VE host."
  exit 1
fi

# Load credentials from .env file
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create one with CLOUD_USER and CLOUD_PASSWORD."
  exit 1
fi

# Hardcoded SSH public key
SSH_PUBLIC_KEY='ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkRa/QcyXAbA4pHnYKOK7dMv7gBm0AV/J5S8bbGcirA'

# Default variables
VMID=9000
VM_NAME="ubuntu-cloudinit-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

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
    t-ubu.sh - Create an Ubuntu cloud-init template in Proxmox VE

SYNOPSIS
    ./t-ubu.sh [OPTIONS]

DESCRIPTION
    This script automates the creation of an Ubuntu cloud-init template in Proxmox VE.

OPTIONS
    -i
        Run the script in interactive mode to customize configuration.

    -h
        Display a brief help message.

    -?
        Display this man page.

EXAMPLES
    ./t-ubu.sh
        Run the script with default settings.

    ./t-ubu.sh -i
        Run the script in interactive mode.

AUTHOR
    Provided by Your Name.

EOF
}

# Parse command-line options
while getopts "ih?" opt; do
  case "$opt" in
    i)
      # Interactive mode
      read -p "Enter VM ID [${VMID}]: " input
      VMID=${input:-$VMID}

      read -p "Enter VM Name [${VM_NAME}]: " input
      VM_NAME=${input:-$VM_NAME}

      read -p "Enter Bridge Name [${BRIDGE}]: " input
      BRIDGE=${input:-$BRIDGE}

      read -p "Enter Memory (in MB) [${MEMORY}]: " input
      MEMORY=${input:-$MEMORY}

      read -p "Enter Number of CPU Cores [${CORES}]: " input
      CORES=${input:-$CORES}
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

echo "Creating Ubuntu cloud-init template with the following settings:"
echo "VM ID: ${VMID}"
echo "VM Name: ${VM_NAME}"
echo "Storage: ${STORAGE}"
echo "Bridge: ${BRIDGE}"
echo "Memory: ${MEMORY} MB"
echo "Cores: ${CORES}"
echo "Cloud User: ${CLOUD_USER}"

# Download Ubuntu cloud image if not already present
if [ ! -f ubuntu-cloud.img ]; then
  echo "Downloading Ubuntu cloud image..."
  wget -O ubuntu-cloud.img ${IMAGE_URL}
else
  echo "Ubuntu cloud image already exists. Skipping download."
fi

# Create VM
qm create ${VMID} \
  --name "${VM_NAME}" \
  --memory ${MEMORY} \
  --cores ${CORES} \
  --net0 virtio,bridge=${BRIDGE} \
  --serial0 socket \
  --boot c \
  --bootdisk scsi0 \
  --scsihw virtio-scsi-pci

# Import disk
qm importdisk ${VMID} ubuntu-cloud.img ${STORAGE}

# Attach the disk to the VM as scsi drive
qm set ${VMID} \
  --scsihw virtio-scsi-pci \
  --scsi0 ${STORAGE}:vm-${VMID}-disk-0

# Configure cloud-init
qm set ${VMID} \
  --ide2 ${STORAGE}:cloudinit \
  --cipassword ${CLOUD_PASSWORD} \
  --ciuser ${CLOUD_USER} \
  --boot c \
  --bootdisk scsi0

# Pass SSH key
qm set ${VMID} --sshkeys <(echo "${SSH_PUBLIC_KEY}")

# Enable QEMU guest agent
qm set ${VMID} --agent enabled=1

# Convert VM to template
qm template ${VMID}

# Clean up downloaded image
rm -f ubuntu-cloud.img

echo "Template VM ${VM_NAME} (ID: ${VMID}) created successfully!"
