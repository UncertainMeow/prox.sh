#!/bin/bash

# Template Creation Script for Proxmox

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
TEMPLATE_NAME="ubuntu-cloud-template"
STORAGE="local-lvm"
BRIDGE="vmbr0"
MEMORY=2048
CORES=2
DISK_SIZE="10G"

# Parse arguments
while getopts "ih?" opt; do
  case $opt in
    i)
      read -p "Enter Template VM ID [${TEMPLATE_ID}]: " TEMPLATE_ID
      read -p "Enter Template Name [${TEMPLATE_NAME}]: " TEMPLATE_NAME
      read -p "Enter Storage [${STORAGE}]: " STORAGE
      read -p "Enter Network Bridge [${BRIDGE}]: " BRIDGE
      read -p "Enter Memory Size (MB) [${MEMORY}]: " MEMORY
      read -p "Enter Number of CPU Cores [${CORES}]: " CORES
      read -p "Enter Disk Size (e.g., 10G) [${DISK_SIZE}]: " DISK_SIZE
      ;;
    h)
      echo "Usage: $0 [-i (interactive)] [-h (help)] [-? (man page)]"
      exit 0
      ;;
    ?)
      cat <<EOF
NAME
    t-ubu.sh - Create an Ubuntu cloud-init template in Proxmox.

SYNOPSIS
    t-ubu.sh [OPTIONS]

OPTIONS
    -i      Interactive mode for setting custom values.
    -h      Display help message.
    -?      Display detailed man page.

DESCRIPTION
    This script creates a cloud-init enabled Ubuntu VM template.
EOF
      exit 0
      ;;
  esac
done

# Template creation logic here (omitted for brevity, but same as the previously shared script)

echo "Template VM created successfully!"
