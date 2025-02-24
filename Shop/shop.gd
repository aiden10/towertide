extends Control

@onready var next_level_button: Button = $CanvasLayer/LevelContainer/NextLevelButton
@onready var reroll_button: Button = $CanvasLayer/RerollContainer/VBoxContainer/RerollButton
@onready var reroll_label: Label = $CanvasLayer/RerollContainer/VBoxContainer/HBoxContainer/RerollLabel
@onready var gold_label: Label = $CanvasLayer/StatsContainer/PanelContainer/MarginContainer/GridContainer/GoldLabel
@onready var health_label: Label = $CanvasLayer/StatsContainer/PanelContainer/MarginContainer/GridContainer/HealthLabel
@onready var item_container: HBoxContainer = $CanvasLayer/ItemContainer
@export var item_card_count: int = 3
var reroll_cost: int

func _ready() -> void:
	## Cost a third of your gold to reroll
	reroll_cost = max(5, PlayerState.gold * 0.33)
	next_level_button.pressed.connect(_next_level)
	reroll_button.pressed.connect(_reroll)
	reroll_label.text = str(reroll_cost)
	EventBus.purchased.connect(_update_overlay)
	generate_item_cards()
	_update_overlay()
	
func generate_item_cards() -> void:
	for child in item_container.get_children():
		child.queue_free()
		
	for i in range(item_card_count):
		var item_card = Scenes.item_card_scene.instantiate()
		item_container.add_child(item_card)
		var item: Item = Items.all_items.values().pick_random()
		item_card.item = item
		item_card.populate()

func _reroll() -> void:
	if PlayerState.gold < reroll_cost:
		EventBus.invalid_action.emit()
		return

	PlayerState.gold -= reroll_cost
	EventBus.rerolled.emit()
	generate_item_cards()
	_update_overlay()

func _update_overlay() -> void:
	gold_label.text = str(PlayerState.gold)
	health_label.text = str(PlayerState.health) + " / " + str(PlayerState.max_health)

func _next_level() -> void:
	get_tree().change_scene_to_packed(Scenes.arena_scene)
