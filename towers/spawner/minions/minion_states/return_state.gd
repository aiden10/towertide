extends State
var tower_position: Vector2
var direction: Vector2
var shot_timer: float = 0
var return_timer: float = 0
var max_return_time: float = 10.0

func enter() -> void:
	minion.speed *= 3 
	tower_position = minion.tower.global_position
	shot_timer = 0
	return_timer = 0 
	
	if not is_instance_valid(minion.detected_enemy):
		transitioned.emit(self, "idle")

func exit() -> void:
	minion.speed /= 3
	minion.detected_enemy = null

func attack():
	if is_instance_valid(minion.detected_enemy):
		minion.detected_enemy.take_damage(minion.damage * PlayerState.damage, minion.tower)

func physics_update(delta: float) -> void:
	return_timer += delta
	
	if return_timer > max_return_time:
		transitioned.emit(self, "idle")
		return
	
	if not is_instance_valid(minion.detected_enemy):
		transitioned.emit(self, "idle")
		return
		
	if minion.global_position.distance_to(tower_position) < 25:
		if is_instance_valid(minion.detected_enemy):
			attack()
		transitioned.emit(self, "idle")
		return
		
	direction = tower_position - minion.global_position
	minion.velocity = direction.normalized() * minion.speed
	minion.look_at(tower_position)
	
	# Move the enemy with the kidnapper
	if is_instance_valid(minion.detected_enemy):
		minion.detected_enemy.global_position = minion.global_position
		minion.detected_enemy.velocity = Vector2.ZERO
	
	shot_timer -= delta
	if shot_timer <= 0:
		attack()
		shot_timer = minion.firerate_cooldown
