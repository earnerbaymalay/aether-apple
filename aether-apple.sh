#!/usr/bin/env bash
# 🌌 Aether-AI Neural Interface // Apple Edition V 2.0
# Platform-adaptive: macOS (full), iPad iSH (medium), iPad a-Shell (lite)

# --- Configuration ---
ACCENT="#81a1c1"; DIM="#4c566a"; RED="#ff5555"; SUC="#50fa7b"
DIR="$HOME/aether-apple"
SESSION_DIR="$HOME/.aether/sessions"
PLATFORM=""

# --- Platform Detection ---
detect_platform() {
    local os_name=$(uname -s 2>/dev/null || echo "unknown")
    if [ -f "/etc/alpine-release" ] && [ "$os_name" = "Linux" ]; then
        PLATFORM="ish"
    elif [ "$os_name" = "Darwin" ] && command -v brew &>/dev/null; then
        PLATFORM="macos"
    elif [ "$os_name" = "Darwin" ] && [ ! -w "/usr/local" ]; then
        PLATFORM="ashell"
    else
        PLATFORM="lite"
    fi
}

# --- Find llama-cli ---
find_llama_bin() {
    local candidates=(
        "$(command -v llama-cli 2>/dev/null)"
        "/opt/homebrew/bin/llama-cli"
        "/usr/local/bin/llama-cli"
        "/usr/local/llama.cpp/build/bin/llama-cli"
        "/tmp/llama.cpp/build/bin/llama-cli"
    )
    for c in "${candidates[@]}"; do
        [ -x "$c" ] && echo "$c" && return 0
    done
    echo ""
    return 1
}

BIN=$(find_llama_bin)
THREADS=4
case "$PLATFORM" in
    macos) THREADS=$(sysctl -n hw.ncpu 2>/dev/null || echo 6) ;;
    ish)   THREADS=2 ;;  # iSH is single-core emulated
    *)     THREADS=2 ;;
esac

# --- Dependencies check ---
check_deps() {
    if [ -z "$BIN" ]; then
        case "$PLATFORM" in
            macos)
                echo -e "\033[1;31m[!] llama-cli not found.\033[0m"
                echo -e "Run: brew install llama.cpp"
                ;;
            ish)
                echo -e "\033[1;31m[!] llama-cli not found on iSH.\033[0m"
                echo -e "Re-run ./install-apple.sh to build from source."
                ;;
            ashell|lite)
                echo -e "\033[1;33m[!] llama-cli not available on this platform.\033[0m"
                echo -e "Aether will use Python-based inference (slower)."
                echo -e "For best performance, install iSH from the App Store."
                ;;
        esac
        return 1
    fi
    return 0
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
    echo ""

    case "$PLATFORM" in
        macos)  echo -e "  \033[1;34m  ╔══════════════════════════════════════╗\033[0m"
                echo -e "  \033[1;34m  ║       🌌  A E T H E R  🌌          ║\033[0m"
                echo -e "  \033[1;34m  ║   APPLE EDITION // V 2.0 // FULL     ║\033[0m"
                echo -e "  \033[1;34m  ╚══════════════════════════════════════╝\033[0m" ;;
        ish)    echo -e "  \033[1;34m  ╔══════════════════════════════════════╗\033[0m"
                echo -e "  \033[1;34m  ║       🌌  A E T H E R  🌌          ║\033[0m"
                echo -e "  \033[1;34m  ║   APPLE EDITION // V 2.0 // iSH      ║\033[0m"
                echo -e "  \033[1;34m  ╚══════════════════════════════════════╝\033[0m" ;;
        ashell) echo -e "  \033[1;34m  ╔══════════════════════════════════════╗\033[0m"
                echo -e "  \033[1;34m  ║       🌌  A E T H E R  🌌          ║\033[0m"
                echo -e "  \033[1;34m  ║   APPLE EDITION // V 2.0 // LITE     ║\033[0m"
                echo -e "  \033[1;34m  ╚══════════════════════════════════════╝\033[0m" ;;
        *)      echo -e "  \033[1;34m  ╔══════════════════════════════════════╗\033[0m"
                echo -e "  \033[1;34m  ║       🌌  A E T H E R  🌌          ║\033[0m"
                echo -e "  \033[1;34m  ║   APPLE EDITION // V 2.0 // LITE     ║\033[0m"
                echo -e "  \033[1;34m  ╚══════════════════════════════════════╝\033[0m" ;;
    esac
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

