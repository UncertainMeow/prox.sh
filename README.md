# Proxmox Ubuntu Automation Scripts

## Overview
This repository contains two scripts to simplify the creation of Ubuntu cloud-init templates and virtual machines (VMs) in a Proxmox environment. These scripts are designed to be user-friendly while providing robust customization options.

## Scripts

### Template Creation Script (`t-ubu.sh`)
- Automates the creation of a reusable Ubuntu cloud-init template on Proxmox.
- Features:
  - Supports both interactive and default parameter modes.
  - Downloads and configures the latest Ubuntu LTS cloud-init image.
  - Installs essential tools (e.g., `qemu-guest-agent`).

### VM Creation Script (`cp-ubu.sh`)
- Creates VMs from the Ubuntu cloud-init template.
- Features:
  - Supports DHCP and static IP configurations.
  - Customizes VM resources (CPU, memory, disk size, etc.).
  - Automatically resizes VM disks during creation.

## Setup

### Prerequisites
1. **Proxmox VE**:
   - Installed and configured with sufficient storage and network setup.

2. **Required Tools**:
   - Ensure these tools are installed on your Proxmox host:
     ```
     apt install -y wget qemu-guest-agent
     ```

3. **Environment File (`.env`)**:
   - Create a `.env` file in the repository root with the following content:
     ```
     CLOUD_USER=<your-cloud-user>
     CLOUD_PASSWORD=<your-cloud-password>
     ```
   - Replace `<your-cloud-user>` and `<your-cloud-password>` with your actual credentials.
   - Ensure this file is **not tracked by Git** (already excluded via `.gitignore`).

### Installation

1. Clone the repository:

```
git clone https://github.com/YourUsername/prox.sh.git cd prox.sh
```

2. Add your `.env` file:
```
echo -e "CLOUD_USER=<your-cloud-user>\nCLOUD_PASSWORD=<your-cloud-password>" > .env
```

3. Make the scripts executable:

```
chmod +x t-ubu.sh cp-ubu.sh
```

## Usage

### Template Creation
1. Run with default settings:

```
./t-ubu.sh
```

2. Run interactively to customize parameters:
```
./t-ubu.sh -i
```

3. Display help:
```
./t-ubu.sh -h
```

### VM Creation
1. Create a new VM with default settings:

./cp-ubu.sh

css
Copy code

2. Run interactively to customize parameters:
./cp-ubu.sh -i

scss
Copy code

3. Display help:
./cp-ubu.sh -h

Copy code
Chunk 7: Security Best Practices
markdown
Copy code
## Security Best Practices

- **Never Commit Secrets**:
  - Ensure `.env` is excluded from version control.
  - Run `git status` to verify sensitive files are not staged before committing.

- **Regenerate Exposed Credentials**:
  - If credentials (e.g., passwords or API keys) were previously committed, revoke and regenerate them immediately.

- **Audit Git History**:
  - Use tools like [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) to remove sensitive data from commit history.
Chunk 8: Common Issues
markdown
Copy code
## Common Issues

### Networking Problems
- Verify that your network bridge (e.g., `vmbr0`) is properly configured on Proxmox.
- For static IP configurations, confirm the gateway and DNS settings are correct.

### Template Conversion Fails
- Check the downloaded Ubuntu cloud-init image for corruption. If needed, delete and rerun the script to redownload the image.
Chunk 9: Contributing
markdown
Copy code
## Contributing

Contributions are welcome! To propose changes:
1. Fork the repository.
2. Create a new branch:
git checkout -b feature/my-feature

markdown
Copy code

3. Commit and push your changes.
4. Open a pull request.
Chunk 10: License
csharp
Copy code
## License

This project is licensed under the [MIT License](LICENSE).
Chunk 11: Acknowledgments
kotlin
Copy code
## Acknowledgments

Thanks to the open-source community for providing inspiration and tools that made this project possible.

