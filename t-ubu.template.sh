#!/bin/bash
set -e

# Configuration
VMID=9000
VM_NAME="ubuntu-cloudinit-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

# SSH Public Key (Hardcoded)
SSH_PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkRa/QcyXAbA4pHnYKOK7dMv7gBm0AV/J5S8bbGcirA"

echo "Creating Ubuntu cloud-init template with the following settings:"
echo "VM ID: $VMID"
echo "VM Name: $VM_NAME"

# Download image
echo "Downloading Ubuntu cloud image..."
wget -O ubuntu-template.qcow2 "$IMAGE_URL"

# Import disk
echo "Importing disk to $STORAGE..."
qm create $VMID --name $VM_NAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=$BRIDGE
qm importdisk $VMID ubuntu-template.qcow2 $STORAGE
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-0
qm set $VMID --ide2 $STORAGE:cloudinit --boot order=scsi0
qm set $VMID --sshkeys /dev/stdin <<< "$SSH_PUBLIC_KEY"
qm set $VMID --ciuser "{{CLOUD_USER}}" --cipassword "{{CLOUD_PASSWORD}}"
qm template $VMID

echo "Template creation completed successfully."
