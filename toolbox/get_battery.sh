#!/usr/bin/env bash
# 🌌 Aether Apple — Battery Status
if command -v pmset &>/dev/null; then
    pmset -g batt 2>/dev/null || echo "Battery info unavailable"
else
    echo "pmset not available"
fi
