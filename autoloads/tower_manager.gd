extends Node

class TowerData:
	var scene_path: String
	var position: Vector2
	var kills: int
	
	func _init(tower: Tower) -> void:
		scene_path = tower.scene_path
		position = tower.position
		kills = tower.kills

var active_towers: Array[TowerData] = []

func save_tower(tower: Node2D) -> void:
	active_towers.append(TowerData.new(tower))

func clear_towers() -> void:
	active_towers.clear()

func spawn_saved_towers(parent: Node) -> void:
	for tower_data in active_towers:
		var tower = load(tower_data.scene_path).instantiate()
		tower.position = tower_data.position
		tower.kills = tower_data.kills
		parent.add_child(tower)
		
