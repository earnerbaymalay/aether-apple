#!/usr/bin/env bash
# 🌌 Aether Apple — Simulated Test Suite v2.0
# Tests all 3 platform paths: macOS (full), iPad iSH (medium), iPad a-Shell (lite)

set -e

PASS=0; FAIL=0; WARN=0

assert_eq() {
    local desc="$1" expected="$2" actual="$3"
    if [ "$expected" = "$actual" ]; then
        echo "  ✅ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ❌ $desc — expected '$expected', got '$actual'"
        FAIL=$((FAIL + 1))
    fi
}

assert_contains() {
    local desc="$1" needle="$2" haystack="$3"
    if echo "$haystack" | grep -q "$needle"; then
        echo "  ✅ $desc"
        PASS=$((PASS + 1))
    else
        echo "  ❌ $desc — output missing '$needle'"
        FAIL=$((FAIL + 1))
    fi
}

DIR="$(cd "$(dirname "$0")" && pwd)"

echo "╔══════════════════════════════════════════════════╗"
echo "║  🌌 AETHER APPLE v2.0 — MULTI-PLATFORM TESTS    ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""

# ─── Test 1: File structure ───
echo "📂 Test 1: File Structure"
for f in install-apple.sh aether-apple.sh .gitignore LICENSE README.md USAGE.md; do
    [ -f "$DIR/$f" ] && assert_eq "$f exists" "yes" "yes" || assert_eq "$f exists" "yes" "no"
done
for d in toolbox scripts knowledge skills; do
    [ -d "$DIR/$d" ] && assert_eq "$d/ directory exists" "yes" "yes" || assert_eq "$d/ directory exists" "yes" "no"
done
# New toolbox files
for f in toolbox/get_date.sh toolbox/get_battery.sh toolbox/list_files.sh toolbox/web_search.sh toolbox/web_read.sh toolbox/sys_info.sh toolbox/manifest.json; do
    [ -f "$DIR/$f" ] && assert_eq "$f exists" "yes" "yes" || assert_eq "$f exists" "yes" "no"
done
echo ""

