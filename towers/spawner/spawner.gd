extends Tower

class_name Spawner

var minion_scene: PackedScene

func spawn_minions(spawn_amount: int) -> void:
	for i in range(spawn_amount):
		var minion = minion_scene.instantiate()
		minion.position = global_position
		EventBus.arena_spawn.emit(minion)
