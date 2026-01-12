#!/bin/bash
# Builder for MeshCentral Agent DMG (v3 - .app Bundle Version)

APP_NAME="MeshAgent Installer"
DMG_NAME="MeshAgent_Installer.dmg"
AGENT_URL="https://mc.sdelaem.it/meshagents?id=Llm0Cl6GNpFwA7SnYKthExb%24RnHpj%24jg2%40fUQxGA5dPS7bLXFYNudmjEdkRq2ah0&installflags=2&meshinstall=10005"

# Clean up
rm -rf build dist
mkdir -p build dist

# Define App Bundle paths
APP_BUNDLE="build/$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"

echo "Creating App Bundle structure..."
mkdir -p "$MACOS"

# Download the agent
echo "Downloading agent..."
curl -L -o "$MACOS/meshagent" "$AGENT_URL"
chmod +x "$MACOS/meshagent"

# Create the main executable script for the App
SCRIPT_PATH="$MACOS/MeshAgent Installer"
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash
# Launcher for MeshCentral Agent
# This script runs when the User launches the .app

# Get the directory where the script is running
DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
INSTALL_DIR="/tmp/meshagent_install_\$RANDOM"

# GUI Prompt function using AppleScript
function show_dialog() {
    osascript -e "display dialog \"\$1\" buttons {\"OK\"} default button \"OK\" with icon note with title \"MeshAgent Installer\""
}

# Fix locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Use AppleScript to ask for Admin Password nicely
# This runs the installation command with administrator privileges
echo "Prompting for password..."
osascript -e "do shell script \"'$DIR/meshagent' -install\" with administrator privileges"

if [ \$? -eq 0 ]; then
    show_dialog "Installation successful! The agent is now running."
else
    show_dialog "Installation failed or was cancelled."
fi
EOF

chmod +x "$SCRIPT_PATH"

# Create Info.plist (Required for a valid .app)
cat <<EOF > "$CONTENTS/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>MeshAgent Installer</string>
    <key>CFBundleIdentifier</key>
    <string>com.meshcentral.agent.installer</string>
    <key>CFBundleName</key>
    <string>MeshAgent Installer</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
</dict>
</plist>
EOF

# Ad-hoc sign the App Bundle (Required for Apple Silicon)
echo "Signing App Bundle..."
codesign --force --deep --sign - "$APP_BUNDLE" 2>/dev/null || echo "Codesign warning (ignore on Linux)"

# Create a symlink to Applications folder to encourage drag-and-drop
ln -s /Applications "build/Applications"

# Add instructions
cat <<EOF > build/INSTRUCTIONS.txt
1. Drag "MeshAgent Installer" to the "Applications" folder.
2. Open your Applications folder.
3. Right-Click (or Control-Click) the app and select "Open".
4. Click "Open" in the dialog.
EOF

# Create DMG
echo "Creating DMG..."
hdiutil create -volname "MeshAgent Installer" -srcfolder build -ov -format UDZO "dist/$DMG_NAME"

echo "Done. DMG created at dist/$DMG_NAME"
