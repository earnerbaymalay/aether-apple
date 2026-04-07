#!/usr/bin/env bash
# 🌌 Aether Apple — Read URL as text
if command -v curl &>/dev/null; then
    curl -sL "$1" 2>/dev/null | sed 's/<[^>]*>//g' | head -100
else
    echo "curl not available"
fi
