#!/bin/bash

# Proxmox Ubuntu Template Creation Script
# Creates an Ubuntu cloud-init template on Proxmox VE.

set -e

# Enable logging for debugging
LOG_FILE="/var/log/t-ubu.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Default Variables
TEMPLATE_ID=9000
TEMPLATE_NAME="ubuntu-cloudinit-template"
MEMORY=2048
CORES=2
BRIDGE="vmbr0"
STORAGE="local-lvm"
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_PATH="/var/lib/vz/template/iso/jammy-server-cloudimg-amd64.img"

# Helper Function: Check if a VM ID exists
vm_exists() {
    qm list | awk '{print $1}' | grep -q "^$1$"
}

# Function: Create Template
create_template() {
    # Download the cloud-init image if it doesn't already exist
    if [ ! -f "$IMAGE_PATH" ]; then
        echo "Downloading Ubuntu cloud-init image..."
        wget -O "$IMAGE_PATH" "$IMAGE_URL"
    else
        echo "Ubuntu cloud-init image already exists: $IMAGE_PATH"
    fi

    # Check if the VM ID is already in use
    if vm_exists "$TEMPLATE_ID"; then
        echo "Error: VM ID $TEMPLATE_ID already exists. Please choose a different ID."
        exit 1
    fi

    # Create the VM
    echo "Creating template VM..."
    qm create "$TEMPLATE_ID" \
        --name "$TEMPLATE_NAME" \
        --memory "$MEMORY" \
        --cores "$CORES" \
        --net0 virtio,bridge="$BRIDGE"

    # Import the disk
    echo "Importing disk image..."
    qm importdisk "$TEMPLATE_ID" "$IMAGE_PATH" "$STORAGE"

    # Configure the VM
    echo "Configuring VM..."
    qm set "$TEMPLATE_ID" \
        --scsihw virtio-scsi-pci \
        --scsi0 "$STORAGE:vm-${TEMPLATE_ID}-disk-0" \
        --ide2 "$STORAGE:cloudinit" \
        --boot c --bootdisk scsi0 \
        --serial0 socket --vga serial0 \
        --agent enabled=1

    # Convert the VM to a template
    echo "Converting VM to template..."
    qm template "$TEMPLATE_ID"

    echo "Template VM created successfully!"
}

# Main Script Execution
echo "Starting Proxmox Ubuntu Template Creation..."
create_template
