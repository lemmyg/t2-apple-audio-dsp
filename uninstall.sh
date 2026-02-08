#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
echo "Uninstalling T2 Apple Audio DSP configs"
echo "Removing config files from /etc/pipewire/pipewire.conf.d"
sudo rm -f /etc/pipewire/pipewire.conf.d/10-t2_161_*.conf
echo "Removing FIR files from /usr/share/pipewire/devices"
sudo rm -rf /usr/share/pipewire/devices/*
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."