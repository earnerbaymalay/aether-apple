#!/usr/bin/env bash
# 🌌 Aether Apple — System Info (platform-aware)

os_name=$(uname -s 2>/dev/null || echo "unknown")

echo "🖥️  System Information"

if [ "$os_name" = "Darwin" ]; then
    echo "  Platform: macOS / iPadOS"
    if command -v sw_vers &>/dev/null; then
        echo "  OS: $(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
    fi
    if command -v sysctl &>/dev/null; then
        echo "  Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)"
        echo "  RAM: $(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824)) GB"
    fi
elif [ -f "/etc/alpine-release" ]; then
    echo "  Platform: iSH (Alpine Linux on iPad)"
    echo "  Alpine: $(cat /etc/alpine-release 2>/dev/null || 'unknown')"
    echo "  Kernel: $(uname -r 2>/dev/null)"
    echo "  CPU: x86 (emulated)"
else
    echo "  Platform: Apple iPad (sandboxed terminal)"
    echo "  Kernel: $(uname -r 2>/dev/null || 'unknown')"
    echo "  Arch: $(uname -m 2>/dev/null || 'unknown')"
fi

echo "  Hostname: $(hostname 2>/dev/null || echo 'unknown')"
