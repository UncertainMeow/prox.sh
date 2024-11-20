Proxmox Ubuntu Automation Scripts
Overview
This repository contains two scripts to simplify the creation of Ubuntu cloud-init templates and virtual machines (VMs) in a Proxmox environment. It ensures that both beginners and advanced users can quickly deploy and manage VMs.

Scripts
1. Template Creation Script (t-ubu.sh)
Creates an Ubuntu cloud-init template on Proxmox.
Features:
Interactive or default parameter modes.
Automatically downloads the Ubuntu cloud-init image.
Configures essential tools (e.g., qemu-guest-agent).
Converts the VM to a reusable Proxmox template.
2. VM Creation Script (cp-ubu.sh)
Creates a new VM from the cloud-init template.
Features:
Supports both DHCP and static IP configuration.
Allows DNS customization.
Automates resizing and provisioning of VM disks.
Setup
Prerequisites
Proxmox VE:

Installed and configured.
Sufficient storage and network setup.
Required Tools:

Ensure the following are installed on your Proxmox node:
bash
Copy code
apt install -y wget qemu-guest-agent
Environment File:

Create a .env file in the repository root with the following format:
plaintext
Copy code
CLOUD_USER=<your-cloud-user>
CLOUD_PASSWORD=<your-cloud-password>
Important: Never share or commit your .env file. It is already excluded from version control via .gitignore.
Installation
Clone the repository:

bash
Copy code
git clone https://github.com/YourUsername/prox.sh.git
cd prox.sh
Add your .env file (replace <your-cloud-user> and <your-cloud-password> with your own values):

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
Ensure .env is excluded from version control (this is already done in .gitignore).
Double-check git status before committing.
Regenerate Exposed Credentials:
If credentials (e.g., passwords, SSH keys) were previously committed, revoke them and generate new ones immediately.
Audit Git History:
Use tools like BFG Repo-Cleaner to remove sensitive data from your Git history.
Common Issues
Networking Problems
Ensure your network bridge (e.g., vmbr0) is properly configured on your Proxmox node.
For static IPs, confirm that the gateway and DNS settings are correct.
Template Conversion Fails
Verify the Ubuntu image download. If corrupted, delete and re-run the script to redownload it.
Contributing
Contributions are welcome! To propose a change:

Fork the repository.
Create a new branch for your changes:
bash
Copy code
git checkout -b feature/my-feature
Commit and push your changes, then open a pull request.
License
This project is licensed under the MIT License.

Acknowledgments
Special thanks to the open-source community for providing tools and inspiration.


