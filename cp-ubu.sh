#!/bin/bash

# Proxmox Ubuntu VM Creation Script
# Creates a VM from a cloud-init template.

set -e

# Enable logging
LOG_FILE="/var/log/cp-ubu.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Default Variables
TEMPLATE_ID=9000
NEW_VMID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"
BRIDGE="vmbr0"
USE_DHCP=true
STATIC_IP=""
GATEWAY=""
DNS_SERVERS=""

# Helper Function: Check if a VM ID exists
vm_exists() {
    qm list | awk '{print $1}' | grep -q "^$1$"
}

# Function: Create VM
create_vm() {
    # Check if the template VM exists
    if ! vm_exists "$TEMPLATE_ID"; then
        echo "Error: Template VM ID $TEMPLATE_ID does not exist."
        exit 1
    fi

    # Check if the new VM ID is already in use
    if vm_exists "$NEW_VMID"; then
        echo "Error: VM ID $NEW_VMID already exists. Please choose a different ID."
        exit 1
    fi

    # Clone the template
    echo "Cloning template VM..."
    qm clone "$TEMPLATE_ID" "$NEW_VMID" --name "$VM_NAME" --full

    # Configure the VM
    echo "Configuring VM..."
    qm set "$NEW_VMID" --net0 virtio,bridge="$BRIDGE"

    # Handle Networking
    if [ "$USE_DHCP" = true ]; then
        echo "Using DHCP for networking."
        qm set "$NEW_VMID" --ipconfig0 ip=dhcp
    else
        # Ensure Static IP, Gateway, and DNS Servers are provided
        if [ -z "$STATIC_IP" ] || [ -z "$GATEWAY" ]; then
            echo "Error: Static IP and Gateway are required for static configuration."
            exit 1
        fi

        # Use gateway as default DNS if none is provided
        if [ -z "$DNS_SERVERS" ]; then
            DNS_SERVERS="$GATEWAY"
            echo "No DNS servers provided. Defaulting to gateway ($GATEWAY)."
        fi

        echo "Setting static IP configuration: IP=$STATIC_IP, Gateway=$GATEWAY, DNS=$DNS_SERVERS"
        qm set "$NEW_VMID" --ipconfig0 ip="$STATIC_IP",gw="$GATEWAY"
        qm set "$NEW_VMID" --nameserver "$DNS_SERVERS"
    fi

    # Resize the disk to the configured size
    qm resize "$NEW_VMID" scsi0 10G

    echo "VM created successfully!"
}

# Interactive Mode
interactive_mode() {
    echo "Enter Template ID [$TEMPLATE_ID]:"
    read -r input && TEMPLATE_ID=${input:-$TEMPLATE_ID}

    echo "Enter New VM ID [$NEW_VMID]:"
    read -r input && NEW_VMID=${input:-$NEW_VMID}

    echo "Enter VM Name [$VM_NAME]:"
    read -r input && VM_NAME=${input:-$VM_NAME}

    echo "Enter Storage [$STORAGE]:"
    read -r input && STORAGE=${input:-$STORAGE}

    echo "Enter Network Bridge [$BRIDGE]:"
    read -r input && BRIDGE=${input:-$BRIDGE}

    echo "Use DHCP (true/false) [$USE_DHCP]:"
    read -r input && USE_DHCP=${input:-$USE_DHCP}

    if [ "$USE_DHCP" = false ]; then
        echo "Enter Static IP Address:"
        read -r STATIC_IP

        echo "Enter Gateway:"
        read -r GATEWAY

        echo "Enter DNS Servers (comma-separated):"
        read -r input && DNS_SERVERS=${input:-$DNS_SERVERS}
    fi

    create_vm
}

# Main Script Execution
if [[ "$1" == "-i" ]]; then
    interactive_mode
else
    create_vm
fi
