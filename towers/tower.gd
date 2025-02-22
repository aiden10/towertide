extends Area2D

class_name Tower

var cooldown: float
var tower_name: String
var cost: int
var damage: float
var kills: int

func upgrade(new_tower_scene: PackedScene) -> void:
	var new_tower = new_tower_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower)
	queue_free()

## Highlight the selected tower
func _mouse_enter() -> void:
	pass

## Unhighlight the tower
func _mouse_exit() -> void:
	pass
