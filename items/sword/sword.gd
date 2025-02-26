extends Item

class_name Sword

func _init() -> void:
	item_name = Items.SWORD_NAME
	description = Items.SWORD_DESCRIPTION
	price = Items.SWORD_PRICE
	image_path = Items.SWORD_IMAGE_PATH
	image = load(image_path)
	scene = Scenes.sword_scene

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	EventBus.sword_purchased.emit()

func use(_delta: float) -> void:
	pass
