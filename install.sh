#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2023 Linux T2 Kernel Team
echo "Install DSP config as root ..."
#cmd = 'python3 main.py "$@"'
sudo bash -c 'python3 main.py "$@"' -- "$@"
echo "Restarting Pipewire for current user ...."
systemctl --user restart wireplumber pipewire pipewire-pulse
echo "Note that the first time you may need to restart your computer."