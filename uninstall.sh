#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
# Removes all files installed by install.sh or the deb (see INSTALL_PATHS.md).

set -e
echo "Uninstalling T2 Apple Audio DSP configs"

echo "Removing WirePlumber DSP config from /etc/wireplumber/wireplumber.conf.d"
sudo rm -f /etc/wireplumber/wireplumber.conf.d/*-dsp.conf

echo "Removing old PipeWire config if present"
sudo rm -f /etc/pipewire/pipewire.conf.d/10-t2_161_*.conf
sudo rm -f /etc/pipewire/pipewire.conf.d/*-t2-dsp.conf

echo "Removing Lua script symlinks from /usr/share/wireplumber/scripts/device"
sudo rm -f /usr/share/wireplumber/scripts/device/t2-force-unmute.lua

echo "Removing audio data (FIRs, graphs, Lua) from /usr/share/t2-linux-audio"
sudo rm -rf /usr/share/t2-linux-audio

echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Done."
