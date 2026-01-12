#!/bin/bash
# Builder for MeshCentral Agent DMG

APP_NAME="MeshAgent_Installer"
DMG_NAME="MeshAgent_Installer.dmg"
AGENT_URL="https://mc.sdelaem.it/meshagents?id=Llm0Cl6GNpFwA7SnYKthExb%24RnHpj%24jg2%40fUQxGA5dPS7bLXFYNudmjEdkRq2ah0&installflags=2&meshinstall=10005"

# Clean up
rm -rf build dist
mkdir -p build dist

# Download the agent
echo "Downloading agent..."
curl -L -o build/meshagent "$AGENT_URL"
chmod +x build/meshagent

# Create the installer wrapper script
# .command extension makes it double-clickable in macOS Finder
# CRITICAL: We must copy the agent to a writable location (e.g., /tmp) before running it,
# because the DMG volume is read-only, and the agent tries to write config/temp files during install.
cat <<EOF > build/Install_MeshAgent.command
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="/tmp/meshagent_install_\$RANDOM"

# Fix "Language environment variable was not set"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "Preparing installer..."
mkdir -p "\$INSTALL_DIR"
cp "\$DIR/meshagent" "\$INSTALL_DIR/"
chmod +x "\$INSTALL_DIR/meshagent"

echo "Installing MeshCentral Agent..."
echo "You may be asked for your password."
# Run the agent install command from the temporary directory
sudo "\$INSTALL_DIR/meshagent" -install

echo "Cleaning up..."
rm -rf "\$INSTALL_DIR"

echo "Done. You can close this window."
read -p "Press Enter to exit..."
EOF

chmod +x build/Install_MeshAgent.command

# Create DMG using hdiutil
echo "Creating DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder build -ov -format UDZO "dist/$DMG_NAME"

echo "DMG created at dist/$DMG_NAME"
