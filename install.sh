#!/bin/bash

# MeshCentral Agent Installer
# URL provided by user
AGENT_URL="https://mc.sdelaem.it/meshagents?id=Llm0Cl6GNpFwA7SnYKthExb%24RnHpj%24jg2%40fUQxGA5dPS7bLXFYNudmjEdkRq2ah0&installflags=2&meshinstall=10005"

# Fix "Language environment variable was not set" warning
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Ensure we are in a writable directory
if [ ! -w . ]; then
    echo "Current directory is not writable. Switching to /tmp..."
    cd /tmp
fi

echo "Downloading MeshCentral Agent..."
# Use -L to follow redirects if any
curl -L -o meshagent "$AGENT_URL"

echo "Making agent executable..."
chmod +x meshagent

# Check if /usr/local exists (macOS specific check)
if [ "$(uname)" == "Darwin" ]; then
    if [ ! -d "/usr/local" ]; then
        echo "Creating /usr/local..."
        sudo mkdir -p /usr/local
    fi
    # Create the install directory explicitly to avoid permission issues
    if [ ! -d "/usr/local/mesh_services" ]; then
        echo "Creating install directory..."
        sudo mkdir -p /usr/local/mesh_services
    fi
fi

echo "Installing agent (requires sudo)..."
# Try to install
sudo ./meshagent -install

echo "Installation complete."
