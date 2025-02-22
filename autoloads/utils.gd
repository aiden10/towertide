extends Node

func get_random_position_in_radius(center: Vector2, radius: float, min_distance: float = 0) -> Vector2:
	var random_angle = randf() * 2 * PI	
	var random_radius = sqrt(randf()) * (radius - min_distance) + min_distance
	return center + Vector2(
		cos(random_angle) * random_radius,
		sin(random_angle) * random_radius
	)
	
func spawn_hit_effect(color: Color, position: Vector2, damage: float) -> void:
	var hit_effect = Scenes.hit_effect_scene.instantiate()
	hit_effect.global_position = position
	hit_effect.set_properties(color, damage)
	EventBus.arena_spawn.emit(hit_effect)
	
func get_action_key_name(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	
	if events.size() > 0:
		var event = events[0]
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)

	return "None"
