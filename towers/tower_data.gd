class_name TowerData

var scene_path: String
var position: Vector2
var kills: int

func _init(source_or_path = null, tower_position: Vector2 = Vector2.ZERO, tower_kills: int = 0) -> void:
	if source_or_path is Tower:
		self.scene_path = source_or_path.scene_path
		self.position = source_or_path.position
		self.kills = source_or_path.kills
	else:
		self.scene_path = source_or_path
		self.position = tower_position
		self.kills = tower_kills
