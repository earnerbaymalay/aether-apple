#!/usr/bin/env bash
# 🌌 Aether-AI Neural Interface // Apple Edition V 1.0
# macOS compatible — runs via llama-cli (Homebrew)
# Simplified vs Android: single model, macOS-native toolbox

# --- Configuration ---
ACCENT="#81a1c1"; DIM="#4c566a"; WHITE="#eceff4"; RED="#ff5555"
DIR="$HOME/aether-apple"
SESSION_DIR="$HOME/.aether/sessions"
THREADS=$(sysctl -n hw.ncpu 2>/dev/null || echo 6)

# --- Find llama-cli ---
find_llama_bin() {
    if command -v llama-cli &>/dev/null; then
        echo "$(command -v llama-cli)"
    elif [ -f "/opt/homebrew/bin/llama-cli" ]; then
        echo "/opt/homebrew/bin/llama-cli"
    elif [ -f "/usr/local/bin/llama-cli" ]; then
        echo "/usr/local/bin/llama-cli"
    else
        echo ""
    fi
}

BIN=$(find_llama_bin)

# --- Dependencies check ---
check_deps() {
    if [ -z "$BIN" ]; then
        echo -e "\033[1;31m[!] llama-cli not found.\033[0m"
        echo -e "Run: brew install llama.cpp"
        echo -e "Or re-run: ./install-apple.sh"
        exit 1
    fi
}

# --- Persistence engine ---
get_context() {
    if [ -f "$SESSION_DIR/last_session.log" ]; then
        tail -c 1000 "$SESSION_DIR/last_session.log" | tr '\n' ' ' | sed 's/"/\\"/g'
    else
        echo "Starting fresh session."
    fi
}

# --- Boot sequence ---
boot_sequence() {
    clear 2>/dev/null || true
    echo -e "\n\n"
    echo -e "\033[1;34m  ╔══════════════════════════════╗\033[0m"
    echo -e "\033[1;34m  ║       🌌  A E T H E R       ║\033[0m"
    echo -e "\033[1;34m  ║   APPLE EDITION // V 1.0     ║\033[0m"
    echo -e "\033[1;34m  ╚══════════════════════════════╝\033[0m"
    echo ""

    local steps=("System Check" "Neural Engine" "Knowledge Vault" "Toolbox")
    for step in "${steps[@]}"; do
        echo -ne "  \033[1;34m[●]\033[0m $step..."
        sleep 0.2
        echo -e " \033[1;32mOK\033[0m"
    done
    sleep 0.5
    echo ""
}

# --- System info ---
get_system_info() {
    local mem_total=""
    local disk_avail=""
    local chip=""

    # macOS memory (in MB)
    mem_total=$(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1048576))

    # Disk available
    disk_avail=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')

    # Chip info
    if sysctl -n machdep.cpu.brand_string 2>/dev/null | grep -qi "apple"; then
        chip=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
    else
        chip=$(uname -m)
    fi

    echo "$chip | ${mem_total}MB RAM | Disk: $disk_avail"
}

# --- Launch AI ---
launch_ai() {
    local model_name="$1"
    local model_url="$2"
    local system_role="$3"
    local model_path="$DIR/models/$model_name"

    if [ ! -f "$model_path" ]; then
        clear 2>/dev/null || true
        echo -e "\033[1;31m[!] Model Missing: $model_name\033[0m"
        echo -e "Download URL: $model_url"
        echo -e "Size: ~2-5 GB"
        echo ""
        read -p "Download now? (y/n): " dl
        if [[ "$dl" == "y" || "$dl" == "Y" ]]; then
            mkdir -p "$DIR/models"
            curl -L -o "$model_path" "$model_url" || {
                echo -e "\033[1;31m[!] Download failed. Check your connection.\033[0m"
                read -p "Press Enter to return..."
                return
            }
            echo -e "\033[1;32m[+] Download complete.\033[0m"
            sleep 1
        else
            return
        fi
    fi

    # Load knowledge & skills
    local knowledge=""
    for f in "$DIR/knowledge"/*.txt; do
        [ -f "$f" ] && knowledge+="$(cat "$f" 2>/dev/null | tr '\n' ' ' | cut -c 1-1000) "
    done

    local skill_list=""
    for d in "$DIR"/skills/*/; do
        [ -d "$d" ] && skill_list+="$(basename "$d"), "
    done

    local context=$(get_context)

    local system_prompt="You are Aether-AI Apple Edition, a local-first AI interface running on macOS. $system_role. System: $(get_system_info). Skills: [$skill_list]. Knowledge: $knowledge. Previous Context: $context."

    clear 2>/dev/null || true
    echo -e "\033[1;34m  ┌─────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m  │  Connecting to Aether Neural Pathway... │\033[0m"
    echo -e "\033[1;34m  │  Model: $model_name\033[0m"
    echo -e "\033[1;34m  └─────────────────────────────────────────┘\033[0m"
    echo ""
    sleep 1

    "$BIN" -m "$model_path" -cnv -t "$THREADS" --mmap \
        --log-file "$SESSION_DIR/last_session.log" \
        -p "$system_prompt"
}

