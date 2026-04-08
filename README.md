# Aether -- Apple Edition

Local AI for macOS and iPad. Uses Homebrew on Mac, iSH or a-Shell on iPad. Same local-first approach as the Android version.

[![Version](https://img.shields.io/badge/version-26.04-50fa7b?style=for-the-badge)](https://github.com/earnerbaymalay/aether/blob/main/VERSIONS.md)
[![License](https://img.shields.io/badge/license-MIT-f1fa8c?style=for-the-badge)](LICENSE)

[Quick Start](#quick-start) · [Usage Guide](USAGE.md) · [Android Version](https://github.com/earnerbaymalay/aether)

---

## Quick Start

### Mac

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

The installer handles Homebrew, llama.cpp, model download, and the `ai` alias. Takes about 5 minutes.

### iPad via iSH

1. Install [iSH Shell](https://apps.apple.com/app/ish-shell/id1436902243) from the App Store
2. In iPad Settings, set iSH memory to 1024MB or higher
3. Inside iSH:
```bash
apk add git
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

Builds llama.cpp from source. Takes about 20 minutes because iSH emulates x86 on ARM. Once built, inference runs fine.

### iPad via a-Shell

1. Install [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) from the App Store
2. Inside a-Shell:
```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
pip3 install llama-cpp-python
```

Fastest setup. `pip3 install llama-cpp-python` gives you actual inference.

---

## What You Get

### Two modes

| Mode | Model | Speed on M1 | Best for |
|------|-------|-------------|----------|
| CHAT | Llama-3.2-3B | ~20 tokens/sec | General questions, writing, analysis |
| TURBO | Qwen-Coder-3B | ~22 tokens/sec | Code, debugging, technical tasks |

### Toolbox

Six tools that work on all platforms. File listing, disk usage, web search, system info, knowledge vault, session purge. Battery check works on Mac but not on iPad since sandboxed apps can't read hardware sensors.

### Persistent memory

Knowledge is stored as Markdown in `knowledge/aethervault/`. The AI reads these files at the start of every session. Add notes manually or ask the AI to learn something during chat. The same vault format works across Mac, iPad, and Android.

---

## Platform comparison

| | Mac (Full) | iPad iSH (Medium) | iPad a-Shell (Lite) |
|---|---|---|---|
| Engine | llama.cpp via Homebrew | llama.cpp built from source | Python + llama-cpp-python |
| Speed | 15-50 t/s on Apple Silicon | 3-8 t/s (x86 emulation) | 5-15 t/s if installed |
| Setup time | ~5 minutes | ~20 minutes (build) | ~5 minutes |
| Toolbox | 6 tools | 5 tools (no battery) | 5 tools (no battery) |
| Persistent memory | Yes | Yes | Yes |

---

## Requirements

- **Mac:** macOS 12+, Apple Silicon recommended, Homebrew, ~3GB free
- **iPad iSH:** Any iPad from the last 8 years, iSH from App Store, memory set to 1024MB+, ~3GB free
- **iPad a-Shell:** Any iPad, a-Shell from App Store, ~3GB free

---

## Also available

- [Aether Android](https://github.com/earnerbaymalay/aether) -- 4 AI tiers, 17 tools, Termux
- [Aether Desktop](https://github.com/earnerbaymalay/aether-desktop) -- Tauri desktop app
- [Sideload Hub](https://earnerbaymalay.github.io/sideload/) -- Install any app from one page

---

[MIT License](LICENSE)
