<div align="center">

# 🌌 A E T H E R — A P P L E &nbsp; E D I T I O N
### *Free. Offline. Private. AI on Every Apple Device.*

<p align="center">
  <a href="https://earnerbaymalay.github.io/sideload/">
    📲 <strong>Install on any device — phone, Mac, or iPad — from one place: Sideload Hub</strong>
  </a>
</p>

[![Version](https://img.shields.io/badge/version-26.04-50fa7b?style=for-the-badge)](https://github.com/earnerbaymalay/aether/blob/main/VERSIONS.md)
[![Engine](https://img.shields.io/badge/Engine-Llama.cpp_%7C_Python-81a1c1?style=for-the-badge&logo=c%2B%2B)](https://github.com/ggerganov/llama.cpp)
[![Platform](https://img.shields.io/badge/Platform-macOS_%7C_iPad-4c566a?style=for-the-badge&logo=apple)](https://github.com/earnerbaymalay/aether-apple)
[![License](https://img.shields.io/badge/License-MIT-f1fa8c?style=for-the-badge)](LICENSE)
[![Privacy](https://img.shields.io/badge/Privacy-100%25_Local_Offline-bd93f9?style=for-the-badge)](#-why-does-this-exist)

[**⚡ Quick Start**](#-get-started-in-60-seconds) · [**📖 Full Guide**](USAGE.md) · [**🗺️ Version History**](https://github.com/earnerbaymalay/aether/blob/main/VERSIONS.md) · [**🤖 Android Version**](https://github.com/earnerbaymalay/aether)

</div>

---

## 🧬 The Mission

This is the **Apple Edition** of [Aether-AI](https://github.com/earnerbaymalay/aether) — the same philosophy of **100% local, private, offline AI**, adapted for macOS and iPad.

Your Mac runs the AI. Your Mac owns the AI. No servers. No API keys. No subscriptions.

> **Coming from the Android version?** This is a simplified sibling — single model, macOS-native tools, same local-first ethos.

---

## 🔥 Why Does This Exist?

Because **everyone deserves free AI** — not just people with $20/month subscriptions and fast internet.

| | **Cloud AI** (ChatGPT, Claude) | **Aether Apple** |
|---|---|---|
| 💰 Cost | $20–200/month | **Free forever** |
| 🌐 Internet | Required | **Not needed — works on a plane** |
| 🔒 Privacy | Your data on their servers | **Zero bytes leave your device** |
| 📱 Devices | Browser only | **Mac + iPad + anywhere** |
| ⏱️ Availability | Goes down, rate limits | **Always on — your hardware** |

---

## 👋 Three Ways to Run Aether on Apple

Aether adapts to your device. Here's what each experience looks like:

| | 🖥️ **macOS (Full)** | 📱 **iPad via iSH (Medium)** | 📱 **iPad via a-Shell (Lite)** |
|---|---|---|---|
| **What is it?** | Native macOS terminal | Free Linux emulator app from App Store | Free sandboxed terminal app |
| **AI Engine** | llama.cpp (Homebrew) | llama.cpp (built from source) | Python (llama-cpp-python) |
| **Speed** | ⚡⚡⚡ 15-50 t/s on Apple Silicon | ⚡ 3-8 t/s (x86 emulation) | ⚡⚡ 5-15 t/s if installed |
| **Models** | 2 modes (CHAT / TURBO) | 2 modes (same models) | 2 modes (same models) |
| **Toolbox** | 6 tools (macOS native) | 5 tools (no battery — sandboxed) | 5 tools (no battery — sandboxed) |
| **AetherVault** | ✅ Persistent memory | ✅ Persistent memory | ✅ Persistent memory |
| **Setup Time** | ~5 minutes | ~20 minutes (build time) | ~5 minutes |
| **Get it from** | Terminal + Homebrew | [iSH on App Store](https://apps.apple.com/app/ish-shell/id1436902243) | [a-Shell on App Store](https://apps.apple.com/app/a-shell/id1473805438) |

> **💡 Bottom line:** Every Apple device can run local AI. The experience scales with the platform, but **the philosophy is the same — free, private, offline.**

---

## 🚀 Get Started in 60 Seconds

### 🖥️ On Mac:

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

The installer handles everything: Homebrew → llama.cpp → model download → `ai` alias.

### 📱 On iPad (iSH — recommended for full AI):

1. Install **[iSH Shell](https://apps.apple.com/app/ish-shell/id1436902243)** from the App Store (free)
2. Open iSH and run:
```bash
apk add git
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```
The installer will build llama.cpp from source (~20 minutes). **Set iSH memory to 1024MB+** in iPad Settings → iSH.

### 📱 On iPad (a-Shell — quickest setup):

1. Install **[a-Shell](https://apps.apple.com/app/a-shell/id1473805438)** from the App Store (free)
2. Clone and install:
```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```
3. For real AI inference: `pip3 install llama-cpp-python` (optional but recommended)

> **Which iPad method should I use?**
> - Want the **best AI experience**? → **iSH** (runs llama.cpp natively)
> - Want the **fastest setup**? → **a-Shell** (5 minutes, but needs manual model)
> - Have an **M-series iPad Pro**? → Both work great, iSH gives you the full engine

---

## 🧠 What You Get

### Main Menu (adapts to your platform)

```
   ╔══════════════════════════════════════════╗
   ║          🌌  A E T H E R  🌌            ║
   ║  APPLE EDITION // V 2.0 // macos        ║
   ╚══════════════════════════════════════════╝

   ┌────────────────────────────────────────────┐
   │  [ SELECT NEURAL PATHWAY ]                 │
   │                                            │
   │  1) 🤖  CHAT  (Default Model)              │
   │  2) ⚡  TURBO (Smaller/Faster Model)       │
   │  3) 🛠️  TOOLS (System Toolbox)            │
   │  4) 📖  KNOWLEDGE (View AetherVault Vault)   │
   │  5) ℹ️  PLATFORM INFO                    │
   │  6) ❌  EXIT                               │
   └────────────────────────────────────────────┘
```

### Two Modes:

| Mode | Model | Speed | Best For |
|---|---|---|---|
| 🤖 **CHAT** | Llama-3.2-3B | ~20 t/s on M1 | General questions, writing, analysis |
| ⚡ **TURBO** | Qwen-Coder-3B | ~22 t/s on M1 | Code, technical tasks, debugging |

### Toolbox (platform-aware):

| Tool | macOS | iPad |
|---|---|---|
| 📅 Date/Time | ✅ Real | ✅ Real |
| 🔋 Battery | ✅ Real (`pmset`) | ⚠️ "Check Control Center" |
| 💾 Disk Usage | ✅ Real | ✅ Real |
| 📁 List Files | ✅ Real | ✅ Real |
| 🔍 Web Search | ✅ DuckDuckGo URL | ✅ DuckDuckGo URL |
| 🖥️ System Info | ✅ Full details | ✅ Platform details |
| 🧠 Knowledge Vault | ✅ | ✅ |
| 🧹 Purge Memory | ✅ | ✅ |

### AetherVault Persistent Memory — Works Everywhere

Same as the Android version. Your AI's knowledge is stored as **plain Markdown files** in `knowledge/aethervault/`. This means:

- 📝 **iPad → Mac → Android → iPad** — your knowledge vault travels with you
- 🔗 **Connect to Obsidian** on any device for visual knowledge graphs
- ✏️ **Edit manually** — add notes, tips, code snippets as `.md` files

---

## 💡 "What Can I Actually Do With This on My iPad?"

| Scenario | How It Works |
|---|---|
| 📝 **Study on the train** | Open CHAT → "Explain quantum entanglement" → get a detailed answer. No wifi. |
| 💻 **Code review on iPad** | TURBO mode → paste your code → get suggestions. Works great with keyboard. |
| 📚 **Research offline** | Ask the AI anything — it has the training data baked in. No internet = no problem. |
| 🧠 **Build personal knowledge** | "Learn this: Python decorator pattern" → saved forever. Next session, it remembers. |
| ✍️ **Writing assistant** | "Help me write a cover letter" → it drafts. "Make it more professional" → it revises. |

---

## 🏗️ Architecture at a Glance

```
aether-apple/
├── install-apple.sh       ← Auto-detects Mac / iSH / a-Shell
├── aether-apple.sh        ← Platform-adaptive TUI orchestrator
├── toolbox/
│   ├── manifest.json      ← Tool registry
│   ├── get_date.sh        ← Date/time (all platforms)
│   ├── get_battery.sh     ← Battery (macOS real, iPad graceful fallback)
│   ├── list_files.sh      ← File listing
│   ├── web_search.sh      ← DuckDuckGo search
│   ├── web_read.sh        ← URL content reader
│   └── sys_info.sh        ← System info (platform-aware)
├── knowledge/
│   └── aethervault/          ← Persistent AI memory (Markdown, cross-platform)
├── skills/                ← Drop-in AI behavior modules
├── scripts/               ← Platform-specific scripts
└── models/                ← Downloaded .gguf files (gitignored)
```

---

## 📲 All Apps, One Place

All our apps are available through **[Sideload](https://earnerbaymalay.github.io/sideload/)** — our central distribution hub for local-first apps. One tap to install on any device.

| | 📱 Android (Flagship) | 🖥️ Mac (Full) | 📱 iPad (iSH) | 📱 iPad (a-Shell) |
|---|---|---|---|---|
| **AI Models** | 4 tiers | 2 modes | 2 modes | 2 modes |
| **Tools** | 10+ (Termux:API) | 6 (macOS native) | 5 | 5 |
| **Advanced** | Swarm, Sentinel, Agent | Chat + Toolbox | Chat + Toolbox | Chat + Toolbox |
| **Price** | Free | Free | Free | Free |
| **Privacy** | 100% local | 100% local | 100% local | 100% local |

> **One philosophy across every device.** The Android version is the full-power experience. The Apple edition covers Mac (full), iPad via iSH (medium), and iPad via a-Shell (lite). **Use them together — they share the same knowledge format.**

---

## 📋 Requirements

### For Mac:
- macOS 12+ (Monterey or later)
- Apple Silicon (M1/M2/M3/M4) — *strongly recommended*
- Homebrew (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`)
- ~3 GB free storage

### For iPad (iSH):
- iPad with iOS 14+ (any iPad from the last 8+ years)
- [iSH Shell](https://apps.apple.com/app/ish-shell/id1436902243) (free, App Store)
- Set memory to **1024MB+** in Settings → iSH
- ~3 GB free storage on iPad
- Wifi for initial setup and model download

### For iPad (a-Shell):
- iPad with iOS 14+
- [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) (free, App Store)
- ~3 GB free storage
- `pip3 install llama-cpp-python` for real AI (optional)

---

## 🤝 Contributing

Aether is built by people who believe AI should be **free, private, and local**. Whether you're a developer, writer, or just someone with a cool idea — you're welcome here.

- 🐛 Found a bug? [Open an issue](https://github.com/earnerbaymalay/aether-apple/issues)
- 💡 Have an idea? [Start a discussion](https://github.com/earnerbaymalay/aether-apple/discussions)
- 🔧 Want to code? Fork the repo and submit a PR!

---

## 📜 License

[MIT License](LICENSE) — Use it. Modify it. Share it.

---

<div align="center">

### 🌌 *Develop natively. Think locally. Evolve autonomously.*

**⭐ Star this repo if you believe AI should be free and private.**

[**📱 Get the Android Version →**](https://github.com/earnerbaymalay/aether)

</div>
