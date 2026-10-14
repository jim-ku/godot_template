# Device test checklist (later — real devices / sandbox)

Do **not** mark pass without a real build on device.

## Purchases (sandbox)

- [ ] Sandbox purchase succeeds for a temporary product
- [ ] User cancels purchase mid-flow — no grant
- [ ] Restore permanent purchase after reinstall / clear data
- [ ] Consumable: grant once per successful consume; no duplicate grants on reopen
- [ ] Offline / Play services failure — clear error, no silent grant

## Ads

- [ ] Rewarded: completion grants reward once
- [ ] Rewarded: failure / close early — no reward
- [ ] App background/resume during ad — no crash; state coherent
- [ ] Test ad units only until release; no live ads in debug

## Privacy / consent

- [ ] Applicable UMP / ATT / privacy disclosures shown where required
- [ ] No tracking before consent where law requires it

## Platforms

- [ ] Android (mid-tier) debug build
- [ ] iOS (on Mac + device) — separate from this Linux box
