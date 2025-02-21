extends Item

class_name Sword

var added = false
var player

func _init() -> void:
	EventBus.arena_initialized.connect(func(): added = false)
	item_name = Items.SWORD_NAME
	description = Items.SWORD_DESCRIPTION
	price = Items.SWORD_PRICE
	image_path = Items.SWORD_IMAGE_PATH
	image = load(image_path)

func use(_delta: float) -> void:
	if added:
		return
	
	EventBus.add_item_scene.emit(Scenes.sword_scene)
	added = true
