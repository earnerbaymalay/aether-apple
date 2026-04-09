# Aether (Apple Edition)

Local AI for macOS and iPad. Integrates with Homebrew on Mac, and iSH or a-Shell on iPad. Maintains the local-first approach of the Android version.

[![Version](https://img.shields.io/badge/version-26.04.2-50fa7b?style=for-the-badge)](https://github.com/earnerbaymalay/aether/blob/main/VERSIONS.md)
[![License](https://img.shields.io/badge/license-MIT-f1fa8c?style=for-the-badge)](LICENSE)

[Quick start](#quick-start) · [Usage guide](USAGE.md) · [Android version](https://github.com/earnerbaymalay/aether)

---

## Quick start

### Mac

```bash
git clone https://github.com/earnerbaymalay/aether-apple.git
cd aether-apple
./install-apple.sh
```

The installer configures Homebrew, downloads llama.cpp, retrieves models, and sets up the `ai` alias. This process takes about 5 minutes.

### iPad (via iSH)

1.  Install [iSH Shell](https://apps.apple.com/app/ish-shell/id1436902243) from the App Store.
2.  In iPad Settings, set iSH memory to 1024MB or higher.
3.  Inside iSH, run:
    ```bash
    apk add git
    git clone https://github.com/earnerbaymalay/aether-apple.git
    cd aether-apple
    ./install-apple.sh
    ```
    Building llama.cpp from source in iSH can take up to 20 minutes due to x86 emulation on ARM, but inference performs well once compiled.

### iPad (via a-Shell)

1.  Install [a-Shell](https://apps.apple.com/app/a-shell/id1473805438) from the App Store.
2.  Inside a-Shell, run:
    ```bash
    git clone https://github.com/earnerbaymalay/aether-apple.git
    cd aether-apple
    ./install-apple.sh
    pip3 install llama-cpp-python
    ```
    This method offers the fastest setup. The `pip3 install llama-cpp-python` step enables direct inference.

---

## Capabilities

### Operational modes

| Mode | Model | Mac (M1) speed | Best for |
|------|-------|----------------|----------|
| Chat | Llama-3.2-3B | ~20 tokens/sec | General questions, writing, analysis |
| Turbo | Qwen-Coder-3B | ~22 tokens/sec | Code, debugging, technical tasks |

### Toolbox

Six integrated tools work across all platforms, including file listing, disk usage, web search, system information, knowledge vault management, and session purging. Battery checks function on Mac but not on iPad due to sandbox restrictions.

### Persistent memory

Knowledge is stored in Markdown files within `knowledge/aethervault/`. The AI accesses these files at the start of each session. You can add notes manually or instruct the AI to learn new information during conversations. The vault format is consistent across Mac, iPad, and Android.

---

## Platform comparison

| Feature | Mac (Full) | iPad iSH (Medium) | iPad a-Shell (Lite) |
|---|---|---|---|
| Engine | llama.cpp (Homebrew) | llama.cpp (from source) | Python + llama-cpp-python |
| Inference speed | 15-50 t/s (Apple Silicon) | 3-8 t/s (x86 emulation) | 5-15 t/s (with Python) |
| Setup duration | ~5 minutes | ~20 minutes (compilation) | ~5 minutes |
| Tools | 6 | 5 (no battery) | 5 (no battery) |
| Memory persistence | Yes | Yes | Yes |

---

## Requirements

- **Mac:** macOS 12+, Apple Silicon (recommended), Homebrew, ~3GB storage.
- **iPad iSH:** Any iPad (last 8 years), iSH app, 1024MB+ iSH memory, ~3GB storage.
- **iPad a-Shell:** Any iPad, a-Shell app, ~3GB storage.

---

## Related projects

- [Aether Android](https://github.com/earnerbaymalay/aether) - Four AI tiers, 17 tools, Termux.
- [Aether Desktop](https://github.com/earnerbaymalay/aether-desktop) - Tauri desktop application.
- [Sideload Hub](https://earnerbaymalay.github.io/sideload/) - Centralized app distribution.

---

## Contributing

Submit bug reports or pull requests via [CONTRIBUTING.md](CONTRIBUTING.md).

---

[MIT License](LICENSE)
