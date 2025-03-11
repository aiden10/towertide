extends Control

@onready var close_button: TextureButton = $CreditsContainer/VBoxContainer/HBoxContainer/CloseButton

func _ready() -> void:
	close_button.pressed.connect(func(): visible = false)
	
