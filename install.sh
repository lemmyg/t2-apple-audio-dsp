#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Install Mic DSP config as root"
echo "Copying 10-t2_mic.conf to /etc/pipewire/pipewire.conf.d"
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo cp  config/10-t2_mic.conf /etc/pipewire/pipewire.conf.d/10-t2_mic.conf
sudo cp config/10-t2_headset_mic.conf /etc/pipewire/pipewire.conf.d/10-t2_mic.conf

echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."