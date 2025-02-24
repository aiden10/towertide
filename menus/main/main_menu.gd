extends Control

@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(continue_game)
	new_game_button.pressed.connect(start_game)

func start_game() -> void:
	SceneManager.load_arena()

func continue_game() -> void:
	Utils.load_game()
