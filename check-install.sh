#!/bin/sh
# SPDX-License-Identifier: MIT
# (C) 2026 Linux T2 Kernel Team
# Verify that all T2 Apple Audio DSP files are installed (see INSTALL_PATHS.md).

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

# Supported models, must stay in sync with install.sh and debian/postinst
SUPPORTED_DIRS="8_1 8_2 9_1 15_1 15_2 15_4 16_1 16_2 16_3 16_4"

MODEL=$(cat /sys/class/dmi/id/product_name 2>/dev/null)
# DMI name e.g. MacBookPro16,1 -> config dir 16_1 (\2=major, \3=minor; \1 Air/Pro unused)
model=$(printf '%s\n' "$MODEL" | sed -n 's/^MacBook\(Air\|Pro\)\([0-9][0-9]*\),\([0-9][0-9]*\)/\2_\3/p')
supported=no
for dir in $SUPPORTED_DIRS; do
    if [ "$dir" = "$model" ]; then
        supported=yes
    fi
done
if [ "$supported" != yes ]; then
    echo "Error: unsupported model: ${MODEL:-unknown}"
    exit 1
fi

echo "=== t2bce_audio + udev ALSA card rename ==="
check /sys/module/t2bce_audio
check /etc/udev/rules.d/99-t2-audio-rename.rules
t2_card_id=
for idfile in /sys/devices/pci0000:00/*/*/t2bce_audio/t2bce_audio/card?/id; do
    [ -f "$idfile" ] || continue
    t2_card_id=$(cat "$idfile")
    break
done
case "$t2_card_id" in
    t2-*) echo "  OK   ALSA card id=$t2_card_id"; OK=$((OK + 1)) ;;
    *)    echo "  MISS t2bce_audio ALSA card id (${t2_card_id:-not found})"; MISSING=$((MISSING + 1)) ;;
esac

echo ""
echo "=== WirePlumber DSP config ==="
check /etc/wireplumber/wireplumber.conf.d/50-t2-audio.conf

echo ""
echo "=== Audio data: /usr/share/t2linux-audio/$model/ ==="
dir="/usr/share/t2linux-audio/$model"
check "$dir"
check "$dir/graph.json"
check "$dir/mic.json"
# At least one .wav
if ls "$dir"/*.wav 1>/dev/null 2>&1; then
    echo "  OK   $dir/*.wav (present)"
    OK=$((OK + 1))
else
    echo "  MISS $dir/*.wav"
    MISSING=$((MISSING + 1))
fi

echo ""
if [ "$MISSING" -eq 0 ]; then
    echo "All checked files present ($OK items)."
    exit 0
else
    echo "Some items missing ($MISSING). Re-run install: ./install.sh"
    exit 1
fi
