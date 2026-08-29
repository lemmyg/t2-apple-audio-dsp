#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2026 Linux T2 Kernel Team
#
# Standalone install: run from the source directory or pass a UCM source path.
# Installs Apple T2 ALSA UCM profiles to /usr/share/alsa/ucm2.

if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
UCM_SRC="${1:-$SCRIPT_DIR/ucm2}"
UCM_DST="/usr/share/alsa/ucm2"

# shellcheck source=restart-user-audio.sh
. "$SCRIPT_DIR/restart-user-audio.sh"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: run as root (e.g. sudo $0)"
    exit 1
fi

if [ ! -d "$UCM_SRC/AppleT2" ] || [ ! -d "$UCM_SRC/conf.d" ]; then
    echo "Error: UCM source tree not found at $UCM_SRC"
    exit 1
fi

for profile in HiFi-x2 HiFi-x4 HiFi-x6; do
    if [ ! -r "$UCM_SRC/AppleT2/$profile.conf" ]; then
        echo "Error: missing $profile UCM profile in $UCM_SRC"
        exit 1
    fi
done

for driver in AppleT2x2 AppleT2x4 AppleT2x6; do
    if [ ! -r "$UCM_SRC/conf.d/$driver/$driver.conf" ]; then
        echo "Error: missing $driver UCM profile in $UCM_SRC"
        exit 1
    fi
done

echo "Installing Apple T2 ALSA UCM profiles to $UCM_DST"

install -d -o root -g root -m 0755 "$UCM_DST/AppleT2"

# Remove profile files superseded by the split UCM layout.
rm -f \
    "$UCM_DST/AppleT2/HiFi.conf" \
    "$UCM_DST/AppleT2/Measurement-x4.conf"

for profile in HiFi-x2 HiFi-x4 HiFi-x6; do
    install -o root -g root -m 0644 \
        "$UCM_SRC/AppleT2/$profile.conf" "$UCM_DST/AppleT2/$profile.conf"
done

for driver in AppleT2x2 AppleT2x4 AppleT2x6; do
    install -d -o root -g root -m 0755 "$UCM_DST/conf.d/$driver"
    install -o root -g root -m 0644 \
        "$UCM_SRC/conf.d/$driver/$driver.conf" "$UCM_DST/conf.d/$driver/$driver.conf"
done

restart_user_audio
echo "Apple T2 ALSA UCM profile installed"