# --- System info (platform-aware) ---
get_system_info() {
    local info=""
    case "$PLATFORM" in
        macos)
            local mem_mb=$(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1048576))
            local disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')
            local chip=$(sysctl -n machdep.cpu.brand_string 2>/dev/null | sed 's/^ *//' || uname -m)
            info="$chip | ${mem_mb}MB RAM | Disk: $disk"
            ;;
        ish)
            local mem=$(free -m 2>/dev/null | awk '/Mem:/ {print $2"MB"}' || echo "unknown")
            local disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}')
            info="iSH x86 Emulator | RAM: $mem | Disk: $disk"
            ;;
        ashell|lite)
            local disk=$(df -h / 2>/dev/null | awk 'NR==2 {print $4}' || echo "unknown")
            info="Apple iPad | Disk: $disk"
            ;;
    esac
    echo "$info"
}

# --- Launch AI (llama-cli path) ---
launch_ai_llama() {
    local model_name="$1"
    local model_url="$2"
    local system_role="$3"
    local model_path="$DIR/models/$model_name"

    if [ ! -f "$model_path" ]; then
        clear 2>/dev/null || true
        echo -e "\033[1;31m[!] Model Missing: $model_name\033[0m"
        echo -e "Size: ~2-5 GB | Download may take several minutes."
        echo ""
        read -p "Download now? (y/n): " dl
        if [[ "$dl" == "y" || "$dl" == "Y" ]]; then
            mkdir -p "$DIR/models"
            if command -v curl &>/dev/null; then
                curl -L -o "$model_path" "$model_url" || { fail "Download failed"; read -p "Enter..."; return; }
            elif command -v wget &>/dev/null; then
                wget -O "$model_path" "$model_url" || { fail "Download failed"; read -p "Enter..."; return; }
            else
                fail "No download tool available"
                read -p "Enter..."
                return
            fi
            ok "Download complete."
            sleep 1
        else
            return
        fi
    fi

    local knowledge=""
    for f in "$DIR/knowledge"/*.txt; do
        [ -f "$f" ] && knowledge+="$(cat "$f" 2>/dev/null | tr '\n' ' ' | cut -c 1-500) "
    done

    local context=$(get_context)
    local sys_info=$(get_system_info)
    local system_prompt="You are Aether-AI Apple Edition, running locally on Apple hardware ($PLATFORM mode). $system_role. System: $sys_info. Knowledge: $knowledge. Previous Context: $context."

    clear 2>/dev/null || true
    echo -e "\033[1;34m  ┌───────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m  │  Aether Neural Pathway — $model_name\033[0m"
    echo -e "\033[1;34m  │  Platform: $PLATFORM | Threads: $THREADS\033[0m"
    echo -e "\033[1;34m  └───────────────────────────────────────────┘\033[0m"
    sleep 1

    "$BIN" -m "$model_path" -cnv -t "$THREADS" --mmap \
        --log-file "$SESSION_DIR/last_session.log" \
        -p "$system_prompt"
}

# --- Launch AI (Python fallback for iPad lite mode) ---
launch_ai_python() {
    local model_name="$1"
    local model_url="$2"
    local system_role="$3"
    local model_path="$DIR/models/$model_name"

    if [ ! -f "$model_path" ]; then
        clear 2>/dev/null || true
        echo -e "\033[1;31m[!] Model Missing: $model_name\033[0m"
        echo -e "On a-Shell / lite mode, you must manually place models here:"
        echo -e "  $DIR/models/$model_name"
        echo ""
        read -p "Press Enter to return..."
        return
    fi

    if ! command -v python3 &>/dev/null; then
        fail "python3 not found — cannot run AI inference"
        read -p "Press Enter to return..."
        return
    fi

    clear 2>/dev/null || true
    echo -e "\033[1;34m  ┌───────────────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m  │  Aether Neural Pathway (Python mode)      │\033[0m"
    echo -e "\033[1;34m  │  Platform: $PLATFORM | Model: $model_name\033[0m"
    echo -e "\033[1;34m  │  ⚠️  Python inference — slower than llama  │\033[0m"
    echo -e "\033[1;34m  └───────────────────────────────────────────┘\033[0m"
    echo ""

    # Simple Python chat using llama-cpp-python if available, else basic
    python3 << PYEOF
import sys, os

model_path = "$model_path"
platform = "$PLATFORM"

# Try llama-cpp-python first (faster)
try:
    from llama_cpp import Llama
    llm = Llama(model_path=model_path, n_ctx=2048, n_threads=2, verbose=False)
    print("Engine: llama-cpp-python (optimized)")
    print("Type 'exit' to return\n")
    while True:
        try:
            user = input("You: ").strip()
            if not user or user.lower() in ['exit', 'quit']: break
            out = llm(f"User: {user}\\nAI:", max_tokens=512, stop=["User:", "\\n\\n"], echo=False)
            print(f"AI: {out['choices'][0]['text'].strip()}")
        except KeyboardInterrupt: break
        except Exception as e: print(f"Error: {e}")
    sys.exit(0)
except ImportError:
    print("llama-cpp-python not installed")
    print("Install: pip3 install llama-cpp-python")
    print("Falling back to basic mode...")
    print()
    print("AI: I can run locally but need llama-cpp-python for inference.")
    print("    Until then, I'm a basic echo bot.")
    print()
    while True:
        try:
            user = input("You: ").strip()
            if not user or user.lower() in ['exit', 'quit']: break
            print(f"AI: You said: '{user}' — Install llama-cpp-python for real AI!")
        except KeyboardInterrupt: break
PYEOF
}

# --- Toolbox functions ---
tool_get_date() {
    date '+%A, %B %d, %Y — %I:%M %p %Z' 2>/dev/null || echo "Date unavailable"
}

tool_get_battery() {
    case "$PLATFORM" in
        macos)
            if command -v pmset &>/dev/null; then
                pmset -g batt 2>/dev/null | grep -E '(Internal|Now|charging|discharged)' || echo "Battery info unavailable"
            else
                echo "Battery info unavailable"
            fi
            ;;
        ish)
            # iSH can't access iPad hardware
            echo "🔋 Battery: Not accessible in iSH (sandboxed)"
            echo "   Check iPad's Control Center instead"
            ;;
        ashell|lite)
            echo "🔋 Battery: Not accessible in a-Shell (sandboxed)"
            echo "   Check iPad's Control Center instead"
            ;;
    esac
}

tool_disk_usage() {
    df -h / 2>/dev/null | awk 'NR==2 {print "💾 Disk: "$4" available ("$5" used)"}' || echo "💾 Disk: unavailable"
}

tool_list_files() {
    local dir="${1:-.}"
    echo "  Files in $dir:"
    ls -la "$dir" 2>/dev/null | head -20 || echo "  Directory not found: $dir"
}

tool_web_search() {
    local query="$1"
    echo "  🔍 Search: $query"
    echo "  URL: https://duckduckgo.com/?q=${query// /+}"
}

tool_sys_info() {
    echo "  🖥️  System Information ($PLATFORM mode)"
    case "$PLATFORM" in
        macos)
            echo "  OS: $(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null)"
            echo "  Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)"
            echo "  RAM: $(($(sysctl -n hw.memsize 2>/dev/null || echo 0) / 1073741824)) GB"
            ;;
        ish)
            echo "  Platform: iSH (Alpine Linux on iPad)"
            echo "  Alpine: $(cat /etc/alpine-release 2>/dev/null || 'unknown')"
            echo "  Kernel: $(uname -r 2>/dev/null)"
            echo "  CPU: x86 (emulated)"
            ;;
        ashell|lite)
            echo "  Platform: Apple iPad (a-Shell / lite)"
            echo "  Kernel: $(uname -r 2>/dev/null || 'unknown')"
            echo "  Arch: $(uname -m 2>/dev/null)"
            ;;
    esac
    echo "  Hostname: $(hostname 2>/dev/null || echo 'unknown')"
}

tool_memory() {
    echo "  🧠 AetherVault Knowledge Vault"
    if [ -d "$DIR/knowledge/aethervault" ]; then
        local count=$(find "$DIR/knowledge/aethervault" -name "*.md" 2>/dev/null | wc -l)
        echo "  Notes: $count"
        if [ "$count" -gt 0 ]; then
            echo "  Files:"
            find "$DIR/knowledge/aethervault" -name "*.md" 2>/dev/null | head -10 | while read f; do
                echo "    📄 $(basename "$f")"
            done
        fi
    else
        echo "  Vault directory not found"
    fi
}

show_tools() {
    clear 2>/dev/null || true
    echo -e "\033[1;34m  ┌───────────────────────────────────────┐\033[0m"
    echo -e "\033[1;34m  │     🛠️  AETHER TOOLBOX ($PLATFORM)\033[0m"
    [ "$PLATFORM" = "macos" ] && echo -e "\033[1;34m  │         FULL — All tools available          \033[0m"
    [ "$PLATFORM" = "ish" ] && echo -e "\033[1;34m  │     MEDIUM — Some hardware limited        \033[0m"
    [ "$PLATFORM" = "ashell" ] && echo -e "\033[1;34m  │     LITE — Basic tools only               \033[0m"
    [ "$PLATFORM" = "lite" ] && echo -e "\033[1;34m  │     LITE — Basic tools only               \033[0m"
    echo -e "\033[1;34m  └───────────────────────────────────────┘\033[0m"
    echo ""
    echo "  1) 📅  Current Date/Time"
    echo "  2) 🔋  Battery Status"
    echo "  3) 💾  Disk Usage"
    echo "  4) 📁  List Files"
    echo "  5) 🔍  Web Search (DuckDuckGo)"
    echo "  6) 🖥️  System Info"
    echo "  7) 🧠  Knowledge Vault"
    echo "  8) 🧹  Purge Session Memory"
    echo "  9) 🔙  Back to Main Menu"
    echo ""
    read -p "  Select (1-9): " choice
    case "$choice" in
        1) tool_get_date ;;
        2) tool_get_battery ;;
        3) tool_disk_usage ;;
        4) read -p "  Directory [.]: " d; tool_list_files "${d:-.}" ;;
        5) read -p "  Search: " q; tool_web_search "$q" ;;
        6) tool_sys_info ;;
        7) tool_memory ;;
        8) rm -f "$SESSION_DIR/last_session.log"; echo "  🧹 Session memory purged." ;;
        9) return ;;
    esac
    echo ""
    read -p "  Press Enter to continue..."
}

# --- Main ---
detect_platform
mkdir -p "$SESSION_DIR"
boot_sequence

has_llama=false
check_deps && has_llama=true

while true; do
    clear 2>/dev/null || true

    sys_info=$(get_system_info)

    echo -e "\033[1;34m   ╔══════════════════════════════════════════╗\033[0m"
    echo -e "\033[1;34m   ║          🌌  A E T H E R  🌌            ║\033[0m"
    echo -e "\033[1;34m   ║  APPLE EDITION // V 2.0 // $PLATFORM\033[0m"
    echo -e "\033[1;34m   ╚══════════════════════════════════════════╝\033[0m"
    echo -e "   \033[1;30m$sys_info\033[0m"
    echo ""
    echo "   ┌────────────────────────────────────────────┐"
    echo "   │  [ SELECT NEURAL PATHWAY ]                 │"
    echo "   │                                            │"

    if $has_llama; then
        echo "   │  1) 🤖  CHAT  (Default Model)              │"
        echo "   │  2) ⚡  TURBO (Smaller/Faster Model)       │"
    else
        echo "   │  1) 🤖  CHAT  (Python Mode)               │"
        echo "   │  2) ⚡  TURBO (Python — Coder Model)      │"
    fi
    echo "   │  3) 🛠️  TOOLS (System Toolbox)            │"
    echo "   │  4) 📖  KNOWLEDGE (View AetherVault Vault)   │"
    echo "   │  5) ℹ️  PLATFORM INFO                    │"
    echo "   │  6) ❌  EXIT                               │"
    echo "   └────────────────────────────────────────────┘"
    echo ""
    read -p "  Select (1-6): " choice

    case "$choice" in
        1)
            if $has_llama; then
                launch_ai_llama "llama-3.2-3b.gguf" \
                    "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf" \
                    "Helpful AI assistant running locally on Apple hardware."
            else
                launch_ai_python "llama-3.2-3b.gguf" \
                    "https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf" \
                    "Helpful AI assistant."
            fi
            ;;
        2)
            if $has_llama; then
                launch_ai_llama "qwen-coder-3b.gguf" \
                    "https://huggingface.co/bartowski/Qwen2.5-Coder-3B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-3B-Instruct-Q4_K_M.gguf" \
                    "Fast coding specialist. Be concise."
            else
                launch_ai_python "qwen-coder-3b.gguf" \
                    "https://huggingface.co/bartowski/Qwen2.5-Coder-3B-Instruct-GGUF/resolve/main/Qwen2.5-Coder-3B-Instruct-Q4_K_M.gguf" \
                    "Coding assistant (Python mode)."
            fi
            ;;
        3) show_tools ;;
        4)
            echo ""
            echo "  📂 AetherVault Vault Contents:"
            echo "  ─────────────────────────────"
            if [ -d "$DIR/knowledge/aethervault" ] && [ "$(ls -A "$DIR/knowledge/aethervault" 2>/dev/null)" ]; then
                find "$DIR/knowledge/aethervault" -name "*.md" | while read f; do
                    echo "  📄 $(basename "$f")"
                done
            else
                echo "  Vault is empty. The AI learns during chat."
                echo "  Manually add .md files to knowledge/aethervault/"
            fi
            echo ""
            read -p "  Press Enter to return..."
            ;;
        5)
            echo ""
            echo "  Platform Detection Report"
            echo "  ─────────────────────────"
            echo "  Detected: $PLATFORM"
            echo ""
            case "$PLATFORM" in
                macos)
                    echo "  ✅ Full mode — llama.cpp via Homebrew"
                    echo "  ✅ All tools available (pmset, sysctl)"
                    echo "  ✅ Multi-threaded inference"
                    echo "  ✅ Best performance on Apple Silicon"
                    ;;
                ish)
                    echo "  ⚠️  Medium mode — iSH emulator on iPad"
                    echo "  ⚠️  llama.cpp built from source (slow build)"
                    echo "  ⚠️  Single-threaded (x86 emulation)"
                    echo "  ⚠️  Battery/hardware info unavailable"
                    echo "  💡 Tip: Increase iSH memory in Settings → 1024MB+"
                    echo "  💡 Tip: For better speed, try a-Shell + llama-cpp-python"
                    ;;
                ashell)
                    echo "  🔶 Lite mode — a-Shell sandboxed terminal"
                    echo "  🔶 No llama.cpp (no C compilation in a-Shell)"
                    echo "  🔶 Python-based inference (if llama-cpp-python installed)"
                    echo "  🔶 Basic toolbox only"
                    echo "  💡 Tip: pip3 install llama-cpp-python for real AI"
                    echo "  💡 Tip: For full AI, use iSH from App Store instead"
                    ;;
                lite)
                    echo "  🔶 Lite mode — minimal platform"
                    echo "  🔶 No llama.cpp detected"
                    echo "  🔶 Python-based inference if available"
                    echo "  💡 Tip: Install llama.cpp or use iSH"
                    ;;
            esac
            echo ""
            echo "  Free. Offline. Private. Works on any Apple device."
            read -p "  Press Enter to return..."
            ;;
        6) echo -e "\n  🌌 Aether signing off. Think locally.\n"; exit 0 ;;
        *) echo "  Invalid selection." ; sleep 1 ;;
    esac
done
