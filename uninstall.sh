#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Uninstall Macbook Pro 16.1 speakers DSP config as root"
sudo rm /etc/pipewire/pipewire.conf.d/10-t2_161_speakers.conf
sudo rm /usr/share/pipewire/devices/apple/macbook_pro_t2_16_1_*.wav
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."