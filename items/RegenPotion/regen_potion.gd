extends Item

class_name RegenPotion

var timer: float = 0
var cooldown: float = Items.REGEN_COOLDOWN

func _init() -> void:
	item_name = Items.REGEN_NAME
	description = Items.REGEN_DESCRIPTION
	price = Items.REGEN_PRICE
	image_path = Items.REGEN_IMAGE_PATH
	image = load(image_path)

func use(_delta: float) -> void:
	timer += _delta
	if timer >= cooldown:
		if PlayerState.health < PlayerState.max_health:
			PlayerState.health += 1
		timer = 0
