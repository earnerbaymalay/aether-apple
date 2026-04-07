#!/usr/bin/env bash
# 🌌 Aether-AI Apple Edition Installer // V 2.0
# Supports: macOS (full), iPad via iSH (medium), iPad via a-Shell (lite)

set -e

# --- Configuration ---
ACCENT="#81a1c1"; SUC="#50fa7b"; ERR="#ff5555"; WARN="#f1fa8c"
DIR="$HOME/aether-apple"
PLATFORM=""

# --- UI Helpers ---
box() {
    local msg="$1" color="${2:-$ACCENT}"
    local width=${#msg}
    width=$((width + 4))
    local border=""
    for i in $(seq 1 $width); do border+="═"; done
    echo -e "\033[1;${color:1}m  ╔${border}╗\033[0m"
    echo -e "\033[1;${color:1}m  ║  $msg  ║\033[0m"
    echo -e "\033[1;${color:1}m  ╚${border}╝\033[0m"
}

info() { echo -e "\033[1;34m[*]\033[0m $1"; }
ok()   { echo -e "\033[1;32m[+]\033[0m $1"; }
fail() { echo -e "\033[1;31m[!]\033[0m $1"; }
warn() { echo -e "\033[1;33m[!]\033[0m $1"; }

header() {
    clear 2>/dev/null || true
    echo ""
    box "🌌  A E T H E R  —  APPLE  EDITION" "$ACCENT"
    echo -e "   Neural Interface for Mac & iPad"
    echo ""
}

# --- Platform Detection ---
detect_platform() {
    local os_name=$(uname -s 2>/dev/null || echo "unknown")
    local os_release=$(uname -r 2>/dev/null || echo "")

    # iSH detection: runs Alpine Linux on iPad, kernel shows "linux" but iSH-specific
    if [ -f "/etc/alpine-release" ] && [ "$os_name" = "Linux" ]; then
        PLATFORM="ish"
        local alpine_ver=$(cat /etc/alpine-release 2>/dev/null || "unknown")
        ok "Detected iPad — iSH (Alpine Linux $alpine_ver)"
        warn "iSH runs in an emulated x86 environment — AI will be slower but functional"
        return 0
    fi

    # a-Shell detection: sandboxed iPad terminal
    if [ -d "$HOME/Documents" ] && [ "$os_name" = "Darwin" ] && ! command -v brew &>/dev/null && [ ! -d "/opt/homebrew" ] && [ ! -d "/usr/local/Homebrew" ]; then
        # More checks for a-Shell
        if [ -f "$HOME/.is_a-shell" ] || [ ! -w "/usr/bin" ] || [ ! -w "/etc" ]; then
            PLATFORM="ashell"
            ok "Detected iPad — a-Shell (sandboxed terminal)"
            warn "a-Shell has limited package support — using lite mode"
            return 0
        fi
    fi

    # Generic Darwin without Homebrew — could be a-Shell or bare iPad
    if [ "$os_name" = "Darwin" ] && ! command -v brew &>/dev/null; then
        # Check if we can write to system dirs (iPad can't)
        if [ ! -w "/usr/local" ] && [ ! -w "/opt" ]; then
            PLATFORM="ish"
            warn "macOS without Homebrew — falling back to iSH-style setup"
            warn "Recommend: install Homebrew or use iSH from App Store"
            info "Continuing with lite mode..."
            PLATFORM="lite"
            return 0
        fi
    fi

    # macOS with Homebrew
    if [ "$os_name" = "Darwin" ] && command -v brew &>/dev/null; then
        PLATFORM="macos"
        local mac_ver=$(sw_vers -productVersion 2>/dev/null || echo "unknown")
        local chip=$(sysctl -n machdep.cpu.brand_string 2>/dev/null || uname -m)
        ok "Detected macOS $mac_ver — $chip"
        return 0
    fi

    # Fallback
    PLATFORM="lite"
    warn "Unknown platform: $os_name — using lite mode"
    warn "Some features may not be available"
    return 0
}

check_prereqs() {
    header
    info "Checking prerequisites for $PLATFORM mode..."

    case "$PLATFORM" in
        macos)
            if ! command -v brew &>/dev/null; then
                fail "Homebrew not found."
                info "Install: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                exit 1
            fi
            ok "Homebrew: $(brew --version | head -1)"
            ;;
        ish)
            if ! command -v apk &>/dev/null; then
                fail "apk package manager not found"
                exit 1
            fi
            ok "apk package manager available"
            if command -v wget &>/dev/null || command -v curl &>/dev/null; then
                ok "Download tool found"
            else
                info "Installing wget for model downloads..."
                apk add wget 2>/dev/null || true
            fi
            ;;
        ashell)
            warn "a-Shell detected — using built-in Python and limited tools"
            warn "Model download requires manual placement in ~/aether-apple/models/"
            if command -v python3 &>/dev/null; then
                ok "Python3 available"
            else
                fail "python3 not found in a-Shell"
                exit 1
            fi
            ;;
        lite)
            warn "Running in lite mode — minimal dependencies assumed"
            ;;
    esac
}

