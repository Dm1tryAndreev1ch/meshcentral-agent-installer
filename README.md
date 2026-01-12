# MeshCentral Agent Installer

This repository contains scripts to automate the installation of the MeshCentral agent.

## Usage

### Direct Install (Linux/macOS)
Run the `install.sh` script to download and install the agent directly:
```bash
curl -sL https://raw.githubusercontent.com/Dm1tryAndreev1ch/meshcentral-agent-installer/main/install.sh | bash
```

### Build macOS DMG Installer
To create a distributable `.dmg` file for macOS clients:
1. Run the builder script on a Mac:
   ```bash
   chmod +x build_dmg.sh
   ./build_dmg.sh
   ```
2. The DMG file will be created in the `dist/` directory.

### macOS Installation Instructions (IMPORTANT)
When running the installer on a new Mac, **Gatekeeper will block it** because it's not from the App Store.

**To run it successfully (Required only ONCE):**
1. Open the DMG file.
2. **Right-click** (or Control-click) on `Install_MeshAgent.command`.
3. Select **Open** from the context menu.
4. Click **Open** in the confirmation dialog.

![Right Click Open](https://support.apple.com/library/content/dam/edam/applecare/images/en_US/macOS/macos-sierra-gatekeeper-override-run-anyway.png)

*After doing this once, the system remembers the permission and allows the script to run.*

## Files
- `install.sh`: Downloads and installs the agent using the provided parameters.
- `build_dmg.sh`: Automates the creation of a DMG containing the agent and a launcher script.
