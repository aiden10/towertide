extends Item

class_name RegenPotion

func _init() -> void:
	item_name = Items.REGEN_NAME
	description = Items.REGEN_DESCRIPTION
	price = Items.REGEN_PRICE
	image_path = Items.REGEN_IMAGE_PATH
	image = load(image_path)
	PlayerState.regen_cooldown /= 1.25

func use(_delta: float) -> void:
	pass
