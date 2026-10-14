extends SceneTree
## QA gate: programmatic interaction — not a full unit suite.
## Verifies score +1, label update, save/load across fresh instance, mock labels.

var _failures: PackedStringArray = []

func _init() -> void:
	call_deferred("_run")

func _fail(msg: String) -> void:
	_failures.append(msg)
	push_error("QA FAIL: %s" % msg)

func _run() -> void:
	# Isolate save file for this gate run
	var abs_path := ProjectSettings.globalize_path("user://infra_demo_save.json")
	if FileAccess.file_exists("user://infra_demo_save.json"):
		DirAccess.remove_absolute(abs_path)

	var scene: PackedScene = load("res://scenes/main.tscn")
	if scene == null:
		_fail("could not load scenes/main.tscn")
		_finish(2)
		return

	var main: Node = scene.instantiate()
	root.add_child(main)
	await process_frame
	await process_frame

	var score_label: Label = main.get_node("%ScoreLabel")
	var status_label: Label = main.get_node("%StatusLabel")
	var score_button: Button = main.get_node("%ScoreButton")
	var save_button: Button = main.get_node("%SaveButton")
	var load_button: Button = main.get_node("%LoadButton")
	var mock_iap: Button = main.get_node("%MockIapButton")
	var mock_ad: Button = main.get_node("%MockAdButton")

	if score_label.text != "Score: 0":
		_fail("expected Score: 0 after clear, got '%s'" % score_label.text)

	# Tap target size (big enough for thumb) — design bar
	if score_button.get_combined_minimum_size().y < 72:
		_fail("score button min height < 72")

	score_button.pressed.emit()
	await process_frame
	if score_label.text != "Score: 1":
		_fail("after one press expected Score: 1, got '%s'" % score_label.text)
	if status_label.text.find("Incremented") < 0:
		_fail("status not updated after increment: '%s'" % status_label.text)

	score_button.pressed.emit()
	score_button.pressed.emit()
	await process_frame
	if score_label.text != "Score: 3":
		_fail("after three presses expected Score: 3, got '%s'" % score_label.text)

	save_button.pressed.emit()
	await process_frame
	if not FileAccess.file_exists("user://infra_demo_save.json"):
		_fail("save file missing after Save")

	# Fresh instance = restart survival
	main.queue_free()
	await process_frame
	var main2: Node = scene.instantiate()
	root.add_child(main2)
	await process_frame
	await process_frame
	var score_label2: Label = main2.get_node("%ScoreLabel")
	if score_label2.text != "Score: 3":
		_fail("after restart expected Score: 3 from save, got '%s'" % score_label2.text)

	# Mock services must stay labelled MOCK_
	var mock_iap_btn: Button = main2.get_node("%MockIapButton")
	var mock_ad_btn: Button = main2.get_node("%MockAdButton")
	var status2: Label = main2.get_node("%StatusLabel")
	mock_iap_btn.pressed.emit()
	await create_timer(0.2).timeout
	if status2.text.find("MOCK") < 0 and status2.text.find("mock") < 0:
		# purchase_completed sets message with MOCK_PURCHASE_OK
		if status2.text.find("MOCK_PURCHASE_OK") < 0 and status2.text.find("ok") < 0:
			_fail("IAP status missing mock evidence: '%s'" % status2.text)
	if status2.text.find("MOCK_PURCHASE_OK") < 0:
		_fail("expected MOCK_PURCHASE_OK in status, got '%s'" % status2.text)

	mock_ad_btn.pressed.emit()
	await create_timer(0.2).timeout
	var score_after_ad: Label = main2.get_node("%ScoreLabel")
	if score_after_ad.text != "Score: 8":
		_fail("after mock rewarded expected Score: 8 (+5), got '%s'" % score_after_ad.text)
	if status2.text.find("MOCK") < 0:
		_fail("rewarded status missing MOCK: '%s'" % status2.text)

	# Portrait project settings
	var orient = ProjectSettings.get_setting("display/window/handheld/orientation")
	if int(orient) != 1:
		_fail("handheld orientation not portrait (1), got %s" % orient)
	if not bool(ProjectSettings.get_setting("input_devices/pointing/emulate_touch_from_mouse")):
		_fail("emulate_touch_from_mouse is false")

	_finish(0 if _failures.is_empty() else 1)

func _finish(code: int) -> void:
	if _failures.is_empty():
		print("QA_GATE_PASS: score/save/load/mock + project input/orientation checks")
	else:
		print("QA_GATE_FAIL count=%d" % _failures.size())
		for f in _failures:
			print("  - %s" % f)
	quit(code)
