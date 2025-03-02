extends State

var strafe_direction: int = 1  # 1 for right, -1 for left
var strafe_timer: float = 0
var strafe_interval: float = 1.0

func enter():
	strafe_direction = 1 if randf() > 0.5 else -1
	strafe_timer = 0

func physics_update(delta: float):
	var direction = GameState.player_position - enemy.global_position
	var distance = direction.length()
	
	strafe_timer += delta
	if strafe_timer >= strafe_interval:
		strafe_direction *= -1
		strafe_timer = 0
	
	if distance < enemy.distance_threshold:
		var flee_direction = -direction.normalized()
		var strafe_vector = Vector2(flee_direction.y, -flee_direction.x) * strafe_direction
		var combined_direction = (flee_direction * 0.8 + strafe_vector * 0.2).normalized()
		
		enemy.velocity = combined_direction * enemy.speed
	else:
		enemy.velocity = Vector2()
		transitioned.emit(self, "Follow")
		return
