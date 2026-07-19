#!/bin/sh
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
# Verify that Apple T2 ALSA UCM profiles are installed.

set -e
OK=0
MISSING=0

check() {
    if [ -e "$1" ]; then
        echo "  OK   $1"
        OK=$((OK + 1))
    else
        echo "  MISS $1"
        MISSING=$((MISSING + 1))
    fi
}

echo "=== ALSA UCM profiles ==="
for profile in HiFi-x2 HiFi-x4 HiFi-x6; do
    check "/usr/share/alsa/ucm2/AppleT2/${profile}.conf"
done
for driver in AppleT2x2 AppleT2x4 AppleT2x6; do
    check "/usr/share/alsa/ucm2/conf.d/${driver}/${driver}.conf"
done

echo ""
if [ "$MISSING" -eq 0 ]; then
    echo "All checked UCM files present ($OK items)."
    exit 0
else
    echo "Some UCM items missing ($MISSING). Re-run install: sudo ./install-ucm.sh"
    exit 1
fi
