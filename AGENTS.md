# AGENTS.md — Mobile Infra Demo

## Pinned engine

- **Godot 4.7.2-stable** (standard GDScript build, not .NET)
- Official hash recorded at install: `4.7.2.stable.official.ed1daf0bf`
- Box install: `~/.local/opt/godot/4.7.2-stable/` with symlink `~/.local/bin/godot`
- Matching export templates: install under `~/.local/share/godot/export_templates/4.7.2.stable/`

## What this repo is

Infrastructure demonstration for an AI-friendly Godot + GDScript mobile workflow (iOS/Android later). Not final game design or art.

## Layout

```
scenes/main.tscn      # responsive 2D UI score demo
scripts/              # UI + SaveStore
services/             # PurchaseService / AdsService + mocks
assets/               # generated placeholders only
docs/                 # IAP/ads plan, device checklist, iOS Mac path
export/               # build outputs (gitignored artifacts)
Makefile              # agent entrypoints
```

## Conventions

- GDScript only; no C# / no unnecessary native extensions in the demo
- Small, reviewable diffs; one concern per change
- Keep secrets and machine paths out of git
- Mocks must say `MOCK_` in status strings; never invent real product/ad IDs as live

## Verified commands (box, 2026-10-14 HKT)

```bash
export PATH="$HOME/.local/bin:$PATH"
export JAVA_HOME="$HOME/.local/opt/jdk-17"
make versions                 # -> 4.7.2.stable.official.ed1daf0bf
make import                   # exit 0; logs/import.log
make check-gdscript           # exit 0; no SCRIPT/Parse errors (NOT a full test suite)
make headless-boot            # exit 0; runtime smoke only (NOT a full test suite)
make export-android-debug     # exit 0; produced export/infra-demo-debug.apk (~27MB)
make preview                  # needs DISPLAY; interactive, not CI
```

Timeouts are enforced via `timeout` in the Makefile. APK artifact is gitignored.

## Before declaring a task complete

1. `make check-gdscript` clean (no SCRIPT/Parse errors in log)
2. `make headless-boot` clean
3. If touching Android export: report whether an APK actually exists under `export/`
4. Do not claim iOS success from Linux
5. Do not claim real IAP/ads events from mocks

## How to make small changes

1. Edit one scene or service
2. Run `make check-gdscript` and `make headless-boot`
3. Commit with a focused message
