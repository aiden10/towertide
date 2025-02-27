extends State

func physics_update(_delta: float):
	var direction = GameState.player_position - enemy.global_position

	if direction.length() > enemy.distance_threshold:
		enemy.velocity = direction.normalized() * enemy.speed
	else:
		enemy.velocity = Vector2()
		transitioned.emit(self, "attack")
		return
	