# --- Toolbox functions ---
tool_get_date() {
    echo "  $(date '+%A, %B %d, %Y — %I:%M %p')"
}

tool_get_battery() {
    if command -v pmset &>/dev/null; then
        local batt=$(pmset -g batt 2>/dev/null | grep -o '[0-9]*%' | head -1)
        local status=$(pmset -g batt 2>/dev/null | grep -oE '(charging|discharged|AC attached)' | head -1)
        echo "  🔋 Battery: ${batt:-unknown} (${status:-no status})"
    else
        echo "  🔋 Battery info unavailable"
    fi
}

tool_disk_usage() {
    local avail=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')
    local used=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
    echo "  💾 Disk: $avail available ($used used)"
}

tool_list_files() {
    local dir="${1:-.}"
    echo "  Files in $dir:"
    ls -la "$dir" 2>/dev/null | head -20 || echo "  Directory not found: $dir"
}

tool_web_search() {
    local query="$1"
    echo "  🔍 Search query: $query"
    echo "  (Open this URL in your browser: https://duckduckgo.com/?q=$(echo "$query" | sed 's/ /+/g'))"
}

tool_sys_info() {
    echo "  🖥️  macOS System Info"
    echo "  OS: $(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
    echo "  Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)"
    echo "  RAM: $(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824)) GB"
    echo "  Hostname: $(hostname)"
}

show_tools() {
    clear 2>/dev/null || true
    echo -e "\033[1;34m  ┌───────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m  │     🛠️  AETHER TOOLBOX (Apple)    │\033[0m"
    echo -e "\033[1;34m  └───────────────────────────────────┘\033[0m"
    echo ""
    echo "  1) 📅  Current Date/Time"
    echo "  2) 🔋  Battery Status"
    echo "  3) 💾  Disk Usage"
    echo "  4) 📁  List Files"
    echo "  5) 🔍  Web Search (DuckDuckGo)"
    echo "  6) 🖥️  System Info"
    echo "  7) 🧹  Purge Session Memory"
    echo "  8) 🔙  Back to Main Menu"
    echo ""
    read -p "  Select (1-8): " choice
    case "$choice" in
        1) tool_get_date ;;
        2) tool_get_battery ;;
        3) tool_disk_usage ;;
        4) read -p "  Directory [.]: " d; tool_list_files "${d:-.}" ;;
        5) read -p "  Search: " q; tool_web_search "$q" ;;
        6) tool_sys_info ;;
        7) rm -f "$SESSION_DIR/last_session.log"; echo "  🧹 Session memory purged." ;;
        8) return ;;
    esac
    echo ""
    read -p "  Press Enter to continue..."
}

# --- Main loop ---
check_deps
mkdir -p "$SESSION_DIR"
boot_sequence

while true; do
    clear 2>/dev/null || true

    sys_info=$(get_system_info)

    echo -e "\033[1;34m"
    echo "   ╔══════════════════════════════════════════╗"
    echo "   ║          🌌  A E T H E R  🌌            ║"
    echo "   ║    APPLE EDITION // V 1.0               ║"
    echo "   ╚══════════════════════════════════════════╝"
    echo -e "\033[0m"
    echo -e "   \033[1;30m$sys_info\033[0m"
    echo ""
    echo "   ┌────────────────────────────────────────────┐"
    echo "   │  [ SELECT NEURAL PATHWAY ]                 │"
    echo "   │                                            │"
    echo "   │  1) 🤖  CHAT  (Default Model)              │"
    echo "   │  2) ⚡  TURBO (Smaller/Faster Model)       │"
    echo "   │  3) 🛠️  TOOLS (System Toolbox)            │"
    echo "   │  4) 📖  KNOWLEDGE (View Context7 Vault)   │"
    echo "   │  5) ❌  EXIT                               │"
    echo "   └────────────────────────────────────────────┘"
    echo ""
    read -p "  Select (1-5): " choice

    case "$choice" in
        1) launch_ai "llama-3.2-3b.gguf" \
            "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf" \
            "Helpful AI assistant running locally on Apple hardware."
            ;;
        2) launch_ai "qwen-coder-3b.gguf" \
            "https://huggingface.co/bartowski/Qwen2.5-Coder-3B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-3B-Instruct-Q4_K_M.gguf" \
            "Fast coding specialist. Be concise."
            ;;
        3) show_tools ;;
        4)
            echo ""
            echo "  📂 Context7 Vault Contents:"
            echo "  ─────────────────────────────"
            if [ -d "$DIR/knowledge/context7" ] && [ "$(ls -A "$DIR/knowledge/context7" 2>/dev/null)" ]; then
                ls -la "$DIR/knowledge/context7/"
            else
                echo "  Vault is empty. The AI can learn new things during chat."
                echo "  Use the 'learn' concept or manually add .md files here."
            fi
            echo ""
            read -p "  Press Enter to return..."
            ;;
        5) echo -e "\n  🌌 Aether signing off. Think locally.\n"; exit 0 ;;
        *) echo "  Invalid selection." ; sleep 1 ;;
    esac
done
