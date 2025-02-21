extends Control

@onready var next_level_button: Button = $CanvasLayer/LevelContainer/NextLevelButton

func _ready() -> void:
	next_level_button.pressed.connect(_next_level)
	
func _next_level() -> void:
	get_tree().change_scene_to_packed(Scenes.arena_scene)
