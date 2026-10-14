extends Control
## Infra demo: responsive score button + save/load + mock IAP/ads hooks.

@onready var _score_label: Label = %ScoreLabel
@onready var _status_label: Label = %StatusLabel
@onready var _score_button: Button = %ScoreButton
@onready var _save_button: Button = %SaveButton
@onready var _load_button: Button = %LoadButton
@onready var _mock_iap_button: Button = %MockIapButton
@onready var _mock_ad_button: Button = %MockAdButton

var _score: int = 0
var _purchases: PurchaseService
var _ads: AdsService

func _ready() -> void:
	_purchases = MockPurchaseService.new()
	_ads = MockAdsService.new()
	_purchases.purchase_completed.connect(_on_purchase_completed)
	_ads.rewarded_completed.connect(_on_rewarded_completed)
	_score = SaveStore.load_score()
	_refresh_score()
	_set_status("Ready (mock IAP/ads). Touch or click the score button.")
	_score_button.pressed.connect(_on_score_pressed)
	_save_button.pressed.connect(_on_save_pressed)
	_load_button.pressed.connect(_on_load_pressed)
	_mock_iap_button.pressed.connect(_on_mock_iap_pressed)
	_mock_ad_button.pressed.connect(_on_mock_ad_pressed)

func _refresh_score() -> void:
	_score_label.text = "Score: %d" % _score

func _set_status(text: String) -> void:
	_status_label.text = text

func _on_score_pressed() -> void:
	_score += 1
	_refresh_score()
	_set_status("Incremented (input ok).")

func _on_save_pressed() -> void:
	if SaveStore.save_score(_score):
		_set_status("Saved to user://infra_demo_save.json")
	else:
		_set_status("Save failed.")

func _on_load_pressed() -> void:
	_score = SaveStore.load_score()
	_refresh_score()
	_set_status("Loaded score from disk.")

func _on_mock_iap_pressed() -> void:
	_set_status("MOCK purchase started (no real store)…")
	_purchases.purchase("mock.permanent.unlock")

func _on_mock_ad_pressed() -> void:
	_set_status("MOCK rewarded ad started (no live ads)…")
	_ads.show_rewarded()

func _on_purchase_completed(product_id: String, success: bool, message: String) -> void:
	_set_status("Purchase %s: %s (%s)" % [product_id, "ok" if success else "fail", message])

func _on_rewarded_completed(success: bool, message: String) -> void:
	if success:
		_score += 5
		_refresh_score()
	_set_status("Rewarded %s (%s)" % ["ok" if success else "fail", message])
