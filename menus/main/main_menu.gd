extends Control

@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton
@onready var continue_button: Button = $MarginContainer/VBoxContainer/ContinueButton
@onready var credits_button: Button = $MarginContainer/VBoxContainer/CreditsButton
@onready var more_games_button: Button = $MarginContainer2/VBoxContainer/MoreGamesButton
@onready var fullscreen_button: TextureButton = $MarginContainer3/VBoxContainer/FullscreenButton
@onready var like_us_button: Button = $MarginContainer2/VBoxContainer/LikeUsButton
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/VolumeBar
@onready var logo: TextureButton = $MarginContainer2/VBoxContainer/AGLogo
@onready var credits: Control = $Credits

var save_exists: bool = false

func _ready() -> void:
	continue_button.pressed.connect(continue_game)
	new_game_button.pressed.connect(start_game)
	like_us_button.pressed.connect(func(): OS.shell_open("https://bsky.app/profile/armorgamesstudios.com"))
	more_games_button.pressed.connect(func(): OS.shell_open("https://armor.ag/MoreGames"))
	credits_button.pressed.connect(func(): credits.visible = true)
	fullscreen_button.pressed.connect(Utils.toggle_fullscreen)
	volume_slider.drag_ended.connect(update_volume)
	logo.pressed.connect(func(): OS.shell_open("https://armor.ag/MoreGames"))
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
	EventBus._button_pressed.emit()
	SoundManager.sound_level = volume_slider.value
	SoundManager.set_master_volume()
	
func start_game() -> void:
	EventBus._button_pressed.emit()
	Utils.spawn_hit_effect(Color(1, 1, 1, 1), position, 10)
	SceneManager.load_arena()

func continue_game() -> void:
	EventBus._button_pressed.emit()
	Utils.load_game()
