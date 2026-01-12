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

# Ad-hoc sign the binary (Important for Apple Silicon / M1+ Macs to prevent "Damaged" error)
echo "Signing agent binary..."
codesign -s - --force build/meshagent 2>/dev/null || echo "Codesign warning (can be ignored on Linux)"

# Create the installer wrapper script
# .command extension makes it double-clickable in macOS Finder
cat <<EOF > build/Install_MeshAgent.command
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="/tmp/meshagent_install_\$RANDOM"

# Fix "Language environment variable was not set"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Clear terminal
clear
echo "=========================================="
echo "   MeshCentral Agent Installer"
echo "=========================================="
echo ""

# Copy to temp dir to bypass read-only DMG issues
echo "Preparing installer..."
mkdir -p "\$INSTALL_DIR"
cp "\$DIR/meshagent" "\$INSTALL_DIR/"
chmod +x "\$INSTALL_DIR/meshagent"

echo "Installing MeshCentral Agent..."
echo "Note: You may be asked for your password."
echo ""
# Run the agent install command
sudo "\$INSTALL_DIR/meshagent" -install

echo ""
echo "Cleaning up..."
rm -rf "\$INSTALL_DIR"

echo "=========================================="
echo "   Installation Complete!"
echo "=========================================="
echo "You can close this window."
# Keep window open to show status
read -p "Press Enter to exit..."
EOF

chmod +x build/Install_MeshAgent.command

# Ad-hoc sign the command wrapper
codesign -s - --force build/Install_MeshAgent.command 2>/dev/null || true

# Add instructions file for the user
cat <<EOF > build/READ_ME_FIRST.txt
=== IMPORTANT: HOW TO OPEN ===

Because this installer is not from the App Store, macOS may block it.

To open it properly (required only ONCE):

1. Right-click (or Control-click) on "Install_MeshAgent.command".
2. Select "Open" from the menu.
3. Click "Open" in the dialog box.

If you just double-click, macOS might say it "cannot be opened" or is "damaged".
Please use the Right-click -> Open method described above.
EOF

# Create DMG using hdiutil
echo "Creating DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder build -ov -format UDZO "dist/$DMG_NAME"

echo "DMG created at dist/$DMG_NAME"
