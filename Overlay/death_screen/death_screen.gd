extends Control

@onready var restart_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/RestartButton
@onready var exit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ExitButton
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var stage_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/StageLabel

func _ready() -> void:
	canvas.visible = false
	EventBus.player_died.connect(show_screen)
	restart_button.pressed.connect(restart)
	exit_button.pressed.connect(exit)

func show_screen() -> void:
	canvas.visible = true
	EventBus.pause_game.emit()
	stage_label.text = "Survived Until Stage " + str(GameState.stage)
	
func restart() -> void:
	SceneManager.load_arena()
	Utils.reset_states()
	Utils.wipe_saved_game()

func exit() -> void:
	EventBus.unpause_game.emit()
	SceneManager.load_main_menu()
	Utils.reset_states()
	Utils.wipe_saved_game()
