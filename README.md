# Proxmox Ubuntu Cloud-Init Automation Scripts

## Overview

This repository contains scripts to automate the creation of Ubuntu cloud-init templates and virtual machines in Proxmox VE.

### Scripts

- **t-ubu.sh**: Creates an Ubuntu cloud-init template.
- **cp-ubu.sh**: Creates a new VM from the Ubuntu cloud-init template.

## Prerequisites

- Proxmox VE installed and configured.
- SSH access to your Proxmox VE server.
- Ensure `wget` is installed for downloading the cloud image.

## Setup

1. **Clone the repository** to your Proxmox VE server.

   ```bash
   git clone https://github.com/yourusername/yourrepository.git
   cd yourrepository
Create the .env file in the repository directory.

bash
Copy code
cat <<EOF > .env
CLOUD_USER=kellen
CLOUD_PASSWORD=YourSecurePassword
SSH_PUBLIC_KEY='ssh-ed25519 AAAAC... your SSH public key ...'
EOF
Replace YourSecurePassword and SSH_PUBLIC_KEY with your actual password and SSH public key.

Ensure .env is in .gitignore to prevent it from being committed.

Make the scripts executable.

bash
Copy code
chmod +x t-ubu.sh cp-ubu.sh
Usage
Creating the Ubuntu Cloud-Init Template
Run the script with default settings:

bash
Copy code
./t-ubu.sh
To run the script in interactive mode:

bash
Copy code
./t-ubu.sh -i
To display help:

bash
Copy code
./t-ubu.sh -h
To display the embedded man page:

bash
Copy code
./t-ubu.sh -?
Creating a New VM from the Template
Run the script with default settings:

bash
Copy code
./cp-ubu.sh
To run the script in interactive mode:

bash
Copy code
./cp-ubu.sh -i
To display help:

bash
Copy code
./cp-ubu.sh -h
To display the embedded man page:

bash
Copy code
./cp-ubu.sh -?
