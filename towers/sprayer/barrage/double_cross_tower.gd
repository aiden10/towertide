extends Tower

var offset: bool = false

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.DOUBLE_CROSS_NAME
	description = Towers.DOUBLE_CROSS_DESCRIPTION
	cost = Towers.DOUBLE_CROSS_COST
	cooldown = Towers.DOUBLE_CROSS_COOLDOWN
	damage_scale = Towers.DOUBLE_CROSS_DAMAGE_PERCENTAGE
	bullet_scale = Towers.DOUBLE_CROSS_BULLET_SCALE
	shot_timer = cooldown
	image = Towers.DOUBLE_CROSS_IMAGE
	scene_path = Towers.DOUBLE_CROSS_SCENE_PATH
	
func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		shoot_pattern()

func shoot_pattern() -> void:
	EventBus.tower_shot.emit()
	var angles = [0, PI/2, PI, 3*PI/2]
	var offset_distance = 12 
	offset = !offset

	for angle in angles:
		var perpendicular_offset = Vector2.RIGHT.rotated(angle + PI/2) * (offset_distance if offset else -offset_distance)
		shoot_at_angle(angle, Vector2.ZERO)
		shoot_at_angle(angle, perpendicular_offset)

func shoot_at_angle(angle: float, position_offset: Vector2) -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position + position_offset
	var target_position = bullet.position + Vector2.RIGHT.rotated(angle) * 100
	bullet.start(target_position, PlayerState.projectile_speed * Towers.DOUBLE_CROSS_SPEED_PERCENTAGE, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)
