extends Item

class_name Steroids

func _init() -> void:
	item_name = Items.STEROIDS_NAME
	description = Items.STEROIDS_DESCRIPTION
	price = Items.STEROIDS_PRICE
	image_path = Items.STEROIDS_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	PlayerState.max_health -= Items.STEROIDS_HEALTH_DECREASE
	PlayerState.health = max(PlayerState.max_health, PlayerState.health - Items.STEROIDS_HEALTH_DECREASE)
	PlayerState.damage += Items.STEROIDS_DAMAGE_INCREASE

func use(_delta: float) -> void:
	pass
