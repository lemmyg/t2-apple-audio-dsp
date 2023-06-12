#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Install Macbook Pro 16.1 speakers DSP config as root"
echo "Copying 10-t2_161_speakers.conf to /etc/pipewire/pipewire.conf.d"
sudo mkdir -p /etc/pipewire/pipewire.conf.d
sudo cp  config/10-t2_161_speakers.conf /etc/pipewire/pipewire.conf.d
echo "Copying firs/*.wav to /usr/share/pipewire/devices/apple"
sudo mkdir -p /usr/share/pipewire/devices/apple
sudo cp firs/*.wav /usr/share/pipewire/devices/apple
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."