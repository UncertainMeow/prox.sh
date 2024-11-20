# Proxmox Ubuntu Automation Scripts

## Overview
This repository contains two scripts to simplify the creation of Ubuntu cloud-init templates and virtual machines (VMs) in a Proxmox environment. It is designed to be user-friendly while providing robust customization options.

---

## Scripts

### 1. **Template Creation Script (`t-ubu.sh`)**
- Automates the creation of a reusable Ubuntu cloud-init template on Proxmox.
- **Features**:
  - Supports interactive or default parameter modes.
  - Downloads and configures the latest Ubuntu LTS cloud-init image.
  - Installs essential tools (e.g., `qemu-guest-agent`).

### 2. **VM Creation Script (`cp-ubu.sh`)**
- Automates creating VMs from the Ubuntu cloud-init template.
- **Features**:
  - Supports DHCP and static IP network configuration.
  - Customizable VM resources (memory, disk size, etc.).
  - Automatically resizes and provisions the VM disk.

---

## Setup

### Prerequisites
1. **Proxmox VE**:
   - Installed and configured with sufficient storage and network setup.

2. **Required Tools**:
   - Ensure these tools are installed on your Proxmox host:
     ```bash
     apt install -y wget qemu-guest-agent
     ```

3. **Environment Variables File (`.env`)**:
   - Create a `.env` file in the repository root with the following content:
     ```
     CLOUD_USER=<your-cloud-user>
     CLOUD_PASSWORD=<your-cloud-password>
     ```
   - Replace `<your-cloud-user>` and `<your-cloud-password>` with your actual credentials.
   - Ensure this file is **never tracked by Git** (already excluded via `.gitignore`).

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/YourUsername/prox.sh.git
   cd prox.sh
Add your .env file:

bash
Copy code
echo -e "CLOUD_USER=<your-cloud-user>\nCLOUD_PASSWORD=<your-cloud-password>" > .env
Make the scripts executable:

bash
Copy code
chmod +x t-ubu.sh cp-ubu.sh
Usage
Template Creation
Run with default settings:
bash
Copy code
./t-ubu.sh
Run interactively to customize:
bash
Copy code
./t-ubu.sh -i
Display help:
bash
Copy code
./t-ubu.sh -h
VM Creation
Create a new VM with default settings:
bash
Copy code
./cp-ubu.sh
Run interactively to customize:
bash
Copy code
./cp-ubu.sh -i
Display help:
bash
Copy code
./cp-ubu.sh -h
Security Best Practices
Never Commit Secrets:
Ensure .env is excluded from version control.
Run git status to verify sensitive files are not staged before committing.
Regenerate Exposed Credentials:
If credentials (e.g., passwords or API keys) were previously committed, revoke and regenerate them immediately.
Audit Git History:
Use tools like BFG Repo-Cleaner to remove sensitive data from commit history.
Common Issues
Networking Problems
Verify that your network bridge (e.g., vmbr0) is properly configured on Proxmox.
For static IP configurations, confirm the gateway and DNS settings are correct.
Template Conversion Fails
Check the downloaded Ubuntu cloud-init image for corruption. If needed, delete and rerun the script to redownload the image.
Contributing
Contributions are welcome! To propose changes:

Fork the repository.
Create a new branch:
bash
Copy code
git checkout -b feature/my-feature
Commit and push your changes.
Open a pull request.
License
This project is licensed under the MIT License.
