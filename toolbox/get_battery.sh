#!/usr/bin/env bash
# 🌌 Aether Apple — Battery Status (platform-aware)

os_name=$(uname -s 2>/dev/null || echo "unknown")

if [ "$os_name" = "Darwin" ] && command -v pmset &>/dev/null; then
    # macOS — real battery data
    pmset -g batt 2>/dev/null || echo "Battery info unavailable"
elif [ -f "/etc/alpine-release" ]; then
    # iSH — can't access iPad hardware
    echo "🔋 Battery: Not accessible in iSH (sandboxed emulator)"
    echo "   Check your iPad's Control Center for battery info"
else
    # a-Shell / lite — sandboxed
    echo "🔋 Battery: Not accessible in this terminal (sandboxed)"
    echo "   Check your iPad's Control Center for battery info"
fi
