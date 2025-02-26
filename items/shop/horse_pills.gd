extends Item

class_name HorsePills

func _init() -> void:
	item_name = Items.HORSE_PILLS_NAME
	description = Items.HORSE_PILLS_DESCRIPTION
	price = Items.HORSE_PILLS_PRICE
	image_path = Items.HORSE_PILLS_IMAGE_PATH
	image = load(image_path)

func on_aquire() -> void:
	EventBus._item_aquired.emit()
	var player_stats = [
		"damage", 
		"speed", 
		"max_health", 
		"firerate", 
		"projectile_speed", 
		"knockback", 
		"pierce", 
		"bullet_size", 
		"regen"
	]
	
	var first_stat_name = player_stats.pick_random()
	player_stats.remove_at(player_stats.find(first_stat_name))
	var second_stat_name = player_stats.pick_random()
	PlayerState.set(first_stat_name, max(1, PlayerState.get(first_stat_name) * Items.HORSE_PILLS_PERCENT_INCREASE))    
	PlayerState.set(second_stat_name, max(1, PlayerState.get(second_stat_name) * Items.HORSE_PILLS_PERCENT_DECREASE))
	
	## In case max health was changed
	## Since this can only be obtained in the shop, it doesn't matter if it technically fully heals you
	PlayerState.health = PlayerState.max_health
	
func use(_delta: float) -> void:
	pass
