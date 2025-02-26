extends Enemy

func _init() -> void:
	health = Enemies.TANKY_HEALTH
	damage = Enemies.TANKY_DAMAGE
	speed = Enemies.TANKY_SPEED
	enemy_name = Enemies.TANKY_ENEMY_NAME
	gold_drop_range = Enemies.TANKY_GOLD_DROP_RANGE
	xp_drop_range = Enemies.TANKY_XP_DROP_RANGE
	gold_drop_count = Enemies.TANKY_GOLD_DROP_COUNT
	xp_drop_count = Enemies.TANKY_XP_DROP_COUNT
	min_spawn_dist = Enemies.TANKY_MIN_SPAWN_DIST
	spawn_radius = Enemies.TANKY_SPAWN_RADIUS
	item_drop_chance = Enemies.TANKY_ITEM_DROP_CHANCE
	item_drop_count = Enemies.TANKY_ITEM_DROP_COUNT
