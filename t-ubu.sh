#!/bin/bash

set -e

# Environment variables
source .env

VMID=9000
VM_NAME="ubuntu-cloudinit-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
DISK_SIZE="10G"

echo "Creating Ubuntu cloud-init template with the following settings:"
echo "VM ID: $VMID"
echo "VM Name: $VM_NAME"

# Install dependencies
apt-get update
apt-get install -y curl qemu-guest-agent cloud-init

# Download and import the disk image
curl -o /tmp/ubuntu-template.qcow2 $IMAGE_URL
qm create $VMID --name $VM_NAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE --scsihw virtio-scsi-pci
qm importdisk $VMID /tmp/ubuntu-template.qcow2 $STORAGE
qm set $VMID --scsi0 $STORAGE:vm-${VMID}-disk-0 --boot c --bootdisk scsi0
qm set $VMID --ide2 $STORAGE:cloudinit --serial0 socket --vga serial0

# Add cloud-init user data
qm set $VMID --ciuser $CLOUD_USER --cipassword $CLOUD_PASSWORD --sshkeys "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkRa/QcyXAbA4pHnYKOK7dMv7gBm0AV/J5S8bbGcirA"

# Finalize as template
qm template $VMID

# Clean up temporary files
rm -f /tmp/ubuntu-template.qcow2
echo "Template created successfully!"
