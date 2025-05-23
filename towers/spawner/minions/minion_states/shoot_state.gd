extends State

var destination: Vector2
var direction: Vector2
var shot_timer: float = 0
var shot_count: int = 0

func enter() -> void:
	shot_count = 0

func shoot(_player_position: Vector2, offset: float = 0):
	var aim_direction = (minion.detected_enemy.global_position - minion.global_position).normalized()
	var angle_offset = deg_to_rad(offset)
	var rotated_direction = aim_direction.rotated(angle_offset)

	EventBus.enemy_shot.emit()
	
	var bullet = Scenes.player_projectile_scene.instantiate()

	bullet.position = minion.global_position
	bullet.start(minion.global_position + rotated_direction * 10, minion.projectile_speed * PlayerState.projectile_speed, minion.damage * PlayerState.damage, minion.tower, minion.bullet_scale)
	EventBus.arena_spawn.emit(bullet)
	shot_count += 1
	if minion.minion_name == Towers.DRIFTER_NAME and shot_count > 3:
		if randf() > 0.5:
			transitioned.emit(self, "melee")
		else:
			transitioned.emit(self, "idle")

func physics_update(_delta: float) -> void:
	if not minion.detected_enemy:
		transitioned.emit(self, "idle")
		return

	shot_timer -= _delta
	minion.look_at(minion.detected_enemy.global_position)
	if shot_timer <= 0:
		shoot(minion.detected_enemy.position)
		shot_timer = minion.firerate_cooldown
	
	destination = minion.detected_enemy.global_position
	direction = destination - minion.global_position
	
	var distance_to_enemy = direction.length()
	
	if distance_to_enemy < minion.min_wander:
		direction = -direction.normalized() * (minion.min_wander - distance_to_enemy)
	elif distance_to_enemy > minion.min_wander + 50:
		direction = direction.normalized() * (distance_to_enemy - minion.min_wander)
	else:
		direction = Vector2.ZERO

	minion.velocity = direction.normalized() * minion.speed if direction.length() > 0 else Vector2.ZERO
