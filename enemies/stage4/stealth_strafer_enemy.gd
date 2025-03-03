extends Enemy

func _init() -> void:
	health = Enemies.STEALTHY_HEALTH
	damage = Enemies.STEALTHY_DAMAGE
	speed = Enemies.STEALTHY_SPEED
	projectile_speed = Enemies.STEALTHY_PROJECTILE_SPEED
	firerate_cooldown = Enemies.STEALTHY_FIRERATE_COOLDOWN
	enemy_name = Enemies.STEALTHY_ENEMY_NAME
	distance_threshold = randi_range(Enemies.STEALTHY_MIN_DISTANCE_THRESHOLD, Enemies.STEALTHY_MAX_DISTANCE_THRESHOLD)
	gold_drop_range = Enemies.STEALTHY_GOLD_DROP_RANGE
	xp_drop_range = Enemies.STEALTHY_XP_DROP_RANGE
	gold_drop_count = Enemies.STEALTHY_GOLD_DROP_COUNT
	xp_type = Enemies.STEALTHY_XP_TYPE
	xp_drop_count = Enemies.STEALTHY_XP_DROP_COUNT
	bullet_scale = Enemies.STEALTHY_BULLET_SIZE
	spawn_radius = Enemies.STEALTHY_SPAWN_RADIUS
	min_spawn_dist = Enemies.STEALTHY_MIN_SPAWN_DIST
	gold_drop_chance = Enemies.STEALTHY_GOLD_DROP_CHANCE
	item_drop_chance = Enemies.STEALTHY_ITEM_DROP_CHANCE
	item_drop_count = Enemies.STEALTHY_ITEM_DROP_COUNT
	shot_count = Enemies.STEALTHY_SHOT_AMOUNT

func _process(delta: float) -> void:
	look_at(GameState.player_position)
	
