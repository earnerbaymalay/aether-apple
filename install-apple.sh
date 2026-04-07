#!/usr/bin/env bash
# 🌌 Aether-AI Apple Edition Installer // V 1.0
# macOS / iOS (a-Shell) compatible
# Uses Homebrew for llama.cpp and basic CLI tools

set -e

# --- Configuration ---
ACCENT="#81a1c1"; SUC="#50fa7b"; ERR="#ff5555"
DIR="$HOME/aether-apple"

# --- UI Helpers ---
header() {
    clear 2>/dev/null || true
    echo ""
    echo -e "\033[1;34m  ╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;34m  ║          🌌  A E T H E R  🌌           ║\033[0m"
    echo -e "\033[1;34m  ║     NEURAL INTERFACE // APPLE EDITION   ║\033[0m"
    echo -e "\033[1;34m  ╚══════════════════════════════════════════╝\033[0m"
    echo ""
}

# --- Detection ---
detect_os() {
    if [[ "$(uname)" == "Darwin" ]]; then
        OS="macos"
        echo -e "\033[1;32m[+]\033[0m Detected macOS: $(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
        echo -e "\033[1;32m[+]\033[0m Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)"
    else
        OS="unknown"
        echo -e "\033[1;33m[!]\033[0m Warning: Not on macOS. Some features may differ."
    fi
}

check_homebrew() {
    if ! command -v brew &>/dev/null; then
        echo -e "\033[1;31m[!]\033[0m Homebrew not found. It's required for Aether."
        echo -e "\033[1;34m[i]\033[0m Install it first: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    echo -e "\033[1;32m[+]\033[0m Homebrew found: $(brew --version | head -1)"
}

# --- Installation ---
install_deps() {
    header
    echo -e "\033[1;34m[*]\033[0m Installing dependencies via Homebrew..."
    brew install llama.cpp coreutils 2>/dev/null || {
        echo -e "\033[1;33m[!]\033[0m llama.cpp may already be installed or failed partially."
        echo -e "\033[1;33m[!]\033[0m Continuing anyway — we'll check for binaries."
    }
}

find_llama() {
    # Check common Homebrew paths
    if command -v llama-cli &>/dev/null; then
        BIN=$(command -v llama-cli)
        echo -e "\033[1;32m[+]\033[0m Found llama-cli at: $BIN"
        return 0
    elif [ -f "/opt/homebrew/bin/llama-cli" ]; then
        BIN="/opt/homebrew/bin/llama-cli"
        echo -e "\033[1;32m[+]\033[0m Found llama-cli at: $BIN"
        return 0
    elif [ -f "/usr/local/bin/llama-cli" ]; then
        BIN="/usr/local/bin/llama-cli"
        echo -e "\033[1;32m[+]\033[0m Found llama-cli at: $BIN"
        return 0
    else
        echo -e "\033[1;31m[!]\033[0m llama-cli not found after install."
        echo -e "\033[1;34m[i]\033[0m Try: brew install llama.cpp"
        return 1
    fi
}

create_structure() {
    header
    echo -e "\033[1;34m[*]\033[0m Creating workspace structure..."
    mkdir -p "$HOME/.aether/sessions"
    mkdir -p "$DIR/models"
    mkdir -p "$DIR/knowledge/context7"
    mkdir -p "$DIR/toolbox"
    mkdir -p "$DIR/scripts"
    mkdir -p "$DIR/skills"
    echo -e "\033[1;32m[+]\033[0m Workspace ready."
}

create_alias() {
    header
    echo -e "\033[1;34m[*]\033[0m Creating 'ai' alias..."

    local shell_rc="$HOME/.zshrc"
    [ -f "$HOME/.bash_profile" ] && shell_rc="$HOME/.bash_profile"

    # Remove old alias if exists
    if [ -f "$shell_rc" ]; then
        sed -i '' '/# aether-apple alias/d' "$shell_rc" 2>/dev/null || true
        sed -i '' '/alias ai=/d' "$shell_rc" 2>/dev/null || true
    fi

    echo "# aether-apple alias" >> "$shell_rc"
    echo "alias ai='cd $DIR && bash ./aether-apple.sh'" >> "$shell_rc"

    echo -e "\033[1;32m[+]\033[0m Alias added to $shell_rc"
    echo -e "\033[1;34m[i]\033[0m Run 'source $shell_rc' or open a new terminal to use 'ai'"
}

download_model() {
    header
    local model_url="https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
    local model_name="llama-3.2-3b.gguf"
    local model_path="$DIR/models/$model_name"

    if [ -f "$model_path" ]; then
        echo -e "\033[1;32m[+]\033[0m Model already downloaded: $model_path"
        return 0
    fi

    echo -e "\033[1;34m[*]\033[0m Downloading starter model (~2 GB)..."
    echo -e "\033[1;34m[*]\033[0m This may take a few minutes..."
    curl -L -o "$model_path" "$model_url" || {
        echo -e "\033[1;31m[!]\033[0m Download failed. You can manually download later."
        echo -e "\033[1;34m[i]\033[0m Place a .gguf file in $DIR/models/ and rename to llama-3.2-3b.gguf"
        return 1
    }
    echo -e "\033[1;32m[+]\033[0m Model downloaded: $model_path ($(du -h "$model_path" | cut -f1))"
}

# --- Main ---
header
echo -e "\033[1;30m   Welcome to the Aether Apple Edition Installer\033[0m"
echo ""
echo -e "This will set up a local-first AI interface on your Apple device."
echo -e "Requires: Homebrew, ~3 GB storage, 4+ GB RAM"
echo ""
read -p "Continue? (y/n): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "Aborted." && exit 0

detect_os
check_homebrew
create_structure
install_deps
find_llama || true
download_model || true
create_alias

header
echo -e "\033[1;32m  ╔══════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m  ║        🎉  INSTALLATION COMPLETE  🎉     ║\033[0m"
echo -e "\033[1;32m  ╚══════════════════════════════════════════╝\033[0m"
echo ""
echo -e "  Launch Aether by typing:  \033[1;32mai\033[0m"
echo -e "  Or run:  \033[1;34mbash $DIR/aether-apple.sh\033[0m"
echo ""
echo -e "  \033[1;30mApple Edition limitations vs Android:\033[0m"
echo -e "  • Single model (no multi-tier routing)"
echo -e "  • No Termux:API (battery, hardware via macOS tools)"
echo -e "  • No background sentinel or swarm orchestration"
echo -e "  • Toolbox has macOS equivalents (fewer tools)"
echo ""
echo -e "  🌌 \033[1;34mAether: Develop natively. Think locally. Evolve autonomously.\033[0m"
echo ""
