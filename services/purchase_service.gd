class_name PurchaseService
extends RefCounted
## Platform-agnostic purchase API. Real store SDKs plug in later.

signal purchase_completed(product_id: String, success: bool, message: String)
signal restore_completed(product_ids: Array[String], success: bool, message: String)

func purchase(_product_id: String) -> void:
	push_error("PurchaseService.purchase not implemented")

func restore_purchases() -> void:
	push_error("PurchaseService.restore_purchases not implemented")

func is_owned(_product_id: String) -> bool:
	return false
