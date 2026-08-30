#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
#
# Standalone uninstall: removes Apple T2 ALSA UCM profiles from /usr/share/alsa/ucm2.

if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
# shellcheck source=restart-user-audio.sh
. "$SCRIPT_DIR/restart-user-audio.sh"

UCM_DST="/usr/share/alsa/ucm2"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: run as root (e.g. sudo $0)"
    exit 1
fi

echo "Removing Apple T2 ALSA UCM profiles from $UCM_DST"

for profile in HiFi-x2 HiFi-x4 HiFi-x6; do
    rm -f "$UCM_DST/AppleT2/$profile.conf"
done

for driver in AppleT2x2 AppleT2x4 AppleT2x6; do
    rm -f "$UCM_DST/conf.d/$driver/$driver.conf"
    rmdir "$UCM_DST/conf.d/$driver" 2>/dev/null || true
done

rmdir "$UCM_DST/AppleT2" 2>/dev/null || true

echo "Restarting WirePlumber and PipeWire for current user or reboot to take effect...."
echo "run: systemctl --user restart wireplumber pipewire pipewire-pulse"
echo "Apple T2 ALSA UCM profile removed"
