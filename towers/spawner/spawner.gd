extends Tower

class_name Spawner

var minion_scene: PackedScene
var spawn_limit: int

func _init() -> void:
	super()
	base_type = 3

func spawn_minions(spawn_amount: int, _minimum_distance: float) -> void:
	for i in range(spawn_amount):
		var minion = minion_scene.instantiate()
		minion.tower = self
		add_child(minion)
