extends Control

@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton

var save_exists: bool = false

func _ready() -> void:
	continue_button.pressed.connect(continue_game)
	new_game_button.pressed.connect(start_game)
	save_exists = FileAccess.file_exists("res://save/save.json")
	if not save_exists:
		continue_button.pressed.disconnect(continue_game)
		continue_button.modulate = Color(1, 1, 1, 0.25)

func start_game() -> void:
	SceneManager.load_arena()

func continue_game() -> void:
	Utils.load_game()
