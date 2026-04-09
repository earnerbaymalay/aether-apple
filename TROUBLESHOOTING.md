# Aether (Apple Edition) troubleshooting guide

Common issues and solutions for Mac and iPad.

---

## Installation issues

### `llama-cli not found`
- **Mac:** Run `brew install llama.cpp`.
- **iSH:** Re-run the installer script.
- **a-Shell:** Ensure `pip3 install llama-cpp-python` was successful.

### `ai: command not found`
- **Mac:** Source your shell configuration file (e.g., `source ~/.zshrc`).
- **iSH:** Run Aether via its direct path: `~/aether-apple/aether-apple.sh`.
- **a-Shell:** Navigate to the directory: `cd ~/Documents/aether-apple && bash aether-apple.sh`.

### Model download fails
- Verify your internet connection.
- **iSH:** If `curl` fails, try using `wget` for the download.
- **a-Shell:** Download models on another device (e.g., Mac) and transfer them via AirDrop. Direct downloads within a-Shell can be unreliable.

---

## Performance issues

### AI is slow
- **Mac:** Adjust `THREADS` in `aether-apple.sh` (e.g., to 4 for lighter use).
- **iSH:** This is normal due to emulation. Use smaller models (e.g., 1-2B parameters).
- **a-Shell:** Ensure `llama-cpp-python` is installed for native performance.

### Out of memory
- Close other running applications.
- **iSH:** Increase the memory allocation for iSH in iPad Settings.

---

[MIT License](LICENSE)