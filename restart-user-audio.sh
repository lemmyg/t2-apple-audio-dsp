#!/bin/sh
# SPDX-License-Identifier: MIT
# (C) 2025 Linux T2 Kernel Team
#
# Restart WirePlumber/PipeWire for the user who invoked sudo.
# Source this file from install/uninstall scripts.

restart_user_audio() {
    user="${SUDO_USER:-}"
    if [ -z "$user" ] || [ "$user" = root ]; then
        if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ "$(id -u)" -ne 0 ]; then
            echo "Restarting WirePlumber and PipeWire"
            systemctl --user restart wireplumber pipewire pipewire-pulse
            return 0
        fi
        echo "Note: restart WirePlumber and PipeWire manually after login"
        return 0
    fi

    uid="$(id -u "$user")"
    runtime="/run/user/$uid"
    if [ ! -d "$runtime" ]; then
        echo "Note: user runtime $runtime is not active; restart WirePlumber and PipeWire after login"
        return 0
    fi

    echo "Restarting WirePlumber and PipeWire for $user"
    runuser -u "$user" -- env XDG_RUNTIME_DIR="$runtime" \
        systemctl --user restart wireplumber pipewire pipewire-pulse
}
