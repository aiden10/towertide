extends Item

class_name APRounds

func _init() -> void:
	item_name = Items.AP_ROUNDS_NAME
	description = Items.AP_ROUNDS_DESCRIPTION
	price = Items.AP_ROUNDS_PRICE
	image_path = Items.AP_ROUNDS_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.firerate *= Items.AP_ROUNDS_FIRERATE_DECREASE
	PlayerState.pierce += Items.AP_ROUNDS_PIERCE_INCREASE

func use(_delta: float) -> void:
	pass
