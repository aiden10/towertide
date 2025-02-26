extends Item

class_name LightRounds

func _init() -> void:
	item_name = Items.LIGHT_ROUNDS_NAME
	description = Items.LIGHT_ROUNDS_DESCRIPTION
	price = Items.LIGHT_ROUNDS_PRICE
	image_path = Items.LIGHT_ROUNDS_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.damage -= Items.LIGHT_ROUNDS_DAMAGE_DECREASE
	PlayerState.projectile_speed += Items.LIGHT_ROUNDS_SPEED_INCREASE

func use(_delta: float) -> void:
	pass
