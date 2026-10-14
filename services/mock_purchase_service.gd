class_name MockPurchaseService
extends PurchaseService
## Clearly labelled mock — never reports a real store transaction.

var _owned: Dictionary = {} # product_id -> true

func purchase(product_id: String) -> void:
	# MOCK ONLY: simulate a delayed success without contacting any store.
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.05).timeout
	_owned[product_id] = true
	purchase_completed.emit(product_id, true, "MOCK_PURCHASE_OK")

func restore_purchases() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	await tree.create_timer(0.05).timeout
	var ids: Array[String] = []
	for key in _owned.keys():
		ids.append(str(key))
	restore_completed.emit(ids, true, "MOCK_RESTORE_OK")

func is_owned(product_id: String) -> bool:
	return bool(_owned.get(product_id, false))
