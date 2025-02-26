extends Item

class_name Magnet

func _init() -> void:
	item_name = Items.MAGNET_NAME
	description = Items.MAGNET_DESCRIPTION
	price = Items.MAGNET_PRICE
	image_path = Items.MAGNET_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()

func use(_delta: float) -> void:
	for pickup in PickupManager.gold_pool + PickupManager.xp_pool:
		if is_instance_valid(pickup):
			var direction = (GameState.player_position - pickup.position).normalized()
			pickup.position += direction * Items.MAGNET_ATTRACT_SPEED * _delta
			
