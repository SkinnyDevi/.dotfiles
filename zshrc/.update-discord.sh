#!/bin/bash

# Exit on any error
set -e

# Update Discord Canary with yay, automatically confirming all prompts
echo "Updating Discord Canary..."
yay -S discord-canary --noconfirm

# Repair Vencord by running the installer and selecting option 2 (repair)
echo "Repairing Vencord..."
sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"
