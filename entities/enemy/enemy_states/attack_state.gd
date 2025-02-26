extends State

var firerate = 0
var can_shoot
var shot_offset = 0

func enter() -> void:
	can_shoot = true

func update(delta: float):
	var direction = GameState.player_position - enemy.global_position
	if direction.length() > enemy.distance_threshold:
		transitioned.emit(self, "follow")
		return

	if firerate > 0:
		firerate -= delta

	if firerate <= 0:
		firerate = enemy.firerate_cooldown
		# Calculate a symmetric offset for each shot
		var shot_count = enemy.shot_count
		# Define the angle step (adjust as needed)
		var angle_step = 30
		# For odd shot counts, the middle shot is index floor(shot_count/2)
		var middle_index = shot_count / 2
		for i in range(shot_count):
			# Calculate offset: middle shot gets 0, others are symmetric.
			var offset = (i - middle_index) * angle_step
			shoot(GameState.player_position, offset)
		can_shoot = false

func shoot(player_position: Vector2, offset: int):
	var direction = (player_position - enemy.global_position).normalized()
	var angle_offset = deg_to_rad(offset)
	var rotated_direction = direction.rotated(angle_offset)
	EventBus.enemy_shot.emit()
	var bullet = Scenes.enemy_projectile_scene.instantiate()
	bullet.position = enemy.position
	bullet.start(enemy.position + rotated_direction * 10, enemy.projectile_speed, enemy.damage, get_parent(), enemy.bullet_scale)
	EventBus.arena_spawn.emit(bullet)