install_deps() {
    header

    case "$PLATFORM" in
        macos)
            box "📦  INSTALLING DEPENDENCIES (macOS)" "$ACCENT"
            info "Installing llama.cpp and coreutils via Homebrew..."
            brew install llama.cpp coreutils 2>/dev/null || {
                warn "llama.cpp may already be installed or partially installed"
                info "Continuing — checking for binary..."
            }
            ;;
        ish)
            box "📦  INSTALLING DEPENDENCIES (iSH)" "$ACCENT"
            info "iSH uses Alpine's apk. Installing build tools..."
            apk update 2>/dev/null || true
            apk add build-base cmake git wget ncurses-dev 2>/dev/null || {
                warn "Some packages failed — trying essentials..."
                apk add build-base git wget 2>/dev/null || true
            }

            # Try to build llama.cpp from source on iSH
            if ! command -v llama-cli &>/dev/null; then
                info "Building llama.cpp from source for iSH..."
                info "This will take 10-20 minutes on iSH. Grab a coffee."
                cd /tmp
                [ -d "llama.cpp" ] && rm -rf llama.cpp
                git clone https://github.com/ggerganov/llama.cpp --depth 1 2>/dev/null || {
                    fail "git clone failed. Try downloading manually."
                    cd "$DIR"
                    return 1
                }
                cd llama.cpp
                mkdir -p build && cd build
                cmake .. -DGGML_OPENMP=OFF 2>/dev/null || {
                    fail "cmake failed. iSH may not have enough resources."
                    cd "$DIR"
                    return 1
                }
                make llama-cli -j1 2>/dev/null || {
                    fail "Build failed. You may need more RAM allocated to iSH."
                    info "Try: Settings > iSH > increase memory to 1024MB+"
                    cd "$DIR"
                    return 1
                }
                # Copy to a standard location
                cp llama-cli /usr/local/bin/ 2>/dev/null || true
                ok "llama.cpp built and installed for iSH"
                cd "$DIR"
            else
                ok "llama-cli already available"
            fi
            ;;
        ashell|lite)
            box "📦  SETUP (Lite Mode)" "$ACCENT"
            info "No system packages to install."
            info "Aether will use Python-based inference as fallback."
            info "For better performance, consider iSH from the App Store."
            ;;
    esac
}

find_llama_bin() {
    if command -v llama-cli &>/dev/null; then
        echo "$(command -v llama-cli)"
        return 0
    elif [ -f "/opt/homebrew/bin/llama-cli" ]; then
        echo "/opt/homebrew/bin/llama-cli"
        return 0
    elif [ -f "/usr/local/bin/llama-cli" ]; then
        echo "/usr/local/bin/llama-cli"
        return 0
    elif [ -f "/usr/local/llama.cpp/build/bin/llama-cli" ]; then
        echo "/usr/local/llama.cpp/build/bin/llama-cli"
        return 0
    elif [ -f "/tmp/llama.cpp/build/bin/llama-cli" ]; then
        echo "/tmp/llama.cpp/build/bin/llama-cli"
        return 0
    else
        echo ""
        return 1
    fi
}

create_structure() {
    header
    box "🏗️  CREATING WORKSPACE" "$ACCENT"
    info "Setting up Aether directory structure..."
    mkdir -p "$DIR/models"
    mkdir -p "$DIR/knowledge/context7"
    mkdir -p "$DIR/toolbox"
    mkdir -p "$DIR/scripts"
    mkdir -p "$DIR/skills"
    mkdir -p "$HOME/.aether/sessions"
    ok "Workspace created at $DIR"
}

