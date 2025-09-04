#!/bin/bash

# command to grep the available entry indexes
# grep -i "menuentry '" /boot/grub/grub.cfg|sed -r "s|--class .*$||g"|nl -v 0

WINDOWS_INDEX=2

echo "Setting GRUB to boot Windows (index $WINDOWS_INDEX) once..."
sudo grub-reboot "$WINDOWS_INDEX"

echo "Rebooting now into Windows..."
sudo systemctl reboot
