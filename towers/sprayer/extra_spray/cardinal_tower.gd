extends Tower

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.CARDINAL_NAME
	description = Towers.CARDINAL_DESCRIPTION
	cost = Towers.CARDINAL_COST
	value = cost
	cooldown = Towers.CARDINAL_COOLDOWN
	damage_scale = Towers.CARDINAL_DAMAGE_PERCENTAGE
	bullet_scale = Towers.CARDINAL_BULLET_SCALE
	shot_timer = cooldown
	image = Towers.CARDINAL_IMAGE
	scene_path = Towers.CARDINAL_SCENE_PATH
	
	upgrade1_name = Towers.CLOUD_NAME
	upgrade1_description = Towers.CLOUD_DESCRIPTION
	upgrade1_price = Towers.CLOUD_COST
	upgrade1_image = Towers.CLOUD_IMAGE
	upgrade1_scene = Scenes.cloud_tower_scene

	upgrade2_name = Towers.SUPER_SPRAYER_NAME
	upgrade2_description = Towers.SUPER_SPRAYER_DESCRIPTION
	upgrade2_price = Towers.SUPER_SPRAYER_COST
	upgrade2_image = Towers.SUPER_SPRAYER_IMAGE
	upgrade2_scene = Scenes.super_sprayer_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		shoot_pattern()

func shoot_pattern() -> void:
	EventBus.tower_shot.emit()
	var angles = [PI/4, 3*PI/4, 5*PI/4, 7*PI/4, 0, PI/2, PI, 3*PI/2]

	for angle in angles:
		shoot_at_angle(angle)

func shoot_at_angle(angle: float) -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position
	var target_position = position + Vector2.RIGHT.rotated(angle) * 100
	bullet.start(target_position, PlayerState.projectile_speed * Towers.CARDINAL_SPEED_PERCENTAGE, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)	
