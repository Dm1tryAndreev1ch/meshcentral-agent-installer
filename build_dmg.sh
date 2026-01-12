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
curl -o build/meshagent "$AGENT_URL"
chmod +x build/meshagent

# Create the installer wrapper script
# .command extension makes it double-clickable in macOS Finder
cat <<EOF > build/Install_MeshAgent.command
#!/bin/bash
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
echo "Installing MeshCentral Agent..."
# Run the agent install command
sudo "\$DIR/meshagent" -install
echo "Done. You can close this window."
read -p "Press Enter to exit..."
EOF

chmod +x build/Install_MeshAgent.command

# Create DMG using hdiutil
echo "Creating DMG..."
hdiutil create -volname "$APP_NAME" -srcfolder build -ov -format UDZO "dist/$DMG_NAME"

echo "DMG created at dist/$DMG_NAME"
