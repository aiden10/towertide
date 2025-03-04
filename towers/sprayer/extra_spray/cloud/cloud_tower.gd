extends Tower

func _init() -> void:
	super()
	base_type = 1
	tower_name = Towers.CLOUD_NAME
	description = Towers.CLOUD_DESCRIPTION
	cost = Towers.CLOUD_COST
	cooldown = Towers.CLOUD_COOLDOWN
	damage_scale = Towers.CLOUD_DAMAGE_PERCENTAGE
	bullet_scale = Towers.CLOUD_BULLET_SCALE
	shot_timer = cooldown
	image = Towers.CLOUD_IMAGE
	scene_path = Towers.CLOUD_SCENE_PATH
	
func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		shoot()

func shoot() -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = Vector2(position.x + randi_range(-50, 50), position.y + randi_range(0, 30))
	var target_position = Vector2(bullet.position.x + randi_range(-30, 30), bullet.position.y + 1000)
	bullet.start(target_position, PlayerState.projectile_speed * Towers.CLOUD_SPEED_PERCENTAGE, PlayerState.damage * damage_scale, self, bullet_scale)
	EventBus.arena_spawn.emit(bullet)	
