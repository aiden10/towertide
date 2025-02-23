extends Tower

class_name Spawner

var minion_scene: PackedScene

func spawn_minions(spawn_amount: int, minimum_distance: float) -> void:
	for i in range(spawn_amount):
		var minion = minion_scene.instantiate()
		minion.tower = self
		var rand_position = Utils.get_random_position_in_radius(global_position, minimum_distance)
		minion.position = rand_position
		EventBus.arena_spawn.emit(minion)
