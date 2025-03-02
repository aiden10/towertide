extends State

func physics_update(_delta: float):
	var direction = GameState.player_position - enemy.global_position
	enemy.velocity = direction.normalized() * enemy.speed
