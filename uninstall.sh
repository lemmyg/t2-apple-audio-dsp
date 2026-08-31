#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
# Removes all files installed by install.sh or the deb (see INSTALL_PATHS.md).

set -e

echo "Uninstalling T2 Apple Audio DSP configs"

echo "Removing udev ALSA card rename rule"
sudo rm -f /etc/udev/rules.d/99-t2-audio-rename.rules
if command -v udevadm >/dev/null 2>&1; then
    sudo udevadm control --reload-rules
    sudo udevadm trigger --subsystem-match=sound --action=change
fi

echo "Removing WirePlumber DSP config from /etc/wireplumber/wireplumber.conf.d"
sudo rm -f /etc/wireplumber/wireplumber.conf.d/50-t2-audio.conf
sudo rm -f /etc/wireplumber/wireplumber.conf.d/*-dsp.conf

echo "Removing old PipeWire config if present"
sudo rm -f /etc/pipewire/pipewire.conf.d/10-t2_161_*.conf
sudo rm -f /etc/pipewire/pipewire.conf.d/*-t2-dsp.conf

echo "Removing Lua script symlinks from /usr/share/wireplumber/scripts/device"
sudo rm -f /usr/share/wireplumber/scripts/device/t2-force-unmute.lua

echo "Removing audio data (FIRs, graphs, Lua) from /usr/share/t2linux-audio"
sudo rm -rf /usr/share/t2linux-audio /usr/share/t2-linux-audio

echo "Restarting WirePlumber and PipeWire for current user or reboot to take effect...."
echo "run: systemctl --user restart wireplumber pipewire pipewire-pulse"
echo "The ALSA card id (t2-<model>) is restored on reboot or after reloading t2bce_audio."
echo "Done."
