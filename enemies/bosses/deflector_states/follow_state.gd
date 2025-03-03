extends State
var strafe_timer: float = 0
var strafe_duration: float = 1.5
var strafe_direction: Vector2 = Vector2.ZERO
var speed_modifier: float = 1.0

func enter() -> void:
	decide_strafe_direction()
	speed_modifier = randf_range(0.8, 1.2) # Variable speed

func physics_update(delta: float):
	var direction = GameState.player_position - enemy.global_position
	
	# Update strafe timer and direction
	strafe_timer -= delta
	if strafe_timer <= 0:
		decide_strafe_direction()
	
	if direction.length() > enemy.distance_threshold:
		# Main movement toward player with strafing component
		var move_direction = direction.normalized() * 0.8 + strafe_direction * 0.2
		enemy.velocity = move_direction.normalized() * enemy.speed * speed_modifier
	else:
		enemy.velocity = Vector2.ZERO
		
		# Randomly choose between different attack patterns
		var attack_choice = randi_range(0, 3)
		match attack_choice:
			0: transitioned.emit(self, "spiral")
			1: transitioned.emit(self, "burst")
			2: transitioned.emit(self, "charge")
			3: transitioned.emit(self, "attack")
		return

func decide_strafe_direction() -> void:
	strafe_timer = strafe_duration
	var player_dir = (GameState.player_position - enemy.global_position).normalized()
	strafe_direction = player_dir.rotated(PI/2 if randf() > 0.5 else -PI/2)
	speed_modifier = randf_range(0.8, 1.2) # Randomize speed