download_model() {
    header
    local model_url="https://huggingface.co/bartowski/Llama-3.2-3B-Instruct-GGUF/resolve/main/Llama-3.2-3B-Instruct-Q4_K_M.gguf"
    local model_name="llama-3.2-3b.gguf"
    local model_path="$DIR/models/$model_name"

    if [ -f "$model_path" ] && [ "$(stat -f%z "$model_path" 2>/dev/null || stat -c%s "$model_path" 2>/dev/null || echo 0)" -gt 1000000 ]; then
        ok "Model already exists: $model_path"
        return 0
    fi

    box "📥  DOWNLOADING STARTER MODEL" "$ACCENT"
    info "Model: Llama-3.2-3B (~2 GB)"
    info "This will take several minutes depending on your connection."

    case "$PLATFORM" in
        macos)
            if command -v curl &>/dev/null; then
                curl -L --progress-bar -o "$model_path" "$model_url" || {
                    fail "Download failed"
                    info "Manual: curl -L -o $model_path $model_url"
                    return 1
                }
            fi
            ;;
        ish)
            if command -v wget &>/dev/null; then
                wget -O "$model_path" "$model_url" || {
                    fail "Download failed"
                    return 1
                }
            elif command -v curl &>/dev/null; then
                curl -L -o "$model_path" "$model_url" || {
                    fail "Download failed"
                    return 1
                }
            fi
            ;;
        ashell|lite)
            warn "Automatic download not supported on this platform."
            info "To get the model:"
            info "1. Download from: $model_url"
            info "2. Place it in:   $model_path"
            info "3. Or use Files app to copy it there"
            return 1
            ;;
    esac

    if [ -f "$model_path" ]; then
        local size=$(du -h "$model_path" 2>/dev/null | cut -f1 || echo "unknown")
        ok "Model downloaded: $size"
    fi
}

create_launcher() {
    header
    box "⌨️  CREATING LAUNCHER" "$ACCENT"

    case "$PLATFORM" in
        macos)
            local shell_rc="$HOME/.zshrc"
            [ -f "$HOME/.bash_profile" ] && shell_rc="$HOME/.bash_profile"

            # Remove old alias if exists
            if [ -f "$shell_rc" ]; then
                sed -i '' '/# aether-apple alias/d' "$shell_rc" 2>/dev/null || true
            fi
            # Remove any existing ai alias to prevent duplicates
            if [ -f "$shell_rc" ]; then
                local tmp_rc=$(mktemp)
                grep -v "^alias ai=" "$shell_rc" > "$tmp_rc" 2>/dev/null || cp "$shell_rc" "$tmp_rc"
                cp "$tmp_rc" "$shell_rc"
                rm -f "$tmp_rc"
            fi

            echo "# aether-apple alias" >> "$shell_rc"
            echo "alias ai='cd $DIR && bash ./aether-apple.sh'" >> "$shell_rc"
            ok "Alias 'ai' added to $shell_rc"
            info "Run 'source $shell_rc' or open a new terminal, then type: ai"
            ;;
        ish)
            # iSH doesn't have a persistent alias system the same way
            local profile="$HOME/.profile"
            if [ -f "$profile" ]; then
                grep -q "alias ai=" "$profile" 2>/dev/null || {
                    echo "alias ai='cd $DIR && bash ./aether-apple.sh'" >> "$profile"
                    ok "Alias 'ai' added to $profile"
                }
            fi
            # Create a helper script
            cat > "$HOME/ai" << 'AI_SCRIPT'
#!/bin/sh
cd ~/aether-apple && bash ./aether-apple.sh
AI_SCRIPT
            chmod +x "$HOME/ai" 2>/dev/null || true
            ok "Launcher created at ~/ai — run it directly or add to PATH"
            ;;
        ashell|lite)
            # a-Shell doesn't support persistent aliases well
            info "a-Shell doesn't support persistent aliases."
            info "Create a shortcut: launch Aether with:"
            info "  cd ~/Documents/aether-apple && bash ./aether-apple.sh"
            ok "You can also use the a-Shell 'launch' feature to create a shortcut"
            ;;
    esac
}

# --- Main ---
header
echo -e "   Welcome to the Aether Apple Edition Installer"
echo ""
echo -e "   This sets up local, private, offline AI on your Apple device."
echo -e "   Works on: Mac, iPad (iSH), iPad (a-Shell)"
echo ""

read -p "   Continue? (y/n): " confirm
case "$confirm" in
    [yY]*) ;;
    *) echo "   Aborted."; exit 0 ;;
esac

detect_platform
check_prereqs
create_structure
install_deps || true
find_llama_bin && ok "llama-cli found at: $(find_llama_bin)" || {
    case "$PLATFORM" in
        macos) fail "llama-cli not found. Run: brew install llama.cpp" ;;
        ish)   fail "llama.cpp build failed. Check error messages above." ;;
        *)     warn "No llama-cli — will use Python fallback if available" ;;
    esac
}
download_model || true
create_launcher

header
box "🎉  INSTALLATION COMPLETE" "$SUC"
echo ""
echo -e "   Launch Aether:  \033[1;32mai\033[0m"
[ "$PLATFORM" = "ish" ] && echo -e "   Or directly:  \033[1;34m~/ai\033[0m"
[ "$PLATFORM" = "ashell" ] && echo -e "   Or directly:  \033[1;34mcd ~/Documents/aether-apple && bash aether-apple.sh\033[0m"
echo ""
echo -e "   \033[1;30mPlatform: $PLATFORM | Free | Offline | Private\033[0m"
echo ""
box "🌌  Develop natively. Think locally. Evolve autonomously." "$ACCENT"
echo ""
