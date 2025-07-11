#!/bin/bash

# command to grep the available entry indexes
# grep -i "menuentry '" /boot/grub/grub.cfg|sed -r "s|--class .*$||g"|nl -v 0

sudo grub-reboot 2
sudo reboot
