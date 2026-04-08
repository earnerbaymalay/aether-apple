# 🌌 AETHER APPLE EDITION — Complete Usage Guide
### *Mac + iPad (iSH) + iPad (a-Shell) — All Platforms Covered*

> **Three platforms. One experience. Zero internet required.**

---

## 📑 Table of Contents

1. [Quick Start — Pick Your Platform](#1-quick-start--pick-your-platform)
2. [Your First AI Conversation](#2-your-first-ai-conversation)
3. [Understanding the Two Modes](#3-understanding-the-two-modes)
4. [Using the Toolbox](#4-using-the-toolbox)
5. [Persistent Memory — AetherVault Vault](#5-persistent-memory--context7-vault)
6. [Platform-Specific Tips](#6-platform-specific-tips)
7. [Troubleshooting](#7-troubleshooting)
8. [FAQ](#8-faq)

---

## 1. Quick Start — Pick Your Platform

### 🖥️ Mac (Full Mode — ~5 minutes)

```bash
# 1. Install Homebrew if you haven't
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone and install Aether
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh

# 3. Open a new terminal and launch
ai
```

**What happens:** Homebrew installs llama.cpp → model downloads (~2 GB) → `ai` alias created.

### 📱 iPad via iSH (Medium Mode — ~20 minutes)

**Why iSH?** It's a free Linux emulator on the App Store that can actually compile and run llama.cpp. You get the **full AI engine** — just slower because of x86 emulation.

```
# Step 1: Get iSH
# → Open App Store → Search "iSH Shell" → Install (free)

# Step 2: Increase memory (IMPORTANT)
# → iPad Settings → iSH → Memory → Set to 1024 MB or higher

# Step 3: Inside iSH terminal:
apk add git
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

**What happens:** The installer detects iSH → installs Alpine packages → builds llama.cpp from source (~15-20 min) → downloads model.

**Be patient during build.** iSH emulates x86 on ARM — it's slow but it works. Once built, the AI runs fine.

### 📱 iPad via a-Shell (Lite Mode — ~5 minutes)

**Why a-Shell?** It's the fastest way to get started on iPad. No building, no compiling. Just clone and go — but you'll need to install `llama-cpp-python` manually for real AI.

```
# Step 1: Get a-Shell
# → Open App Store → Search "a-shell" → Install (free)

# Step 2: Inside a-Shell:
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh

# Step 3 (optional but recommended — gives you real AI):
pip3 install llama-cpp-python
```

**What happens:** Installer sets up workspace → no llama.cpp (can't compile on a-Shell) → uses Python fallback → `pip3 install llama-cpp-python` gives you actual inference.

---

## 2. Your First AI Conversation

Launch Aether:
```
ai           # Mac (after sourcing shell)
~/ai         # iSH
bash aether-apple.sh   # a-Shell / direct
```

You'll see the boot sequence, then the main menu. Select **1) CHAT**.

If the model isn't downloaded yet, you'll be asked to download it (~2 GB). On iSH, this may take 10-15 minutes on wifi.

Once loaded, type anything:

```
You: What is machine learning? Explain like I'm 15.
AI: Machine learning is...

You: Write a function that finds prime numbers in Python
AI: def find_primes(n):
       ...

You: Summarize the plot of Interstellar in 3 sentences
AI: A former pilot leads a mission through...
```

Type `exit` or press `Ctrl+C` to return to the menu.

---

## 3. Understanding the Two Modes

### 🤖 CHAT (Llama-3.2-3B) — *Your Daily Driver*
- **What it does:** General questions, writing, analysis, creative work
- **Speed on Mac (M1):** ~20 tokens/sec
- **Speed on iPad (iSH):** ~4 tokens/sec
- **Speed on iPad (a-Shell + llama-cpp-python):** ~10 tokens/sec

### ⚡ TURBO (Qwen-Coder-3B) — *The Coding Specialist*
- **What it does:** Code writing, debugging, refactoring, technical questions
- **Speed on Mac (M1):** ~22 tokens/sec
- **Speed on iPad (iSH):** ~5 tokens/sec
- **Speed on iPad (a-Shell + llama-cpp-python):** ~12 tokens/sec

**Rule of thumb:** Start with CHAT. Switch to TURBO when you need code help.

---

## 4. Using the Toolbox

From the main menu, select **3) TOOLS**:

| # | Tool | What It Does | Mac | iSH | a-Shell |
|---|---|---|---|---|---|
| 1 | 📅 Date/Time | Shows current time | ✅ | ✅ | ✅ |
| 2 | 🔋 Battery | Battery level & status | ✅ Real | ⚠️ "Check Control Center" | ⚠️ "Check Control Center" |
| 3 | 💾 Disk Usage | Available & used space | ✅ | ✅ | ✅ |
| 4 | 📁 List Files | Browse any directory | ✅ | ✅ | ✅ |
| 5 | 🔍 Web Search | DuckDuckGo search URL | ✅ | ✅ | ✅ |
| 6 | 🖥️  System Info | Device details | ✅ Full | ✅ iSH details | ✅ iPad details |
| 7 | 🧠 Knowledge Vault | View learned knowledge | ✅ | ✅ | ✅ |
| 8 | 🧹 Purge Memory | Clear session | ✅ | ✅ | ✅ |

---

## 5. Persistent Memory — AetherVault Vault

> **This is what makes Aether fundamentally different from every cloud AI.**

ChatGPT, Claude, Gemini — they all forget everything when you close the session. **Aether remembers.**

### How it works:

Knowledge is stored as **Markdown files** in `knowledge/aethervault/`. The AI reads these files every time you start a chat.

**Teaching the AI:**
```bash
# Method 1: During chat, tell the AI to learn
You: Learn this: python_tips|Use list comprehensions for faster code. [x*2 for x in range(10)]

# Method 2: Add files manually
echo "# Python Tips\n\nUse list comprehensions: [x*2 for x in range(10)]" > ~/aether-apple/knowledge/aethervault/python_tips.md

# Method 3: Copy notes from Obsidian
cp ~/Documents/obsidian/my_notes.md ~/aether-apple/knowledge/aethervault/
```

**Viewing the vault:**
```bash
ls ~/aether-apple/knowledge/aethervault/
cat ~/aether-apple/knowledge/aethervault/python_tips.md
```

**Why this is powerful:**
- 📚 Build a personal knowledge base over time
- 🧠 The AI gets smarter about YOUR specific work
- 🔄 Knowledge compounds — each session builds on the last
- 📝 Everything is plain Markdown — readable anywhere
- 🔗 Cross-platform — vault works on Mac, iPad, AND Android

---

## 6. Platform-Specific Tips

### 🖥️ Mac Tips

**Get Metal GPU acceleration** (2-3x speedup on Apple Silicon):
```bash
# Rebuild llama.cpp with Metal support
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build -DGGML_METAL=ON
cmake --build build --config Release -j
cp build/bin/llama-cli /opt/homebrew/bin/  # Silicon
# or
cp build/bin/llama-cli /usr/local/bin/     # Intel
```

**Adjust threads** for your machine:
Edit `aether-apple.sh` and change `THREADS`:
```bash
THREADS=4  # Fewer threads = less resource usage
THREADS=8  # More threads = faster (Apple Silicon handles this well)
```

### 📱 iSH Tips

**Speed it up:**
- iPad Settings → iSH → set Memory to **1024MB or higher**
- Close other apps to free up RAM
- Use smaller models (1-2B params) if 3B is too slow
- Be patient during the initial build (~20 minutes)

**Know the limits:**
- iSH emulates x86 — it's inherently slower than native
- Can't access iPad hardware (battery, sensors)
- Works great for chat and code, just slower

**Make it permanent:**
Add to your `~/.profile` in iSH:
```bash
alias ai='cd ~/aether-apple && bash ./aether-apple.sh'
```

### 📱 a-Shell Tips

**Get real AI inference:**
```bash
pip3 install llama-cpp-python
```
Then download a model manually (a-Shell can't curl large files reliably):
1. Download a `.gguf` model on your Mac
2. AirDrop or Files-app it to a-Shell's `~/Documents/aether-apple/models/`

**Use the Files app:**
a-Shell stores files in `~/Documents/`. Use the Files app to:
- Copy model files in/out
- Share knowledge vault with Obsidian
- Backup your sessions

**Keyboard shortcut:**
Use a Bluetooth keyboard with your iPad for the best experience. The on-screen keyboard works but is slower for coding.

---

## 7. Troubleshooting

| Problem | Mac | iSH | a-Shell |
|---|---|---|---|
| `llama-cli not found` | `brew install llama.cpp` | Re-run `./install-apple.sh` | Install `llama-cpp-python` via pip3 |
| `ai: command not found` | `source ~/.zshrc` | Run `~/ai` directly | Run `cd ~/Documents/aether-apple && bash aether-apple.sh` |
| Model download fails | Check internet, try manual curl | iSH may timeout — try wget | Download on Mac, AirDrop to iPad |
| AI is very slow | Reduce THREADS in aether-apple.sh | Normal for iSH — use smaller models | Normal without llama-cpp-python |
| Out of memory | Close apps, use smaller model | Settings → iSH → increase memory to 1024MB+ | Close other iPad apps |
| Battery tool doesn't work | N/A (always works on Mac) | Expected — iSH can't access iPad hardware | Expected — a-Shell is sandboxed |
| Session not persisting | Check `~/.aether/sessions/` | Same path in iSH | Path is `~/Documents/.aether/sessions/` |

---

## 8. FAQ

**Q: Is this really 100% offline?**
A: Yes. After the initial model download, everything runs on your device. No data ever leaves unless you explicitly use the web search tool.

**Q: How much does it cost?**
A: Nothing. No subscriptions, no API keys, no hidden fees. The models are open source and free.

**Q: Which iPad should I use?**
A: Any iPad from the last 8 years works. For the best experience, an M-series iPad Pro with iSH. But even an older iPad with a-Shell will run AI.

**Q: Can I use the same knowledge vault across my Mac and iPad?**
A: Yes! The AetherVault vault is just Markdown files. Sync via iCloud Drive, Dropbox, or Obsidian Sync.

**Q: Are the AI models censored?**
A: No. These are raw, unfiltered models. You get the full experience.

**Q: What models can I use?**
A: Any GGUF format model from HuggingFace. The installer downloads Llama-3.2-3B by default. Try Qwen-Coder for coding, DeepSeek for reasoning, or any GGUF model that fits your storage.

**Q: How do I update Aether?**
A: Run `git pull` in the `aether-apple` directory.

**Q: Can I use this for commercial work?**
A: Yes. The code is MIT licensed. Check each model's license on HuggingFace for their terms.

**Q: Why is iSH so slow during install?**
A: iSH emulates an x86 CPU on your ARM iPad. Building llama.cpp requires compiling C++ code, which is CPU-intensive. It takes ~20 minutes but works. Once built, inference is usable (just not fast).

**Q: Can I share my knowledge vault with someone?**
A: Absolutely. It's just Markdown files. Share the `knowledge/aethervault/` folder, or connect it to a shared Obsidian vault.

---

<div align="center">

### 🌌 *Free. Offline. Private. For everyone.*

[**📱 Get the Android Version →**](https://github.com/earnerbaymalay/aether)

</div>
