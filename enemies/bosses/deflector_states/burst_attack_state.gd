extends State
var burst_timer: float = 0
var burst_duration: float = 0.5
var pause_duration: float = 0.7
var shot_timer: float = 0
var shot_interval: float = 0.05
var bursts_remaining: int = 3
var is_bursting: bool = false

func enter() -> void:
	bursts_remaining = 3
	is_bursting = true
	burst_timer = burst_duration
	shot_timer = 0

func update(delta: float):
	var direction = GameState.player_position - enemy.global_position
	if direction.length() > enemy.distance_threshold * 1.3:
		transitioned.emit(self, "follow")
		return
		
	if is_bursting:
		burst_timer -= delta
		shot_timer -= delta
		
		if shot_timer <= 0:
			shot_timer = shot_interval
			shoot_at_player()
			
		if burst_timer <= 0:
			is_bursting = false
			burst_timer = pause_duration
	else:
		burst_timer -= delta
		if burst_timer <= 0:
			bursts_remaining -= 1
			
			if bursts_remaining <= 0:
				transitioned.emit(self, "follow")
				return
				
			is_bursting = true
			burst_timer = burst_duration

func shoot_at_player():
	var direction = (GameState.player_position - enemy.global_position).normalized()
	var spread = randf_range(-0.1, 0.1)
	var rotated_direction = direction.rotated(spread)
	
	EventBus.enemy_shot.emit()
	var bullet = Scenes.enemy_projectile_scene.instantiate()
	bullet.position = enemy.position
	bullet.start(enemy.position + rotated_direction * 10, enemy.projectile_speed * 1.2, enemy.damage * 0.7, get_parent(), enemy.bullet_scale * 0.8)
	EventBus.arena_spawn.emit(bullet)
