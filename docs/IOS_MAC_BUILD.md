# iOS build path (Mac required)

This Linux box has **no macOS/Xcode**. No iOS binary was built or tested here.

## Remaining steps on a Mac

1. Install matching **Godot 4.7.2-stable** (standard, not .NET) + export templates.
2. Install Xcode + command-line tools; accept licenses; run once.
3. Open this project; configure iOS export preset (temporary bundle id).
4. Export IPA / run on device or simulator from the Mac.
5. Wire real StoreKit / AdMob iOS plugins only after Android path is proven with mocks.

Do not connect App Store Connect or paid cloud builders from the agent box unless Jim explicitly asks.
