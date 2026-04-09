# Aether (Apple Edition) usage guide

Instructions for setup, first launch, and advanced features across Mac and iPad (iSH or a-Shell).

---

## Quick start

### Mac (~5 minutes)

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

Homebrew installs llama.cpp, downloads the model (~2GB), and creates the `ai` alias. After installation, source your shell (`source ~/.zshrc`) then type `ai`.

### iPad (via iSH, ~20 minutes)

1.  Install iSH Shell from the App Store.
2.  In iPad Settings, navigate to iSH and set Memory to 1024MB or higher.
3.  Inside iSH, execute:
    ```bash
    apk add git
    git clone https://github.com/earnerbaymalay/aether-apple.git
    cd aether-apple
    ./install-apple.sh
    ```
    The installer builds llama.cpp from source. This process can take approximately 20 minutes. iSH emulates x86 on ARM, which slows compilation but allows for functional inference.

### iPad (via a-Shell, ~5 minutes)

1.  Install a-Shell from the App Store.
2.  Inside a-Shell, execute:
    ```bash
    git clone https://github.com/earnerbaymalay/aether-apple.git
    cd aether-apple
    ./install-apple.sh
    pip3 install llama-cpp-python
    ```
    The `pip3 install llama-cpp-python` step is crucial as it enables direct inference. Without it, only the interface will be available, not the AI model.

---

## First conversation

Launch Aether using `ai` (Mac), `~/ai` (iSH), or `bash aether-apple.sh` (a-Shell).

Select 'Chat'. If the model is not yet downloaded, you will be prompted to download it (~2GB). On iSH, this download can take 10-15 minutes over Wi-Fi.

Type your query:

```
You: Explain machine learning to a 15-year-old.
```

Type `exit` or use Ctrl+C to return to the menu.

---

## Operational modes

**Chat (Llama-3.2-3B):** Ideal for general questions, writing assistance, and content analysis. Expect about 20 tokens per second on an M1 Mac, or 4 tokens per second on iSH.

**Turbo (Qwen-Coder-3B):** Optimized for code-related tasks, including debugging and technical analysis. Delivers approximately 22 tokens per second on an M1 Mac, and 5 tokens per second on iSH.

Start with 'Chat' for general inquiries, then switch to 'Turbo' for coding tasks.

---

## Toolbox

Access the toolbox from the main menu by selecting 'Tools'.

| Tool | Mac | iPad |
|------|-----|------|
| Date/Time | Yes | Yes |
| Battery | Yes (via pmset) | "Check Control Center" |
| Disk Usage | Yes | Yes |
| File Listing | Yes | Yes |
| Web Search | DuckDuckGo URL | DuckDuckGo URL |
| System Information | Full details | iPad-specific details |
| Knowledge Vault | Yes | Yes |
| Purge Memory | Yes | Yes |

Note that battery checks do not function on iPad due to sandboxing restrictions preventing access to hardware sensors.

---

## Persistent memory

Knowledge is stored as Markdown files within `knowledge/aethervault/`. The AI reads these files at the beginning of each session.

To instruct the AI to learn new information during a chat:
```
You: Learn this: python_tips | Use list comprehensions for efficiency. Example: [x*2 for x in range(10)]
```

Alternatively, you can add files manually:
```bash
echo "# Python Tips" > ~/aether-apple/knowledge/aethervault/python_tips.md
```

The AetherVault format is consistent across Mac, iPad, and Android. You can sync the `knowledge/aethervault/` folder via iCloud Drive, Dropbox, or Obsidian to share knowledge across your devices.

---

## Platform tips

### Mac

For Metal GPU acceleration (providing a 2-3x speedup on Apple Silicon), rebuild llama.cpp:
```bash
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp
cmake -B build -DGGML_METAL=ON
cmake --build build --config Release -j
```

Adjust the `THREADS` variable in `aether-apple.sh` to optimize resource usage. Use 4 threads for lighter loads, or 8 for increased speed on Apple Silicon.

### iSH

Set iSH memory to 1024MB or higher in iPad Settings. Close other applications to free up RAM. For smoother performance with larger models, consider using smaller parameter models.

Add the following alias to `~/.profile` in iSH for convenient access:
```bash
alias ai='cd ~/aether-apple && bash ./aether-apple.sh'
```

### a-Shell

a-Shell stores files in `~/Documents/`. Use the Files app to manage models, knowledge vaults, and session backups.

Models cannot be reliably downloaded directly within a-Shell. Instead, download `.gguf` files on your Mac and transfer them via AirDrop to `~/Documents/aether-apple/models/`.

---

## Troubleshooting

See the separate `TROUBLESHOOTING.md` for common issues and solutions.

---

[MIT License](LICENSE)
