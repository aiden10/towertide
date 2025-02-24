extends Control

@onready var restart_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/RestartButton
@onready var exit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ExitButton
@onready var canvas: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas.visible = false
	EventBus.player_died.connect(func(): canvas.visible = true; EventBus.pause_game.emit())
	restart_button.pressed.connect(restart)
	exit_button.pressed.connect(exit)

func restart() -> void:
	Utils.wipe_saved_game()
	Utils.reset_states()
	SceneManager.load_arena()

func exit() -> void:
	EventBus.unpause_game.emit()
	Utils.wipe_saved_game()
	Utils.reset_states()
	SceneManager.load_main_menu()
