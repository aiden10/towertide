extends Node

func get_random_position_in_radius(center: Vector2, radius: float) -> Vector2:
	var random_angle = randf() * 2 * PI	
	var random_radius = sqrt(randf()) * radius

	return center + Vector2(
		cos(random_angle) * random_radius,
		sin(random_angle) * random_radius
	)

func spawn_hit_effect(color: Color, position: Vector2) -> void:
	var hit_effect = Scenes.hit_effect_scene.instantiate()
	hit_effect.global_position = position
	hit_effect.set_color(color)
	EventBus.arena_spawn.emit(hit_effect)
