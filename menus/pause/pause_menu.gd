extends Control

@onready var resume_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ResumeButton
@onready var exit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/ExitButton
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var volume_slider: HSlider = $CanvasLayer/MarginContainer/MarginContainer/VBoxContainer/VolumeBar

func _ready() -> void:
	canvas.visible = false
	resume_button.pressed.connect(resume)
	exit_button.pressed.connect(exit)
	volume_slider.drag_ended.connect(update_volume)
	volume_slider.value = SoundManager.sound_level

func update_volume(_value_changed: bool) -> void:
	EventBus._button_pressed.emit()
	SoundManager.sound_level = volume_slider.value
	SoundManager.set_master_volume()

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
	EventBus._button_pressed.emit()
	EventBus.unpause_game.emit()

func exit() -> void:
	EventBus.unpause_game.emit()
	EventBus._button_pressed.emit()
	Utils.save_game()
	Utils.reset_states()
	SceneManager.load_main_menu()
