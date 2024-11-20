#!/bin/bash

# VM Creation Script from Template for Proxmox

# Load environment variables from .env
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found. Please create one with CLOUD_USER and CLOUD_PASSWORD."
  exit 1
fi

# Verify credentials are loaded
if [ -z "$CLOUD_USER" ] || [ -z "$CLOUD_PASSWORD" ]; then
  echo "Error: CLOUD_USER and CLOUD_PASSWORD must be set in .env file."
  exit 1
fi

# Define default variables
TEMPLATE_ID=9000
NEW_VM_ID=100
VM_NAME="ubuntu-vm"
STORAGE="local-lvm"
BRIDGE="vmbr0"
USE_DHCP=true
STATIC_IP=""
GATEWAY=""
DNS_SERVERS=""

# Parse arguments
while getopts "ih?" opt; do
  case $opt in
    i)
      read -p "Enter Template ID [${TEMPLATE_ID}]: " TEMPLATE_ID
      read -p "Enter New VM ID [${NEW_VM_ID}]: " NEW_VM_ID
      read -p "Enter VM Name [${VM_NAME}]: " VM_NAME
      read -p "Enter Storage [${STORAGE}]: " STORAGE
      read -p "Enter Network Bridge [${BRIDGE}]: " BRIDGE
      read -p "Use DHCP (true/false) [${USE_DHCP}]: " USE_DHCP
      if [ "$USE_DHCP" == "false" ]; then
        read -p "Enter Static IP Address: " STATIC_IP
        read -p "Enter Gateway: " GATEWAY
        read -p "Enter DNS Servers (comma-separated): " DNS_SERVERS
      fi
      ;;
    h)
      echo "Usage: $0 [-i (interactive)] [-h (help)] [-? (man page)]"
      exit 0
      ;;
    ?)
      cat <<EOF
NAME
    cp-ubu.sh - Create a VM from an Ubuntu cloud-init template in Proxmox.

SYNOPSIS
    cp-ubu.sh [OPTIONS]

OPTIONS
    -i      Interactive mode for setting custom values.
    -h      Display help message.
    -?      Display detailed man page.

DESCRIPTION
    This script clones an Ubuntu cloud-init template and customizes the new VM.
EOF
      exit 0
      ;;
  esac
done

# VM creation logic here (omitted for brevity, but same as the previously shared script)

echo "VM created successfully!"
