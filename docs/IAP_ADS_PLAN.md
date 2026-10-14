# IAP & Ads plan (non-blocking)

Pinned engine: **Godot 4.7.2-stable** (GDScript standard build).

## Recommendation

| Concern | Choice | Why |
|--------|--------|-----|
| Android IAP | First-party **GodotGooglePlayBilling** (`godot-sdk-integrations/godot-google-play-billing`) | Documented in official Godot docs; Godot 4.2+; Play Billing Library maintained |
| iOS IAP | StoreKit via a maintained iOS plugin (evaluate at Mac build time; do not invent product IDs) | Box cannot build/test iOS |
| Ads (Android + iOS) | **godot-sdk-integrations/godot-admob** (v7.x targets Godot 4.7) *or* Poing Studios AdMob (AssetLib, min 4.5) | Prefer first-party `godot-admob` for version alignment with 4.7; Poing is a strong community alternative with editor mocks |

**Tradeoff:** First-party plugins track engine releases closely but Android Gradle builds may be required for billing. Poing AdMob has editor mock ads (handy for agents) but is community-maintained.

## Status notes (research snapshot, 2026-10-14)

- GodotGooglePlayBilling: official tutorial; Android-only; requires Play Console products later; no live purchases in this repo.
- godot-admob v7.0: tested against Godot 4.7; Android + iOS; UMP/consent support expected via Mobile Ads SDK.
- Poing AdMob: AssetLib; min Godot 4.5; editor mock ads; last updated Sept 2026 per store listing.

## Code isolation (done in demo)

- `PurchaseService` / `AdsService` interfaces
- `MockPurchaseService` / `MockAdsService` only — messages prefixed `MOCK_*`
- No product IDs, ad unit IDs, or credentials committed as real

## Later device-test checklist

See `docs/DEVICE_TEST_CHECKLIST.md`.
