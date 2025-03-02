extends State

var shot_timer: float = 0
var optimal_range: float = 40.0

func enter() -> void:
	if minion.minion_name == Towers.PERSON_NAME:
		minion.sprite.play("attack")
		minion.sprite.flip_h = false
	if minion.minion_name == Towers.DRIFTER_NAME:
		minion.speed *= 2

func exit() -> void:
	if minion.minion_name == Towers.DRIFTER_NAME:
		minion.speed /= 2

func attack():
	if is_instance_valid(minion.detected_enemy):
		minion.look_at(minion.detected_enemy.position)
		minion.detected_enemy.take_damage(minion.damage * PlayerState.damage, minion.tower)
		if minion.minion_name == Towers.DRIFTER_NAME:
			if randf() > 0.5:
				transitioned.emit(self, "shoot")

func physics_update(_delta: float) -> void:
	if not minion.detected_enemy:
		transitioned.emit(self, "idle")
		return

	shot_timer -= _delta
	var destination = minion.detected_enemy.global_position
	var direction = destination - minion.global_position
	var distance_to_enemy = direction.length()

	if distance_to_enemy > minion.min_wander:
		transitioned.emit(self, "idle")
		return
	
	if shot_timer <= 0 and distance_to_enemy < 50:
		attack()
		shot_timer = minion.firerate_cooldown * PlayerState.firerate
		
	if distance_to_enemy < optimal_range - 10:
		minion.velocity = -direction.normalized() * minion.speed
	elif distance_to_enemy > optimal_range + 10:
		minion.velocity = direction.normalized() * minion.speed
	else:
		minion.velocity = Vector2.ZERO
