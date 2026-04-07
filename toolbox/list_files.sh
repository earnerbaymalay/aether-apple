#!/usr/bin/env bash
# 🌌 Aether Apple — List Files
ls -la "${1:-.}" 2>/dev/null | head -30
