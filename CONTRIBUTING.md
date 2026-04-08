# Contributing to Aether Apple

Thanks for your interest! This project follows the same contribution guidelines as the main [Aether project](https://github.com/earnerbaymalay/aether).

## Quick Guide

1. Fork and branch from `main`
2. Make your changes (bash scripts, installer, documentation)
3. Test on your platform (macOS, iSH, or a-Shell)
4. Submit a PR with a clear description of what changed

## Coding Standards

- Shell scripts must be POSIX-compatible where possible
- Use `~/aether-apple/` as the base path
- All toolbox scripts must gracefully handle missing dependencies
- No hardcoded credentials or API keys
- Document new features in the README

## Testing

- Run the installer on a clean environment to verify
- Test each platform variant (macOS Homebrew, iSH, a-Shell)
- Verify the `ai` shortcut works after installation
