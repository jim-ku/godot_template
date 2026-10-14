# Mobile Infra Demo

Godot **4.7.2-stable** GDScript project: minimal 2D mobile score UI, save/load, and mock `PurchaseService` / `AdsService` stubs.

See [AGENTS.md](AGENTS.md) for agent workflow and [docs/](docs/) for IAP/ads and iOS notes.

```bash
export PATH="$HOME/.local/bin:$PATH"
make import && make check-gdscript && make headless-boot
```
