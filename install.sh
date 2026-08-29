#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2026 Linux T2 Kernel Team
#
# Standalone install: run from the source directory. Installs to the same
# paths as the deb package; see INSTALL_PATHS.md.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" && pwd -P)"
# shellcheck source=restart-user-audio.sh
. "$SCRIPT_DIR/restart-user-audio.sh"

if [ ! -d "configs" ]; then
    echo "Error: Run this script from the source directory (must contain configs/)."
    exit 1
fi
CONFIG_DIR="configs"

# Model dict: "model_id dir_name ..." — add more models here (POSIX sh compatible)
MODEL_DICT="MacBookAir9,1 9_1 MacBookPro15,1 15_1 MacBookPro16,1 16_1 MacBookPro16,2 16_2 MacBookPro16,4 16_4"

get_model_dir() {
    local model="$1"
    set -- $MODEL_DICT
    while [ $# -ge 2 ]; do
        if [ "$1" = "$model" ]; then
            echo "$2"
            return 0
        fi
        shift 2
    done
    return 1
}

# List of supported models (for error messages), derived from dict keys
SUPPORTED_MODELS=$(set -- $MODEL_DICT; while [ $# -ge 2 ]; do echo "$1"; shift 2; done)

# Detect computer model
MODEL=$(cat /sys/class/dmi/id/product_name 2>/dev/null)

if [ -z "$MODEL" ]; then
    echo "Error: Could not detect computer model"
    exit 1
fi

# Get directory name from mapping
MODEL_DIR=$(get_model_dir "$MODEL")
if [ -z "$MODEL_DIR" ]; then
    echo "Error: Model '${MODEL}' is not supported"
    echo "Supported models:"
    for model_name in $SUPPORTED_MODELS; do
        echo "  - ${model_name}"
    done
    exit 1
fi

if [ ! -d "${CONFIG_DIR}/${MODEL_DIR}" ]; then
    echo "Error: Configuration not found for model: ${MODEL}"
    echo "Available models:"
    ls -d ${CONFIG_DIR}/*/ 2>/dev/null | sed 's|.*/||' || echo "  (none found)"
    exit 1
fi

echo "Detected model: ${MODEL} (using directory: ${MODEL_DIR})"
echo "Installing DSP config for ${MODEL}"

# Install WirePlumber DSP config (uses node.software-dsp module like Asahi Linux)
if ls ${CONFIG_DIR}/${MODEL_DIR}/*-dsp.conf 1> /dev/null 2>&1; then
    echo "Installing WirePlumber config to /etc/wireplumber/wireplumber.conf.d"
    sudo install -d -o root -g root -m 0755 /etc/wireplumber/wireplumber.conf.d
    for conf in ${CONFIG_DIR}/${MODEL_DIR}/*-dsp.conf; do
        sudo install -o root -g root -m 0644 "$conf" /etc/wireplumber/wireplumber.conf.d/
    done
fi

# Install FIRs, DSP graphs, wav files, and json files to /usr/share/t2-linux-audio/${MODEL_DIR}
echo "Installing DSP graphs, wav files, and json files to /usr/share/t2-linux-audio/${MODEL_DIR}"
sudo install -d -o root -g root -m 0755 /usr/share/t2-linux-audio/${MODEL_DIR}
for ext in wav json; do
    for file in ${CONFIG_DIR}/${MODEL_DIR}/*.$ext; do
        [ -e "$file" ] || continue
        sudo install -o root -g root -m 0644 "$file" /usr/share/t2-linux-audio/${MODEL_DIR}/
    done
done

# Install Lua scripts to /usr/share/t2-linux-audio/${MODEL_DIR}
echo "Installing Lua scripts to /usr/share/t2-linux-audio/${MODEL_DIR}"
for file in ${CONFIG_DIR}/*.lua; do
    [ -e "$file" ] || continue
    sudo install -o root -g root -m 0644 "$file" /usr/share/t2-linux-audio/${MODEL_DIR}/
done

# Create symlink for WirePlumber to find Lua scripts
if ls /usr/share/t2-linux-audio/${MODEL_DIR}/*.lua 1> /dev/null 2>&1; then
    echo "Creating symlinks for WirePlumber Lua scripts"
    sudo install -d -o root -g root -m 0755 /usr/share/wireplumber/scripts/device
    for lua_file in /usr/share/t2-linux-audio/${MODEL_DIR}/*.lua; do
        lua_basename=$(basename "$lua_file")
        sudo ln -sf "$lua_file" /usr/share/wireplumber/scripts/device/"$lua_basename"
    done
fi

# Clean up old PipeWire configurations (now using WirePlumber for both speakers and mic)
OLD_MODEL_ID=$(echo "$MODEL_DIR" | tr -d '_')
if [ -f "/etc/pipewire/pipewire.conf.d/t2_${OLD_MODEL_ID}_speakers.conf" ]; then
    echo "Removing old PipeWire speaker config (now using WirePlumber)"
    sudo rm -f "/etc/pipewire/pipewire.conf.d/t2_${OLD_MODEL_ID}_speakers.conf"
fi

if [ -f "/etc/pipewire/pipewire.conf.d/t2_${OLD_MODEL_ID}_mic.conf" ]; then
    echo "Removing old PipeWire mic config (now using WirePlumber)"
    sudo rm -f "/etc/pipewire/pipewire.conf.d/t2_${OLD_MODEL_ID}_mic.conf"
fi

echo "Restarting WirePlumber and PipeWire for current user ...."
restart_user_audio
echo ""
echo "Installation complete!"
echo "The raw Apple Audio Device nodes are hidden; only DSP outputs are visible."
echo "Use the DSP nodes for normal playback and recording:"

# Check if mic config exists for this model
if ls ${CONFIG_DIR}/${MODEL_DIR}/mic.json 1> /dev/null 2>&1; then
    echo "  - DSP Speakers"
    echo "  - DSP Mic"
else
    echo "  - DSP Speakers"
fi

echo ""
echo "Note: You may need to log out and log back in for changes to fully take effect."
