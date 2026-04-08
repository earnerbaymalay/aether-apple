# Aether Apple -- Usage Guide

Mac and iPad (iSH or a-Shell). All platforms covered.

---

## Quick Start

### Mac (~5 minutes)

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

Homebrew installs llama.cpp, downloads the model (~2GB), creates the `ai` alias. Source your shell (`source ~/.zshrc`) then type `ai`.

### iPad via iSH (~20 minutes)

1. Install iSH Shell from the App Store
2. iPad Settings > iSH > set Memory to 1024MB or higher
3. Inside iSH:
```bash
apk add git
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

The installer builds llama.cpp from source. Takes about 20 minutes. iSH emulates x86 on ARM, so compilation is slow but works fine.

### iPad via a-Shell (~5 minutes)

1. Install a-Shell from the App Store
2. Inside a-Shell:
```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
pip3 install llama-cpp-python
```

`pip3 install llama-cpp-python` gives you actual inference. Without it you get the interface but no model.

---

## First Conversation

Launch with `ai` (Mac), `~/ai` (iSH), or `bash aether-apple.sh` (a-Shell).

Select CHAT. If the model is not downloaded you will be asked to download it (~2GB). On iSH this takes 10-15 minutes on wifi.

Type anything:

```
You: What is machine learning? Explain like I'm 15.
```

Type `exit` or Ctrl+C to return to the menu.

---

## The Two Modes

**CHAT (Llama-3.2-3B):** General questions, writing, analysis. About 20 t/s on M1, 4 t/s on iSH.

**TURBO (Qwen-Coder-3B):** Code, debugging, technical tasks. About 22 t/s on M1, 5 t/s on iSH.

Start with CHAT. Switch to TURBO for code.

---

## Toolbox

From the main menu select TOOLS:

| Tool | Mac | iPad |
|------|-----|------|
| Date/Time | Yes | Yes |
| Battery | Yes (pmset) | "Check Control Center" |
| Disk Usage | Yes | Yes |
| List Files | Yes | Yes |
| Web Search | DuckDuckGo URL | DuckDuckGo URL |
| System Info | Full details | iPad details |
| Knowledge Vault | Yes | Yes |
| Purge Memory | Yes | Yes |

Battery check does not work on iPad because sandboxed apps cannot read hardware sensors.

---

## Persistent Memory

Knowledge is stored as Markdown in `knowledge/aethervault/`. The AI reads these files at the start of each session.

During a chat, tell the AI to learn something:
```
You: Learn this: python_tips|Use list comprehensions. [x*2 for x in range(10)]
```

Or add files manually:
```bash
echo "# Python Tips" > ~/aether-apple/knowledge/aethervault/python_tips.md
```

The same vault format works on Mac, iPad, and Android. Sync the folder via iCloud Drive, Dropbox, or Obsidian to share knowledge across devices.

---

## Platform Tips

### Mac

To get Metal GPU acceleration (2-3x speedup on Apple Silicon), rebuild llama.cpp:
```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build -DGGML_METAL=ON
cmake --build build --config Release -j
```

Adjust `THREADS` in `aether-apple.sh`. 4 threads for lighter resource usage, 8 for speed on Apple Silicon.

### iSH

Set memory to 1024MB or higher in iPad Settings > iSH. Close other apps to free RAM. Use 1-2B parameter models if 3B runs too slow.

Add this to `~/.profile` in iSH for a convenient alias:
```bash
alias ai='cd ~/aether-apple && bash ./aether-apple.sh'
```

### a-Shell

a-Shell stores files in `~/Documents/`. Use the Files app to copy models in and out, share the knowledge vault, or back up sessions.

Models cannot be downloaded reliably inside a-Shell. Download the `.gguf` file on your Mac and AirDrop it to `~/Documents/aether-apple/models/`.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `llama-cli not found` | Mac: `brew install llama.cpp`. iSH: re-run installer. a-Shell: `pip3 install llama-cpp-python` |
| `ai: command not found` | Mac: `source ~/.zshrc`. iSH: run `~/ai`. a-Shell: `cd ~/Documents/aether-apple && bash aether-apple.sh` |
| Model download fails | Check internet. On iSH try `wget` instead of `curl`. On a-Shell, download on Mac and AirDrop |
| AI is slow | Mac: reduce THREADS. iSH: this is normal, use smaller models. a-Shell: install llama-cpp-python |
| Out of memory | Close other apps. iSH: increase memory setting in iPad Settings |

---

[MIT License](LICENSE)
