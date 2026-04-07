<div align="center">

# 🌌 A E T H E R — A P P L E &nbsp; E D I T I O N

### *Local AI on macOS — No Cloud, No Subscriptions, No Data Leaving Your Device*

[![Status](https://img.shields.io/badge/Status-Beta-50fa7b?style=for-the-badge)]()
[![Engine](https://img.shields.io/badge/Engine-Llama.cpp_Native-81a1c1?style=for-the-badge&logo=c%2B%2B)]()
[![Platform](https://img.shields.io/badge/Platform-macOS_(Apple_Silicon)-4c566a?style=for-the-badge&logo=apple)]()
[![License](https://img.shields.io/badge/License-MIT-f1fa8c?style=for-the-badge)]()

[**⚡ Quick Start**](#-get-started-in-30-seconds) • [**📖 Full Docs**](#-how-it-works) • [**🤖 Android Version**](https://github.com/earnerbaymalay/aether)

---

### 🍎 What is this?

This is the **Apple Edition** of [Aether-AI](https://github.com/earnerbaymalay/aether) — the same philosophy of **100% local, private, offline AI**, adapted for macOS and Apple Silicon.

Your Mac runs the AI. Your Mac owns the AI. No servers. No API keys. No subscriptions.

> **Coming from the Android version?** This is a simplified sibling — single model, macOS-native tools, same local-first ethos.

### 🤔 Apple vs Android — what's different?

| Feature | 📱 Android (Termux) | 🍎 Apple (macOS) |
|---|---|---|
| **Engine** | llama.cpp (built from source) | llama.cpp (via Homebrew) |
| **Models** | 4 tiers (TURBO/AGENT/CODE/LOGIC) | 2 modes (CHAT / TURBO) |
| **Toolbox** | 10+ tools (Termux:API powered) | 5 tools (macOS native) |
| **Agent Mode** | Python agent with tool-use | Direct llama-cli chat |
| **Swarm/Sentinel** | ✅ Yes | ❌ Not available |
| **Obsidian Sync** | ✅ Full integration | ✅ Same (shared vault format) |
| **Context7 Memory** | ✅ Persistent | ✅ Persistent |
| **Privacy** | 100% local | 100% local |
| **Cost** | Free | Free |

---

</div>

## 🚀 Get Started in 30 Seconds

**Prerequisites:** macOS (Apple Silicon recommended), [Homebrew](https://brew.sh/) installed.

```bash
# 1. Clone
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple

# 2. Run the installer
./install-apple.sh

# 3. Launch (in a new terminal)
ai
```

That's it. The installer handles everything: Homebrew dependencies, llama.cpp, model download, and the `ai` alias.

---

## 🧠 What You Get

### Main Menu

```
   ╔══════════════════════════════════════════╗
   ║          🌌  A E T H E R  🌌            ║
   ║    APPLE EDITION // V 1.0               ║
   ╚══════════════════════════════════════════╝

   ┌────────────────────────────────────────────┐
   │  [ SELECT NEURAL PATHWAY ]                 │
   │                                            │
   │  1) 🤖  CHAT  (Default Model)              │
   │  2) ⚡  TURBO (Smaller/Faster Model)       │
   │  3) 🛠️  TOOLS (System Toolbox)            │
   │  4) 📖  KNOWLEDGE (View Context7 Vault)   │
   │  5) ❌  EXIT                               │
   └────────────────────────────────────────────┘
```

### Two Modes:

| Mode | Model | Speed | Best For |
|---|---|---|---|
| 🤖 **CHAT** | Llama-3.2-3B | ~20 t/s on M1 | General questions, writing, analysis |
| ⚡ **TURBO** | Qwen-Coder-3B | ~22 t/s on M1 | Code, technical tasks, debugging |

### Toolbox (macOS Native):

- 📅 **Date/Time** — Current system time
- 🔋 **Battery** — macOS battery status via `pmset`
- 💾 **Disk Usage** — Available and used storage
- 📁 **List Files** — Browse any directory
- 🔍 **Web Search** — DuckDuckGo search URL generator
- 🧹 **Purge** — Clear session memory

### Context7 Persistent Memory:

Same as the Android version — knowledge is stored as Markdown in `knowledge/context7/` and persists across sessions. Drop files in manually or let the AI learn during chat.

---

## 📂 Project Structure

```
aether-apple/
├── install-apple.sh       ← One-command installer (Homebrew + llama.cpp)
├── aether-apple.sh        ← Main TUI orchestrator
├── toolbox/
│   ├── manifest.json      ← Tool registry
│   ├── get_date.sh
│   ├── get_battery.sh
│   ├── list_files.sh
│   ├── web_search.sh
│   └── web_read.sh
├── knowledge/
│   └── context7/          ← Persistent AI memory (Markdown)
├── skills/                ← Drop-in AI behavior modules
├── scripts/               ← Future: macOS-specific scripts
└── models/                ← Downloaded .gguf files (gitignored)
```

---

## 🍎 macOS-Specific Notes

### Apple Silicon (M1/M2/M3/M4)
- **Highly recommended.** llama.cpp is optimized for ARM NEON on Apple Silicon.
- Expect 15-30 tokens/sec on M1, 25-50 on M2/M3.
- Metal acceleration is available — rebuild llama.cpp with `-DGGML_METAL=ON` for max performance.

### Intel Macs
- Will work but slower. Expect 5-15 tokens/sec depending on CPU.
- Consider using smaller models (1-2B parameters) for reasonable speed.

### Homebrew
- Required. The installer checks for it and won't proceed without it.
- Install: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

---

## 🤝 Relationship to Android Version

This is a **sibling project** to the main [Aether-AI](https://github.com/earnerbaymalay/aether) repository.

| | Android | Apple |
|---|---|---|
| **Repo** | [aether](https://github.com/earnerbaymalay/aether) | [aether-apple](https://github.com/earnerbaymalay/aether-apple) |
| **Platform** | Termux on Android | macOS (Terminal) |
| **Complexity** | Full (swarm, sentinel, agent) | Streamlined (chat + tools) |
| **Philosophy** | Same — local-first, private, free | Same — local-first, private, free |

> **Want the full experience?** If you have an Android device too, check out the [main Aether repo](https://github.com/earnerbaymalay/aether) for multi-tier routing, agent tool-use, swarm orchestration, and more.

---

## 📋 Requirements

- **macOS 12+** (Monterey or later)
- **Apple Silicon** (M1/M2/M3/M4) — *strongly recommended, Intel works but is slower*
- **Homebrew** installed
- **~3 GB free storage** (for the AI model)
- **4+ GB RAM**

---

## 📜 License

[MIT License](LICENSE) — Use it. Modify it. Share it.

---

<div align="center">

### 🌌 *Develop natively. Think locally. Evolve autonomously.*

**⭐ Star this repo if you believe AI should be free and private.**

[**📱 Get the Android Version →**](https://github.com/earnerbaymalay/aether)

</div>
