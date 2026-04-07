# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [2.0.0] - 2026-04-07

### Added
- Multi-platform support: macOS (full), iPad via iSH (medium), iPad via a-Shell (lite)
- Auto-detecting installer (`install-apple.sh`) with 3 platform paths
- Platform-adaptive orchestrator (`aether-apple.sh`) with Python fallback
- 6 toolbox scripts with graceful iPad fallbacks (battery, date, files, web search, web read, system info)
- Context7 persistent memory vault (cross-compatible with Android version)
- 83-test simulated test suite (`test.sh`)
- Full documentation: README, USAGE, ROADMAP, LICENSE

### Changed
- Toolbox scripts now detect platform and provide appropriate behavior
- Battery tool gracefully falls back on iPad (sandboxed)
- Thread count auto-adjusts per platform (macOS: all cores, iSH: 2, a-Shell: 2)
