extends Control

@onready var tower_image1: TextureRect = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/TowerImage
@onready var tower_name1: Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/TowerName
@onready var limit_increase1: Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/LimitIncrease
@onready var select1: Button = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer/SelectButton

@onready var tower_image2: TextureRect = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer2/TowerImage
@onready var tower_name2: Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer2/TowerName
@onready var limit_increase2: Label = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer2/LimitIncrease
@onready var select2: Button = $VBoxContainer/PanelContainer/HBoxContainer/VBoxContainer2/SelectButton

var options: Array[String] = ["Sprayer", "Sentry", "Blank", "Spawner"]
var option_images = {
	"Sprayer": Towers.CROSS_IMAGE,
	"Sentry": Towers.SENTRY_IMAGE,
	"Blank": Towers.BLANK_IMAGE,
	"Spawner": Towers.SPAWNER_IMAGE
}

var option1: String
var option2: String

func _ready() -> void:
	visible = false
	EventBus.level_cleared.connect(update_options)
	select1.pressed.connect(upgrade1)
	select2.pressed.connect(upgrade2)

func upgrade1() -> void:
	match option1:
		"Sprayer":
			PlayerState.sprayer_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Sentry":
			PlayerState.sentry_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Blank":
			PlayerState.blank_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Spawner":
			PlayerState.spawner_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
	visible = false
	GameState.allocate_menu_up = false
	EventBus.unpause_game.emit()

func upgrade2() -> void:
	match option2:
		"Sprayer":
			PlayerState.sprayer_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Sentry":
			PlayerState.sentry_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Blank":
			PlayerState.blank_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
		"Spawner":
			PlayerState.spawner_limit += AllocationIncrements.TOWER_LIMIT_INCREASE
	visible = false
	GameState.allocate_menu_up = false
	EventBus.unpause_game.emit()

func update_options() -> void:
	var filtered_options: Array[String] = options.duplicate()
	filtered_options.shuffle()
	option1 = filtered_options[0]
	option2 = filtered_options[1]
	
	tower_image1.texture = option_images[option1]
	tower_image2.texture = option_images[option2]
	
	tower_name1.text = option1 + " Limit"
	tower_name2.text = option2 + " Limit"
	
	limit_increase1.text = "Limit +" + str(AllocationIncrements.TOWER_LIMIT_INCREASE)
	limit_increase2.text = "Limit +" + str(AllocationIncrements.TOWER_LIMIT_INCREASE)

	visible = true
	GameState.allocate_menu_up = true
	EventBus.pause_game.emit()
