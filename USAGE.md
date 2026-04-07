# 🌌 AETHER APPLE EDITION — Usage Guide
### *Quick Start to Local AI on macOS*

---

## 🔧 Installation

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

The installer will:
1. ✅ Check for Homebrew (required)
2. ✅ Install `llama.cpp` via Homebrew
3. ✅ Create your workspace directories
4. ✅ Download the starter AI model (~2 GB)
5. ✅ Add the `ai` alias to your shell config

Open a **new terminal** (or run `source ~/.zshrc`) and type `ai`.

---

## 💬 Using Aether

### Main Menu

When you type `ai`, you'll see:

```
   🤖  CHAT  (Default Model)     ← Llama-3.2-3B — general purpose
   ⚡  TURBO (Smaller/Faster)    ← Qwen-Coder-3B — code focused
   🛠️  TOOLS (System Toolbox)   ← macOS system utilities
   📖  KNOWLEDGE (View Vault)    ← See learned knowledge
   ❌  EXIT
```

### Having a Conversation

Select **CHAT** or **TURBO**. If the model isn't downloaded, you'll be asked to download it (~2 GB).

Once loaded, you'll enter a chat loop. Type anything:

```
You: Explain how HTTPS encryption works
AI: [response...]

You: Write a Python script that sorts a CSV file
AI: [code...]

You: What's the meaning of life in 50 words?
AI: [answer...]
```

Type `exit` or press `Ctrl+C` to return to the menu.

---

## 🛠️ Toolbox

From the main menu, select **TOOLS** for:

| Tool | What it does |
|---|---|
| 📅 Date/Time | Shows current system time |
| 🔋 Battery | Reports battery level and charging status |
| 💾 Disk Usage | Shows available and used disk space |
| 📁 List Files | Lists contents of any directory |
| 🔍 Web Search | Generates a DuckDuckGo search URL |
| 🧹 Purge | Clears session memory for a fresh start |

---

## 📚 Context7 Knowledge Vault

Your AI has persistent memory. Unlike ChatGPT or Claude, **Aether remembers what you teach it**.

### How it works:

Knowledge is stored as Markdown files in `knowledge/context7/`.

```bash
# See what's in the vault
ls ~/aether-apple/knowledge/context7/

# Read a file
cat ~/aether-apple/knowledge/context7/some_topic.md

# Add knowledge manually
echo "# My Notes\n\nPython tip: use f-strings" > ~/aether-apple/knowledge/context7/python_tips.md
```

The AI reads these files on every session and incorporates them into its responses. Over time, your AI becomes personalized to your knowledge and workflows.

---

## ⚙️ Advanced Tips

### Faster inference on Apple Silicon

If you want Metal GPU acceleration:

```bash
brew reinstall llama.cpp --HEAD
# Or build from source with Metal:
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build -DGGML_METAL=ON
cmake --build build --config Release -j
```

### Using a different model

Download any `.gguf` model from HuggingFace and place it in `~/aether-apple/models/`. Edit `aether-apple.sh` to point to your model file.

**Recommended models:**
- [Mistral-7B](https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF) — great all-rounder
- [Phi-3-mini](https://huggingface.co/bartowski/Phi-3-mini-4k-instruct-GGUF) — small but smart
- [Qwen-2.5-7B](https://huggingface.co/bartowski/Qwen2.5-7B-Instruct-GGUF) — excellent reasoning

### Adjusting threads

Edit `aether-apple.sh` and change `THREADS`:

```bash
THREADS=$(sysctl -n hw.ncpu)  # Uses all cores
# Or set manually:
THREADS=4  # Use 4 threads (less resource usage)
```

---

## 🔧 Troubleshooting

| Problem | Solution |
|---|---|
| `llama-cli not found` | Run `brew install llama.cpp` |
| `ai: command not found` | Run `source ~/.zshrc` or open a new terminal |
| Model download fails | Download manually and place in `~/aether-apple/models/` |
| AI is very slow | Use a smaller model (1-2B params) or reduce THREADS |
| Out of memory | Close other apps, try a smaller model |
| Session not persisting | Check `~/.aether/sessions/last_session.log` exists |

---

## 📂 File Reference

| File | Purpose |
|---|---|
| `install-apple.sh` | One-command guided installer |
| `aether-apple.sh` | Main TUI and chat orchestrator |
| `toolbox/manifest.json` | Tool registry |
| `toolbox/*.sh` | Individual tool scripts |
| `knowledge/context7/` | Persistent AI memory |
| `models/` | Downloaded `.gguf` model files |
| `~/.aether/sessions/` | Chat session logs |

---

<div align="center">

**🍎 Enjoying local AI on your Mac?** Check out the [Android version](https://github.com/earnerbaymalay/aether) for even more features.

</div>
