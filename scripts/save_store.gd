class_name SaveStore
extends RefCounted
## Minimal JSON save/load for the infra demo. Not production persistence.

const SAVE_PATH := "user://infra_demo_save.json"

static func load_score() -> int:
	if not FileAccess.file_exists(SAVE_PATH):
		return 0
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_warning("SaveStore: failed to open save for read: %s" % FileAccess.get_open_error())
		return 0
	var data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return 0
	return int(data.get("score", 0))

static func save_score(score: int) -> bool:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("SaveStore: failed to open save for write: %s" % FileAccess.get_open_error())
		return false
	file.store_string(JSON.stringify({"score": score, "version": 1}))
	return true
