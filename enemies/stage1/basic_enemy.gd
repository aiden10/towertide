extends Enemy

func _init() -> void:
	health = Enemies.BASIC_SHOOTER_HEALTH
	damage = Enemies.BASIC_SHOOTER_DAMAGE
	speed = Enemies.BASIC_SHOOTER_SPEED
	projectile_speed = Enemies.BASIC_SHOOTER_PROJECTILE_SPEED
	firerate_cooldown = Enemies.BASIC_SHOOTER_FIRERATE_COOLDOWN
	distance_threshold = randi_range(Enemies.BASIC_SHOOTER_MIN_DISTANCE_THRESHOLD, Enemies.BASIC_SHOOTER_MAX_DISTANCE_THRESHOLD)
	enemy_name = Enemies.BASIC_SHOOTER_ENEMY_NAME
	gold_drop_range = Enemies.BASIC_SHOOTER_GOLD_DROP_RANGE
	xp_drop_range = Enemies.BASIC_SHOOTER_XP_DROP_RANGE
	gold_drop_chance = Enemies.BASIC_SHOOTER_GOLD_DROP_CHANCE
	gold_drop_count = Enemies.BASIC_SHOOTER_GOLD_DROP_COUNT
	xp_drop_count = Enemies.BASIC_SHOOTER_XP_DROP_COUNT
	bullet_scale = Enemies.BASIC_SHOOTER_BULLET_SCALE
	min_spawn_dist = Enemies.BASIC_SHOOTER_MIN_SPAWN_DIST
	spawn_radius = Enemies.BASIC_SHOOTER_SPAWN_RADIUS
	item_drop_chance = Enemies.BASIC_SHOOTER_ITEM_DROP_CHANCE
	item_drop_count = Enemies.BASIC_SHOOTER_ITEM_DROP_COUNT
