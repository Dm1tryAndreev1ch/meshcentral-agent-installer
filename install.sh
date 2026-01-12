#!/bin/bash

# MeshCentral Agent Installer
# URL provided by user
AGENT_URL="https://mc.sdelaem.it/meshagents?id=Llm0Cl6GNpFwA7SnYKthExb%24RnHpj%24jg2%40fUQxGA5dPS7bLXFYNudmjEdkRq2ah0&installflags=2&meshinstall=10005"

echo "Downloading MeshCentral Agent..."
curl -o meshagent "$AGENT_URL"

echo "Making agent executable..."
chmod +x meshagent

echo "Installing agent (requires sudo)..."
sudo ./meshagent -install

echo "Installation complete."
