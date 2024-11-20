# Proxmox VM Automation

## Overview
This repository automates the creation of Proxmox cloud-init templates and virtual machines.

### Scripts
- `t-ubu.template.sh`: Creates an Ubuntu cloud-init template.
- `cp-ubu.template.sh`: Creates a new VM from the cloud-init template.

### Prerequisites
- Proxmox VE
- Internet access
- SSH key for the Proxmox user
- `.env` file with the following variables:
  ```env
  CLOUD_USER=kellen
  CLOUD_PASSWORD=your_password
  SSH_PUBLIC_KEY="your_ssh_public_key"
