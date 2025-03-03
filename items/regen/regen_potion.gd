extends Item

class_name RegenPotion

func _init() -> void:
	item_name = Items.REGEN_NAME
	description = Items.REGEN_DESCRIPTION
	price = Items.REGEN_PRICE
	image_path = Items.REGEN_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.regen_cooldown *= Items.REGEN_COOLDOWN_DECREASE

func use(_delta: float) -> void:
	pass
