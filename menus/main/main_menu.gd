extends Control

@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/VolumeBar

var save_exists: bool = false

func _ready() -> void:
	continue_button.pressed.connect(continue_game)
	new_game_button.pressed.connect(start_game)
	volume_slider.drag_ended.connect(update_volume)
	
	save_exists = FileAccess.file_exists("res://save/save.json")
	var tween = create_tween()
	tween.set_loops(-1)
	tween.tween_property($MarginContainer/VBoxContainer/Label, "position:y", 50, 1.8)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($MarginContainer/VBoxContainer/Label, "position:y", 20, 2.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if not save_exists:
		continue_button.pressed.disconnect(continue_game)
		continue_button.modulate = Color(1, 1, 1, 0.25)

func update_volume(_value_changed: bool) -> void:
	SoundManager.sound_level = volume_slider.value
	SoundManager.set_master_volume()
	
func start_game() -> void:
	EventBus._button_pressed.emit()
	SceneManager.load_arena()

func continue_game() -> void:
	EventBus._button_pressed.emit()
	Utils.load_game()
