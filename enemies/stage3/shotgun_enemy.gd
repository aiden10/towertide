extends Enemy

func _init() -> void:
	health = Enemies.SHOTGUNNER_HEALTH
	damage = Enemies.SHOTGUNNER_DAMAGE
	speed = Enemies.SHOTGUNNER_SPEED
	projectile_speed = Enemies.SHOTGUNNER_PROJECTILE_SPEED
	firerate_cooldown = Enemies.SHOTGUNNER_FIRERATE_COOLDOWN
	enemy_name = Enemies.SHOTGUNNER_ENEMY_NAME
	distance_threshold = randi_range(Enemies.SHOTGUNNER_MIN_DISTANCE_THRESHOLD, Enemies.SHOTGUNNER_MAX_DISTANCE_THRESHOLD)
	gold_drop_range = Enemies.SHOTGUNNER_GOLD_DROP_RANGE
	xp_drop_range = Enemies.SHOTGUNNER_XP_DROP_RANGE
	gold_drop_count = Enemies.SHOTGUNNER_GOLD_DROP_COUNT
	xp_drop_count = Enemies.SHOTGUNNER_XP_DROP_COUNT
	bullet_scale = Enemies.SHOTGUNNER_BULLET_SIZE
	spawn_radius = Enemies.SHOTGUNNER_SPAWN_RADIUS
	min_spawn_dist = Enemies.SHOTGUNNER_MIN_SPAWN_DIST
	item_drop_chance = Enemies.SHOTGUNNER_ITEM_DROP_CHANCE
	item_drop_count = Enemies.SHOTGUNNER_ITEM_DROP_COUNT
	shot_count = Enemies.SHOTGUNNER_SHOT_AMOUNT

func _process(delta: float) -> void:
	look_at(GameState.player_position)
	
