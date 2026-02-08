#!/bin/bash
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team

# Determine if running from source or installed package
if [ -d "config" ] && [ -d "firs" ]; then
    # Running from source directory
    CONFIG_DIR="config"
    FIRS_DIR="firs"
elif [ -d "/usr/share/t2-apple-audio-dsp/config" ] && [ -d "/usr/share/t2-apple-audio-dsp/firs" ]; then
    # Running from installed package
    CONFIG_DIR="/usr/share/t2-apple-audio-dsp/config"
    FIRS_DIR="/usr/share/t2-apple-audio-dsp/firs"
else
    echo "Error: Could not find config or firs directories"
    echo "Please run this script from the source directory or install the package"
    exit 1
fi

# Function to map model names to directory names
# Add more models here as they become available
get_model_dir() {
    case "$1" in
        "MacBookPro16,1")
            echo "16_1"
            ;;
        "MacBookAir9,1")
            echo "9_1"
            ;;
        *)
            return 1
            ;;
    esac
}

# List of supported models (for error messages)
SUPPORTED_MODELS="MacBookPro16,1 MacBookAir9,1"

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
    echo "Copying WirePlumber DSP config to /etc/wireplumber/wireplumber.conf.d"
    sudo mkdir -p /etc/wireplumber/wireplumber.conf.d
    sudo cp ${CONFIG_DIR}/${MODEL_DIR}/*-dsp.conf /etc/wireplumber/wireplumber.conf.d/
fi

# Install FIRs, DSP graphs, and Lua scripts to /usr/share/t2-linux-audio/${MODEL_DIR}
echo "Copying FIRs, DSP graphs, and Lua scripts to /usr/share/t2-linux-audio/${MODEL_DIR}"
sudo mkdir -p /usr/share/t2-linux-audio/${MODEL_DIR}
sudo cp ${FIRS_DIR}/${MODEL_DIR}/*.wav /usr/share/t2-linux-audio/${MODEL_DIR}/ 2>/dev/null
sudo cp ${FIRS_DIR}/${MODEL_DIR}/*.json /usr/share/t2-linux-audio/${MODEL_DIR}/ 2>/dev/null
sudo cp ${FIRS_DIR}/${MODEL_DIR}/*.lua /usr/share/t2-linux-audio/${MODEL_DIR}/ 2>/dev/null
sudo chmod -R o+r /usr/share/t2-linux-audio/${MODEL_DIR}/ 2>/dev/null

# Create symlink for WirePlumber to find Lua scripts
if ls /usr/share/t2-linux-audio/${MODEL_DIR}/*.lua 1> /dev/null 2>&1; then
    echo "Creating symlinks for WirePlumber Lua scripts"
    sudo mkdir -p /usr/share/wireplumber/scripts/device
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
systemctl --user restart wireplumber pipewire pipewire-pulse
echo ""
echo "Installation complete!"
echo "The raw Apple Audio Device should now be hidden."
echo "Only the DSP-processed outputs should be visible."

# Check if mic config exists for this model
if ls ${FIRS_DIR}/${MODEL_DIR}/mic.json 1> /dev/null 2>&1; then
    echo "  - DSP Speakers"
    echo "  - DSP Mic"
else
    echo "  - DSP Speakers"
fi

echo ""
echo "Note: You may need to log out and log back in for changes to fully take effect."
