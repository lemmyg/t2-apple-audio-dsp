#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Uninstall Macbook Air 9,1 speakers DSP config as root"
sudo rm /etc/pipewire/pipewire.conf.d/t2_91_speakers.conf
sudo rm /usr/share/pipewire/devices/apple/air91/*.wav
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."