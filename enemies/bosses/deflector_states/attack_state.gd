extends State
var firerate: float = 0
var can_shoot: bool = true
var pattern_index: int = 0
var patterns: Array = [
	{"angle_step": 30, "count": 5},  # Regular spread
	{"angle_step": 15, "count": 9},  # Narrow, dense spread
	{"angle_step": 45, "count": 3}   # Wide spread
]

func enter() -> void:
	can_shoot = true
	pattern_index = randi() % patterns.size()

func update(delta: float):
	var direction = GameState.player_position - enemy.global_position
	if direction.length() > enemy.distance_threshold * 1.2:
		transitioned.emit(self, "follow")
		return
		
	if firerate > 0:
		firerate -= delta
	if firerate <= 0:
		firerate = enemy.firerate_cooldown
		
		var pattern = patterns[pattern_index]
		var shot_count = pattern["count"]
		var angle_step = pattern["angle_step"]
		var middle_index = shot_count / 2
		
		for i in range(shot_count):
			var offset = (i - middle_index) * angle_step
			shoot(GameState.player_position, offset)
			
		pattern_index = (pattern_index + 1) % patterns.size()
		can_shoot = false
		
		# Exit after shooting sometimes to mix up behavior
		if randf() < 0.3:
			transitioned.emit(self, "follow")

func shoot(player_position: Vector2, offset: int):
	var direction = (player_position - enemy.global_position).normalized()
	var angle_offset = deg_to_rad(offset)
	var rotated_direction = direction.rotated(angle_offset)
	EventBus.enemy_shot.emit()
	var bullet = Scenes.enemy_projectile_scene.instantiate()
	bullet.position = enemy.position
	bullet.start(enemy.position + rotated_direction * 10, enemy.projectile_speed, enemy.damage, get_parent(), enemy.bullet_scale)
	EventBus.arena_spawn.emit(bullet)
