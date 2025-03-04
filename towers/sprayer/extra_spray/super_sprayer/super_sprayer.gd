extends Tower

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.SUPER_SPRAYER_NAME
	description = Towers.SUPER_SPRAYER_DESCRIPTION
	cost = Towers.SUPER_SPRAYER_COST
	cooldown = Towers.SUPER_SPRAYER_COOLDOWN
	damage_scale = Towers.SUPER_SPRAYER_DAMAGE_PERCENTAGE
	bullet_scale = Towers.SUPER_SPRAYER_BULLET_SCALE
	shot_timer = cooldown
	image = Towers.SUPER_SPRAYER_IMAGE
	scene_path = Towers.SUPER_SPRAYER_SCENE_PATH

	upgrade1_name = Towers.ATOMIZER_NAME
	upgrade1_description = Towers.ATOMIZER_DESCRIPTION
	upgrade1_price = Towers.ATOMIZER_COST
	upgrade1_image = Towers.ATOMIZER_IMAGE
	upgrade1_scene = Scenes.atomizer_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		shoot_pattern()

func shoot_pattern() -> void:
	EventBus.tower_shot.emit()
	
	var angles = [0, PI/6, PI/3, PI/2, 2*PI/3, 5*PI/6, PI, 7*PI/6, 4*PI/3, 3*PI/2, 5*PI/3, 11*PI/6]
	
	for angle in angles:
		shoot_at_angle(angle)

func shoot_at_angle(angle: float) -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position
	var target_position = position + Vector2.RIGHT.rotated(angle) * 100
	bullet.start(target_position, PlayerState.projectile_speed * Towers.SUPER_SPRAYER_SPEED_PERCENTAGE, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)	
