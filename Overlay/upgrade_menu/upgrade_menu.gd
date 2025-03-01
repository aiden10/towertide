extends Control

var tower: Tower
@onready var tower_name: Label = $UpgradeMenu/PanelContainer/VBoxContainer/TowerName
@onready var kills_label: Label = $UpgradeMenu/PanelContainer/VBoxContainer/Kills
@onready var tower_image: TextureRect = $UpgradeMenu/PanelContainer/VBoxContainer/TowerImage
@onready var tower_description: Label = $UpgradeMenu/PanelContainer/VBoxContainer/TowerDescription
@onready var close_button: TextureButton = $UpgradeMenu/PanelContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var sell_button: Button = $UpgradeMenu/PanelContainer/VBoxContainer/HBoxContainer/SellButton
@onready var upgrade1_button: Button = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade1/NextTowerContainer/Upgrade1Button
@onready var upgrade1_image: TextureRect = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade1/NextTowerContainer/Upgrade1Image
@onready var upgrade1_price: Label = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade1/PriceContainer/Upgrade1Price
@onready var upgrade1_description: Label = $Description1/VBoxContainer/Description
@onready var upgrade2_button: Button = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade2/NextTowerContainer/Upgrade2Button
@onready var upgrade2_image: TextureRect = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade2/NextTowerContainer/Upgrade2Image
@onready var upgrade2_price: Label = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade2/PriceContainer/Upgrade2Price
@onready var upgrade2_description: Label = $Description2/VBoxContainer/Description
@onready var upgrade3_button: Button = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade3/NextTowerContainer/Upgrade3Button
@onready var upgrade3_image: TextureRect = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade3/NextTowerContainer/Upgrade3Image
@onready var upgrade3_price: Label = $UpgradeMenu/PanelContainer/VBoxContainer/Upgrade3/PriceContainer/Upgrade3Price
@onready var upgrade3_description: Label = $Description3/VBoxContainer/Description
@onready var animation_player: AnimationPlayer = $UpgradeMenu/AnimationPlayer

@onready var description1: PanelContainer = $Description1
@onready var description2: PanelContainer = $Description2
@onready var description3: PanelContainer = $Description3

var kill_text: String

func _ready() -> void:
	EventBus.tower_selected.connect(_show_upgrades)
	EventBus.unselect_pressed.connect(_hide_upgrades)
	close_button.pressed.connect(_hide_upgrades)
	sell_button.pressed.connect(_sell_tower)
	upgrade1_button.pressed.connect(_upgrade1)
	upgrade1_button.mouse_entered.connect(func(): description1.visible = true)
	upgrade1_button.mouse_exited.connect(func(): description1.visible = false)
	upgrade2_button.pressed.connect(_upgrade2)
	upgrade2_button.mouse_entered.connect(func(): description2.visible = true)
	upgrade2_button.mouse_exited.connect(func(): description2.visible = false)
	upgrade3_button.pressed.connect(_upgrade3)
	upgrade3_button.mouse_entered.connect(func(): description3.visible = true)
	upgrade3_button.mouse_exited.connect(func(): description3.visible = false)
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "close":
		self.visible = false

func _sell_tower() -> void:
	tower.sell()

func _upgrade1() -> void:
	if upgrade1_button.text == Towers.end_of_path_name:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return
		
	if PlayerState.gold + PlayerState.minimum_gold < tower.upgrade1_price:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return

	EventBus._tower_upgraded.emit()
	PlayerState.gold -= tower.upgrade1_price
	var new_tower = tower.upgrade1_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower) ## Adds new tower to the arena scene
	new_tower.position = tower.global_position
	GameState.selected_tower = new_tower
	tower.queue_free()
	_show_upgrades()

