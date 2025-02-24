extends Node

func load_main_menu() -> void:
	get_tree().change_scene_to_file("res://menus/main/MainMenu.tscn")

func load_arena() -> void:
	get_tree().change_scene_to_file("res://arena/arena.tscn")
	get_tree().paused = false
