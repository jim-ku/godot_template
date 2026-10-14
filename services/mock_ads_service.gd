class_name MockAdsService
extends AdsService
## Clearly labelled mock — never loads or shows a live ad.

func show_rewarded() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.05).timeout
	rewarded_completed.emit(true, "MOCK_REWARDED_OK")

func show_interstitial() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.05).timeout
	interstitial_completed.emit(true, "MOCK_INTERSTITIAL_OK")
