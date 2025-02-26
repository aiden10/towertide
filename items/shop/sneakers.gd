extends Item

class_name Sneakers

func _init() -> void:
	item_name = Items.SNEAKERS_NAME
	description = Items.SNEAKERS_DESCRIPTION
	price = Items.SNEAKERS_PRICE
	image_path = Items.SNEAKERS_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.pierce += Items.SNEAKERS_SPEED_INCREASE

func use(_delta: float) -> void:
	pass
