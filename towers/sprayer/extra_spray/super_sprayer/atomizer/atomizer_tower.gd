extends Tower

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.ATOMIZER_NAME
	description = Towers.ATOMIZER_DESCRIPTION
	cost = Towers.ATOMIZER_COST
	value = cost
	cooldown = Towers.ATOMIZER_COOLDOWN
	damage_scale = Towers.ATOMIZER_DAMAGE_PERCENTAGE
	bullet_scale = Towers.ATOMIZER_BULLET_SCALE
	shot_timer = cooldown
	image = Towers.ATOMIZER_IMAGE
	scene_path = Towers.ATOMIZER_SCENE_PATH
	
func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		shoot_pattern()

func shoot_pattern() -> void:
	EventBus.tower_shot.emit()
	
	var angles = [0, PI/15, 2*PI/15, 3*PI/15, 4*PI/15, 5*PI/15, 6*PI/15, 7*PI/15, 8*PI/15, 9*PI/15, 10*PI/15, 11*PI/15, 12*PI/15, 13*PI/15, 14*PI/15, PI, 16*PI/15, 17*PI/15, 18*PI/15, 19*PI/15, 20*PI/15, 21*PI/15, 22*PI/15, 23*PI/15, 24*PI/15, 25*PI/15, 26*PI/15, 27*PI/15, 28*PI/15, 29*PI/15]

	for angle in angles:
		shoot_at_angle(angle)

func shoot_at_angle(angle: float) -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position
	var target_position = position + Vector2.RIGHT.rotated(angle + randf_range(0, 5)) * 100
	bullet.start(target_position, PlayerState.projectile_speed * Towers.ATOMIZER_SPEED_PERCENTAGE, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)	
	rotation += deg_to_rad(randi_range(1, 10))
