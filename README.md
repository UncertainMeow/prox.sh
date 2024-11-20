# Proxmox Ubuntu Automation Scripts

## Overview

This repository provides two scripts to streamline the creation of Ubuntu cloud-init templates and VMs in a Proxmox environment.

### Scripts
1. **`t-ubu.sh`**: Creates an Ubuntu cloud-init template.
2. **`cp-ubu.sh`**: Creates a VM from the Ubuntu cloud-init template.

---

## Setup

### Prerequisites
- Proxmox VE installed and configured.
- An `.env` file in the repository root with the following content:
  ```plaintext
  CLOUD_USER=kellen
  CLOUD_PASSWORD=Prox_1408
Installation
Clone the repository:
bash
Copy code
git clone https://github.com/YourUsername/repo-name.git
cd repo-name
Create the .env file:
bash
Copy code
echo -e "CLOUD_USER=user\nCLOUD_PASSWORD=password" > .env
Usage
Script 1: Template Creation (t-ubu.sh)
Default: Run the script with all defaults:
bash
Copy code
./t-ubu.sh
Interactive: Customize parameters interactively:
bash
Copy code
./t-ubu.sh -i
Help:
bash
Copy code
./t-ubu.sh -h
Man Page:
bash
Copy code
./t-ubu.sh -?
Script 2: VM Creation (cp-ubu.sh)
Default: Run the script with all defaults:
bash
Copy code
./cp-ubu.sh
Interactive: Customize parameters interactively:
bash
Copy code
./cp-ubu.sh -i
Help:
bash
Copy code
./cp-ubu.sh -h
Man Page:
bash
Copy code
./cp-ubu.sh -?
Notes
Ensure your .env file is secure and never committed to version control.
For advanced usage, modify the scripts to suit your specific environment.
License
MIT License