func _upgrade2() -> void:
	if upgrade2_button.text == Towers.end_of_path_name:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return
		
	if PlayerState.gold + PlayerState.minimum_gold < tower.upgrade2_price:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return

	EventBus._tower_upgraded.emit()
	PlayerState.gold -= tower.upgrade2_price
	var new_tower = tower.upgrade2_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower) ## Adds new tower to the arena scene
	new_tower.position = tower.global_position
	GameState.selected_tower = new_tower
	tower.queue_free()
	_show_upgrades()
	
func _upgrade3() -> void:
	if upgrade3_button.text == Towers.end_of_path_name:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return

	if PlayerState.gold + PlayerState.minimum_gold < tower.upgrade3_price:
		EventBus.invalid_action.emit()
		animation_player.play("shake")
		return
	
	EventBus._tower_upgraded.emit()
	PlayerState.gold -= tower.upgrade3_price
	var new_tower = tower.upgrade3_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower) ## Adds new tower to the arena scene
	new_tower.position = tower.global_position
	GameState.selected_tower = new_tower
	tower.queue_free()
	_show_upgrades()

func update_kills() -> void:
	if is_instance_valid(tower):
		kills_label.text = kill_text + str(tower.kills)

func _show_upgrades() -> void:
	self.visible = true
	animation_player.play("open")
	tower = GameState.selected_tower
	tower_name.text = tower.tower_name
	tower_description.text = tower.description
	tower_image.texture = tower.image
	kill_text = "Kills: "
	if not tower.killed_enemy.is_connected(update_kills):
		tower.killed_enemy.connect(update_kills)
	if tower.is_in_group("EconomyTowers"):
		kill_text = "Gold Produced: "
	kills_label.text = kill_text + str(tower.kills)
	
	# Upgrade 1
	if not tower.upgrade1_price:
		upgrade1_price.text = Towers.end_of_path_cost
	else:
		upgrade1_price.text = str(tower.upgrade1_price)

	if not tower.upgrade1_name:
		upgrade1_button.text = Towers.end_of_path_name
	else:
		upgrade1_button.text = tower.upgrade1_name

	if not tower.upgrade1_description:
		upgrade1_description.text = Towers.end_of_path_description
	else:
		upgrade1_description.text = tower.upgrade1_description

	if not tower.upgrade1_image:
		upgrade1_image.texture = Towers.end_of_path_image
	else: 
		upgrade1_image.texture = tower.upgrade1_image

	# Upgrade 2
	if not tower.upgrade2_price:
		upgrade2_price.text = Towers.end_of_path_cost
	else:
		upgrade2_price.text = str(tower.upgrade2_price)

	if not tower.upgrade2_name:
		upgrade2_button.text = Towers.end_of_path_name
	else:
		upgrade2_button.text = tower.upgrade2_name
		
	if not tower.upgrade2_description:
		upgrade2_description.text = Towers.end_of_path_description
	else:
		upgrade2_description.text = tower.upgrade2_description

	if not tower.upgrade2_image:
		upgrade2_image.texture = Towers.end_of_path_image
	else: 
		upgrade2_image.texture = tower.upgrade2_image

	# Upgrade 3
	if not tower.upgrade3_price:
		upgrade3_price.text = Towers.end_of_path_cost
	else:
		upgrade3_price.text = str(tower.upgrade3_price)

	if not tower.upgrade3_name:
		upgrade3_button.text = Towers.end_of_path_name
	else:
		upgrade3_button.text = tower.upgrade3_name

	if not tower.upgrade3_description:
		upgrade3_description.text = Towers.end_of_path_description
	else:
		upgrade3_description.text = tower.upgrade3_description

	if not tower.upgrade3_image:
		upgrade3_image.texture = Towers.end_of_path_image
	else: 
		upgrade3_image.texture = tower.upgrade3_image

func _hide_upgrades() -> void:
	if is_instance_valid(tower):
		if tower.killed_enemy.is_connected(update_kills):
			tower.killed_enemy.disconnect(update_kills)

	if GameState.selected_tower:
		if is_instance_valid(GameState.selected_tower):
			GameState.selected_tower.deselect_tower()
	
	animation_player.play("close")
