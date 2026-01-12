# MeshCentral Agent Installer

This repository contains scripts to automate the installation of the MeshCentral agent.

## Usage

### Direct Install (Linux/macOS)
Run the `install.sh` script to download and install the agent directly:
```bash
chmod +x install.sh
./install.sh
```

### Build macOS DMG Installer
To create a distributable `.dmg` file for macOS clients:
1. Run the builder script on a Mac:
   ```bash
   chmod +x build_dmg.sh
   ./build_dmg.sh
   ```
2. The DMG file will be created in the `dist/` directory.
3. Users can open the DMG and double-click `Install_MeshAgent.command` to install.

## Files
- `install.sh`: Downloads and installs the agent using the provided parameters.
- `build_dmg.sh`: Automates the creation of a DMG containing the agent and a launcher script.
