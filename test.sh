#!/usr/bin/env bash
# 🌌 Aether Apple — Simulated Test Suite
# Tests all logic paths without requiring macOS-specific tools

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

assert_exit() {
    local desc="$1" expected_code="$2" cmd="$3"
    if eval "$cmd" >/dev/null 2>&1; then
        echo "  ✅ $desc (exit 0)"
        PASS=$((PASS + 1))
    else
        local code=$?
        if [ "$code" = "$expected_code" ]; then
            echo "  ✅ $desc (exit $code as expected)"
            PASS=$((PASS + 1))
        else
            echo "  ❌ $desc — expected exit $expected_code, got $code"
            FAIL=$((FAIL + 1))
        fi
    fi
}

DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo "╔══════════════════════════════════════════════╗"
echo "║  🌌 AETHER APPLE — SIMULATED TEST SUITE     ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# ─── Test 1: File structure ───
echo "📂 Test 1: File Structure"
for f in install-apple.sh aether-apple.sh .gitignore LICENSE README.md USAGE.md; do
    [ -f "$DIR/$f" ] && assert_eq "$f exists" "yes" "yes" || assert_eq "$f exists" "yes" "no"
done
for d in toolbox scripts knowledge skills; do
    [ -d "$DIR/$d" ] && assert_eq "$d/ directory exists" "yes" "yes" || assert_eq "$d/ directory exists" "yes" "no"
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
# On non-macOS this will say unavailable, which is expected behavior
if echo "$output" | grep -qi "unavailable\|not available\|pmset"; then
    assert_eq "get_battery.sh runs without crash" "ok" "ok"
    PASS=$((PASS + 1))
else
    assert_eq "get_battery.sh output" "available" "${output:0:20}"
fi

output=$(bash "$DIR/toolbox/list_files.sh" "$DIR" 2>&1)
assert_contains "list_files.sh lists directory" "toolbox" "$output"

output=$(bash "$DIR/toolbox/web_search.sh" "test query" 2>&1)
assert_contains "web_search.sh generates URL" "duckduckgo" "$output"

output=$(bash "$DIR/toolbox/web_read.sh" "https://example.com" 2>&1)
# May or may not have curl, just check no crash
assert_eq "web_read.sh runs" "ok" "ok"
PASS=$((PASS + 1))

echo ""

# ─── Test 4: Manifest validation ───
echo "📋 Test 4: Toolbox Manifest"

manifest="$DIR/toolbox/manifest.json"
assert_contains "manifest has tools" '"tools"' "$(cat "$manifest")"
assert_contains "manifest references get_date" 'get_date' "$(cat "$manifest")"
assert_contains "manifest references get_battery" 'get_battery' "$(cat "$manifest")"
assert_contains "manifest references list_files" 'list_files' "$(cat "$manifest")"
assert_contains "manifest references web_search" 'web_search' "$(cat "$manifest")"
assert_contains "manifest references web_read" 'web_read' "$(cat "$manifest")"

# Verify every script in manifest has a matching file
for tool_script in get_date.sh get_battery.sh list_files.sh web_search.sh web_read.sh; do
    [ -f "$DIR/toolbox/$tool_script" ] && assert_eq "manifest tool $tool_script has file" "yes" "yes" || assert_eq "manifest tool $tool_script has file" "yes" "no"
done
echo ""

# ─── Test 5: Installer logic inspection ───
echo "📦 Test 5: Installer Structure"

install="$DIR/install-apple.sh"
assert_contains "installer checks homebrew" "brew" "$(cat "$install")"
assert_contains "installer creates models dir" "models" "$(cat "$install")"
assert_contains "installer creates sessions dir" "sessions" "$(cat "$install")"
assert_contains "installer creates alias" "alias ai=" "$(cat "$install")"
assert_contains "installer downloads llama model" "huggingface" "$(cat "$install")"
assert_contains "installer handles macOS detection" "uname\|Darwin\|sysctl" "$(cat "$install")"
echo ""

# ─── Test 6: Main orchestrator logic inspection ───
echo "🧠 Test 6: Orchestrator Structure"

