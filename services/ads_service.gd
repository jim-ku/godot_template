class_name AdsService
extends RefCounted
## Platform-agnostic ads API. Real AdMob SDKs plug in later.

signal rewarded_completed(success: bool, message: String)
signal interstitial_completed(success: bool, message: String)

func show_rewarded() -> void:
	push_error("AdsService.show_rewarded not implemented")

func show_interstitial() -> void:
	push_error("AdsService.show_interstitial not implemented")
