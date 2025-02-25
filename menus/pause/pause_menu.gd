extends Control

@onready var resume_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ExitButton
@onready var canvas: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas.visible = false
	resume_button.pressed.connect(resume)
	exit_button.pressed.connect(exit)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("pause"):
		if canvas.visible:
			resume()
		else:
			_on_pause_pressed()

func _on_pause_pressed() -> void:
	if not GameState.allocate_menu_up and not GameState.selected_tower and not GameState.placing_tower:
		canvas.visible = true
		EventBus.pause_game.emit()

func resume() -> void:
	canvas.visible = false
	EventBus.unpause_game.emit()

func exit() -> void:
	EventBus.unpause_game.emit()
	Utils.save_game()
	Utils.reset_states()
	SceneManager.load_main_menu()
