#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Install Macbook Air 9,1 speakers DSP config as root"
echo "Copying t2_91_speakers.conf to /etc/pipewire/pipewire.conf.d"
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo cp  config/t2_91_speakers.conf /etc/pipewire/pipewire.conf.d
echo "Copying firs/*.wav to /usr/share/pipewire/devices/apple/air91"
sudo mkdir -p /usr/share/pipewire/devices/apple/air91
sudo cp firs/*.wav /usr/share/pipewire/devices/apple/air91
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."