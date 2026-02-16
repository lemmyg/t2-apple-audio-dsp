#!/bin/sh
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
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

echo "=== WirePlumber DSP config ==="
dsp_conf="/etc/wireplumber/wireplumber.conf.d/51-t2-dsp.conf"
check "$dsp_conf"

echo ""
echo "=== Audio data: /usr/share/t2-linux-audio/<model>/ ==="
for model in 16_1 9_1; do
    dir="/usr/share/t2-linux-audio/$model"
    if [ -d "$dir" ]; then
        check "$dir"
        check "$dir/graph.json"
        check "$dir/t2-force-unmute.lua"
        [ "$model" = "16_1" ] && check "$dir/mic.json"
        # At least one .wav
        if ls "$dir"/*.wav 1>/dev/null 2>&1; then
            echo "  OK   $dir/*.wav (present)"
            OK=$((OK + 1))
        else
            echo "  MISS $dir/*.wav"
            MISSING=$((MISSING + 1))
        fi
    else
        echo "  skip $dir (not present)"
    fi
done

echo ""
echo "=== Lua symlinks: /usr/share/wireplumber/scripts/device/ -> t2-linux-audio ==="
t2_lua="/usr/share/wireplumber/scripts/device/t2-force-unmute.lua"
if [ -L "$t2_lua" ]; then
    target=$(readlink -f "$t2_lua" 2>/dev/null || readlink "$t2_lua" 2>/dev/null)
    case "$target" in
        /usr/share/t2-linux-audio/*)
            echo "  OK   $t2_lua -> $target"
            OK=$((OK + 1))
            ;;
        *)
            echo "  ??   $t2_lua -> $target (not under t2-linux-audio)"
            ;;
    esac
else
    echo "  MISS $t2_lua (symlink)"
    MISSING=$((MISSING + 1))
fi

echo ""
if [ "$MISSING" -eq 0 ]; then
    echo "All checked files present ($OK items)."
    exit 0
else
    echo "Some items missing ($MISSING). Re-run install: ./install.sh or sudo t2-apple-audio-dsp-install"
    exit 1
fi