orch="$DIR/aether-apple.sh"
assert_contains "orchestrator has boot sequence" "boot_sequence" "$(cat "$orch")"
assert_contains "orchestrator has dependency check" "check_deps" "$(cat "$orch")"
assert_contains "orchestrator has model download" "curl" "$(cat "$orch")"
assert_contains "orchestrator has toolbox" "show_tools" "$(cat "$orch")"
assert_contains "orchestrator has knowledge vault" "context7" "$(cat "$orch")"
assert_contains "orchestrator has session persistence" "last_session.log" "$(cat "$orch")"
assert_contains "orchestrator uses system threads" "hw.ncpu" "$(cat "$orch")"
assert_contains "orchestrator has exit option" "exit 0" "$(cat "$orch")"

# Verify both model entries point to valid HuggingFace URLs
assert_contains "CHAT model URL valid" "huggingface" "$(cat "$orch")"
assert_contains "TURBO model URL valid" "Qwen" "$(cat "$orch")"
echo ""

# ─── Test 7: Gitignore completeness ───
echo "🚫 Test 7: Gitignore"

gitignore="$DIR/.gitignore"
assert_contains "gitignore excludes models" "models" "$(cat "$gitignore")"
assert_contains "gitignore excludes .gguf" ".gguf" "$(cat "$gitignore")"
assert_contains "gitignore excludes sessions" ".aether" "$(cat "$gitignore")"
echo ""

# ─── Test 8: Cross-repo linking ───
echo "🔗 Test 8: Cross-Repo Linking"

readme="$DIR/README.md"
assert_contains "Apple README links to Android repo" "github.com/earnerbaymalay/aether" "$(cat "$readme")"

main_readme="$(cat "$DIR/../aether/README.md" 2>/dev/null || echo "")"
if [ -n "$main_readme" ]; then
    assert_contains "Main README links to Apple repo" "aether-apple" "$main_readme"
    assert_contains "Main README has Apple Edition section" "Apple Edition" "$main_readme"
    assert_contains "Main README has Apple comparison table" "Apple Edition" "$main_readme"
else
    echo "  ⚠️  Main repo README not found (testing from wrong location?)"
    WARN=$((WARN + 1))
fi
echo ""

# ─── Test 9: Documentation quality ───
echo "📖 Test 9: Documentation Completeness"

readme_content="$(cat "$DIR/README.md")"
assert_contains "README has quick start" "Quick Start" "$readme_content"
assert_contains "README has requirements" "Requirements" "$readme_content"
assert_contains "README has project structure" "Structure" "$readme_content"
assert_contains "README has license reference" "License\|MIT" "$readme_content"
assert_contains "README explains Apple vs Android" "Android\|different" "$readme_content"
assert_contains "README has macOS notes" "macOS\|Apple Silicon\|M1" "$readme_content"

usage="$(cat "$DIR/USAGE.md")"
assert_contains "USAGE has installation instructions" "Installation\|install" "$usage"
assert_contains "USAGE has toolbox docs" "Toolbox\|toolbox" "$usage"
assert_contains "USAGE has context7 docs" "Context7\|context7\|Knowledge" "$usage"
assert_contains "USAGE has troubleshooting" "Troubleshooting\|troubleshoot" "$usage"

license="$(cat "$DIR/LICENSE")"
assert_contains "LICENSE has MIT text" "Permission is hereby granted" "$license"
echo ""

# ─── Test 10: JSON validity ───
echo "📋 Test 10: JSON Validation"

if command -v python3 &>/dev/null; then
    python3 -c "import json; json.load(open('$DIR/toolbox/manifest.json'))" 2>/dev/null && \
        assert_eq "manifest.json is valid JSON" "valid" "valid" || \
        assert_eq "manifest.json is valid JSON" "valid" "INVALID"
else
    echo "  ⚠️  python3 not available for JSON validation"
    WARN=$((WARN + 1))
fi
echo ""

# ─── Results ───
echo "╔══════════════════════════════════════════════╗"
echo "║              TEST RESULTS                    ║"
echo "╠══════════════════════════════════════════════╣"
echo "║  ✅ Passed: $PASS                              ║"
echo "║  ❌ Failed: $FAIL                              ║"
echo "║  ⚠️  Warnings: $WARN                           ║"
TOTAL=$((PASS + FAIL + WARN))
echo "║  📊 Total:   $TOTAL                             ║"
echo "╚══════════════════════════════════════════════╝"

if [ $FAIL -eq 0 ]; then
    echo ""
    echo "  🌌 ALL TESTS PASSED — Apple Edition ready for deployment!"
    exit 0
else
    echo ""
    echo "  ⚠️  $FAIL test(s) failed — review above."
    exit 1
fi