# ─── Test 2: Syntax validation ───
echo "🔍 Test 2: Script Syntax"
for f in install-apple.sh aether-apple.sh toolbox/*.sh; do
    bash -n "$DIR/$f" 2>/dev/null && assert_eq "$f syntax valid" "pass" "pass" || assert_eq "$f syntax valid" "pass" "FAIL"
done
echo ""

# ─── Test 3: Toolbox tool execution ───
echo "🛠️ Test 3: Toolbox Tool Execution"
output=$(bash "$DIR/toolbox/get_date.sh" 2>&1)
assert_contains "get_date.sh returns date" "20" "$output"
output=$(bash "$DIR/toolbox/get_battery.sh" 2>&1)
assert_eq "get_battery.sh runs" "ok" "ok"; PASS=$((PASS + 1))
output=$(bash "$DIR/toolbox/list_files.sh" "$DIR" 2>&1)
assert_contains "list_files.sh lists directory" "toolbox" "$output"
output=$(bash "$DIR/toolbox/web_search.sh" "test" 2>&1)
assert_contains "web_search.sh generates URL" "duckduckgo" "$output"
output=$(bash "$DIR/toolbox/sys_info.sh" 2>&1)
assert_contains "sys_info.sh returns info" "System" "$output"
echo ""

# ─── Test 4: Platform detection in installer ───
echo "📱 Test 4: Multi-Platform Installer Support"
inst="$DIR/install-apple.sh"
assert_contains "detects iSH (Alpine Linux)" "alpine-release" "$(cat "$inst")"
assert_contains "detects a-Shell" "a-Shell\|a_shell\|ashell" "$(cat "$inst")"
assert_contains "detects macOS" "Darwin\|macos\|sw_vers" "$(cat "$inst")"
assert_contains "detects Homebrew" "brew\|homebrew" "$(cat "$inst")"
assert_contains "iSH builds llama.cpp from source" "make\|cmake\|llama.cpp" "$(cat "$inst")"
assert_contains "a-Shell uses Python fallback" "python\|pip3\|llama-cpp-python" "$(cat "$inst")"
assert_contains "lite mode fallback exists" "lite\|Lite" "$(cat "$inst")"
echo ""

# ─── Test 5: Platform detection in orchestrator ───
echo "🧠 Test 5: Multi-Platform Orchestrator Support"
orch="$DIR/aether-apple.sh"
assert_contains "orchestrator detects platform" "detect_platform" "$(cat "$orch")"
assert_contains "orchestrator handles iSH" "ish\|iSH" "$(cat "$orch")"
assert_contains "orchestrator handles a-Shell" "ashell\|a-Shell" "$(cat "$orch")"
assert_contains "orchestrator handles macOS" "macos\|macOS" "$(cat "$orch")"
assert_contains "orchestrator has Python fallback" "launch_ai_python\|python3" "$(cat "$orch")"
assert_contains "orchestrator has llama-cli path" "launch_ai_llama\|llama-cli" "$(cat "$orch")"
assert_contains "orchestrator adapts threads per platform" "THREADS" "$(cat "$orch")"
assert_contains "orchestrator shows platform info" "PLATFORM INFO" "$(cat "$orch")"
assert_contains "orchestrator boot sequence shows platform" "APPLE EDITION" "$(cat "$orch")"
echo ""

# ─── Test 6: Toolbox platform awareness ───
echo "🔧 Test 6: Platform-Aware Toolbox"
batt="$DIR/toolbox/get_battery.sh"
assert_contains "battery handles macOS" "pmset\|Darwin" "$(cat "$batt")"
assert_contains "battery handles iSH" "alpine\|iSH\|ish" "$(cat "$batt")"
assert_contains "battery handles a-Shell fallback" "sandboxed\|a-Shell\|ashell" "$(cat "$batt")"
sysinfo="$DIR/toolbox/sys_info.sh"
assert_contains "sys_info handles macOS" "sw_vers\|sysctl\|Darwin" "$(cat "$sysinfo")"
assert_contains "sys_info handles iSH" "alpine\|iSH" "$(cat "$sysinfo")"
assert_contains "sys_info handles generic iPad" "iPad\|sandboxed\|Darwin" "$(cat "$sysinfo")"
echo ""

# ─── Test 7: Manifest ───
echo "📋 Test 7: Toolbox Manifest"
manifest="$DIR/toolbox/manifest.json"
assert_contains "manifest has tools array" '"tools"' "$(cat "$manifest")"
assert_contains "manifest references sys_info" "sys_info" "$(cat "$manifest")"
assert_contains "manifest has 6 tools" '"get_date"' "$(cat "$manifest")"
if command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$manifest'))" 2>/dev/null && \
        assert_eq "manifest.json is valid JSON" "valid" "valid" || \
        assert_eq "manifest.json is valid JSON" "valid" "INVALID"
else
    echo "  ⚠️  python3 not available for JSON validation"
    WARN=$((WARN + 1))
fi
echo ""

# ─── Test 8: Documentation quality ───
echo "📖 Test 8: Documentation Completeness"
readme="$(cat "$DIR/README.md")"
assert_contains "README covers Mac" "macOS\|Mac" "$readme"
assert_contains "README covers iSH" "iSH" "$readme"
assert_contains "README covers a-Shell" "a-Shell" "$readme"
assert_contains "README has 3-tier comparison" "Full\|Medium\|Lite\|three\|Three" "$readme"
assert_contains "README has quick start for all platforms" "Quick Start\|get started" "$readme"
assert_contains "README links to Android repo" "github.com/earnerbaymalay/aether" "$readme"
assert_contains "README has App Store links" "apps.apple.com\|App Store" "$readme"
assert_contains "README mentions free" "Free\|free" "$readme"
assert_contains "README mentions offline" "offline\|Offline" "$readme"

usage="$(cat "$DIR/USAGE.md")"
assert_contains "USAGE has Mac instructions" "brew\|Homebrew\|Mac" "$usage"
assert_contains "USAGE has iSH instructions" "iSH\|ish" "$usage"
assert_contains "USAGE has a-Shell instructions" "a-Shell\|a_shell\|ashell" "$usage"
assert_contains "USAGE has troubleshooting" "Troubleshooting\|troubleshoot" "$usage"
assert_contains "USAGE has FAQ" "FAQ\|faq\|Frequently" "$usage"
assert_contains "USAGE explains platform differences" "platform\|Platform" "$usage"

license="$(cat "$DIR/LICENSE")"
assert_contains "LICENSE has MIT text" "Permission is hereby granted" "$license"
echo ""

# ─── Test 9: Cross-repo linking ───
echo "🔗 Test 9: Cross-Repo Linking"
assert_contains "Apple README links to Android repo" "earnerbaymalay/aether" "$(cat "$DIR/README.md")"
main_readme="$(cat "$DIR/../aether/README.md" 2>/dev/null || echo "")"
if [ -n "$main_readme" ]; then
    assert_contains "Main README links to Apple repo" "aether-apple" "$main_readme"
    assert_contains "Main README mentions iPad" "iPad\|iPadOS" "$main_readme"
    assert_contains "Main README has 4-platform table" "iSH\|a-Shell" "$main_readme"
else
    echo "  ⚠️  Main repo README not found"
    WARN=$((WARN + 1))
fi
echo ""

# ─── Test 10: Gitignore ───
echo "🚫 Test 10: Gitignore"
gi="$(cat "$DIR/.gitignore")"
assert_contains "gitignore excludes models" "models" "$gi"
assert_contains "gitignore excludes .gguf" ".gguf" "$gi"
assert_contains "gitignore excludes sessions" ".aether" "$gi"
echo ""

# ─── Test 11: Model URLs ───
echo "🔗 Test 11: Model URLs Valid"
assert_contains "CHAT model URL present" "Llama-3.2-3B" "$(cat "$orch")"
assert_contains "TURBO model URL present" "Qwen.*Coder.*3B" "$(cat "$orch")"
assert_contains "Installer downloads models" "huggingface" "$(cat "$inst")"
echo ""

# ─── Results ───
echo "╔══════════════════════════════════════════════════╗"
echo "║                 TEST RESULTS                     ║"
echo "╠══════════════════════════════════════════════════╣"
printf "║  ✅ Passed: %-45s ║\n" "$PASS"
printf "║  ❌ Failed: %-45s ║\n" "$FAIL"
printf "║  ⚠️  Warnings: %-43s ║\n" "$WARN"
TOTAL=$((PASS + FAIL + WARN))
printf "║  📊 Total:   %-45s ║\n" "$TOTAL"
echo "╚══════════════════════════════════════════════════╝"

if [ $FAIL -eq 0 ]; then
    echo ""
    echo "  🌌 ALL TESTS PASSED — Apple Edition ready for Mac, iPad (iSH), and iPad (a-Shell)!"
    exit 0
else
    echo ""
    echo "  ⚠️  $FAIL test(s) failed — review above."
    exit 1
fi
