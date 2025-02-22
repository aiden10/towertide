extends Control

@onready var gold_label: Label = $CanvasLayer/StatsContainer/PanelContainer/MarginContainer/GridContainer/GoldLabel
@onready var health_label: Label = $CanvasLayer/StatsContainer/PanelContainer/MarginContainer/GridContainer/HealthLabel
@onready var kills_label: Label = $CanvasLayer/StatsContainer/PanelContainer/MarginContainer/GridContainer/KillsLabel
@onready var clear_condition_label: Label = $CanvasLayer/ClearConditionContainer/PanelContainer/MarginContainer/ClearConditionLabel
@onready var xp_label: Label = $CanvasLayer/XPContainer/VBoxContainer/XPLabel
@onready var xp_bar: ProgressBar = $CanvasLayer/XPContainer/VBoxContainer/XPBar
@onready var cross_cost_label: Label = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CrossCostLabel
@onready var key_label1: Label = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/KeyLabel1
@onready var tower1_image: TextureRect = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/PanelContainer/Tower1Image

## I either emit a signal each time one of these values changes, or I constantly call _process
var level_clear = false

func _ready() -> void:
	EventBus.level_cleared.connect(func(): level_clear = not level_clear)
	EventBus.tower1_selected.connect(func():tower1_image.modulate = Color8(255, 255, 255, 50))
	EventBus.tower1_deselected.connect(func():tower1_image.modulate = Color8(255, 255, 255, 150))
	cross_cost_label.text = str(Towers.CROSS_COST)
	key_label1.text = Utils.get_action_key_name("place_tower1")
	
func _process(_delta: float) -> void:
	gold_label.text = str(PlayerState.gold)
	health_label.text = str(PlayerState.health) + " / " + str(PlayerState.max_health)
	kills_label.text = str(PlayerState.enemies_killed)
	xp_label.text = str(PlayerState.xp) + " / " + str(PlayerState.level_up_condition)
	xp_bar.max_value = PlayerState.level_up_condition
	xp_bar.value = PlayerState.xp
	if not level_clear:
		clear_condition_label.text = "Kill " + str(GameState.clear_condition) + " enemies to proceed"
	else:
		clear_condition_label.text = "Enter the door to proceed to the shop"
