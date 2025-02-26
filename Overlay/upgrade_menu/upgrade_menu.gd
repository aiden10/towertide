extends MarginContainer

var tower: Tower
@onready var tower_name: Label = $PanelContainer/VBoxContainer/TowerName
@onready var kills_label: Label = $PanelContainer/VBoxContainer/Kills
@onready var tower_image: TextureRect = $PanelContainer/VBoxContainer/TowerImage
@onready var tower_description: Label = $PanelContainer/VBoxContainer/TowerDescription
@onready var close_button: TextureButton = $PanelContainer/VBoxContainer/HBoxContainer/CloseButton
@onready var sell_button: Button = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer/SellButton
@onready var upgrade1_button: Button = $PanelContainer/VBoxContainer/Upgrade1/NextTowerContainer/Upgrade1Button
@onready var upgrade1_image: TextureRect = $PanelContainer/VBoxContainer/Upgrade1/NextTowerContainer/Upgrade1Image
@onready var upgrade1_price: Label = $PanelContainer/VBoxContainer/Upgrade1/PriceContainer/Upgrade1Price
@onready var upgrade2_button: Button = $PanelContainer/VBoxContainer/Upgrade2/NextTowerContainer/Upgrade2Button
@onready var upgrade2_image: TextureRect = $PanelContainer/VBoxContainer/Upgrade2/NextTowerContainer/Upgrade2Image
@onready var upgrade2_price: Label = $PanelContainer/VBoxContainer/Upgrade2/PriceContainer/Upgrade2Price
@onready var upgrade3_button: Button = $PanelContainer/VBoxContainer/Upgrade3/NextTowerContainer/Upgrade3Button
@onready var upgrade3_image: TextureRect = $PanelContainer/VBoxContainer/Upgrade3/NextTowerContainer/Upgrade3Image
@onready var upgrade3_price: Label = $PanelContainer/VBoxContainer/Upgrade3/PriceContainer/Upgrade3Price

func _ready() -> void:
	EventBus.tower_selected.connect(_show_upgrades)
	EventBus.unselect_pressed.connect(_hide_upgrades)
	close_button.pressed.connect(_hide_upgrades)
	sell_button.pressed.connect(_sell_tower)
	upgrade1_button.pressed.connect(_upgrade1)
	upgrade2_button.pressed.connect(_upgrade2)
	upgrade3_button.pressed.connect(_upgrade3)

func _sell_tower() -> void:
	EventBus.unselect_pressed.emit()
	PlayerState.gold += int(tower.cost / 2)
	EventBus.tower_sold.emit()
	tower.queue_free()

func _upgrade1() -> void:
	if upgrade1_button.text == Towers.end_of_path_name:
		EventBus.invalid_action.emit()
		return
		
	if PlayerState.gold < tower.upgrade1_price:
		EventBus.invalid_action.emit()
		return
		
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
		return
		
	if PlayerState.gold < tower.upgrade2_price:
		EventBus.invalid_action.emit()
		return

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
		return
		
	if PlayerState.gold < tower.upgrade3_price:
		EventBus.invalid_action.emit()
		return

	PlayerState.gold -= tower.upgrade3_price
	var new_tower = tower.upgrade3_scene.instantiate()
	EventBus.arena_spawn.emit(new_tower) ## Adds new tower to the arena scene
	new_tower.position = tower.global_position
	GameState.selected_tower = new_tower
	tower.queue_free()
	_show_upgrades()

func _show_upgrades() -> void:
	self.visible = true
	tower = GameState.selected_tower
	tower_name.text = tower.tower_name
	tower_description.text = tower.description
	tower_image.texture = tower.image
	tower.killed_enemy.connect(func(): kills_label.text = "Kills: " + str(tower.kills))
	kills_label.text = "Kills: " + str(tower.kills)
	
	# Upgrade 1
	if not tower.upgrade1_price:
		upgrade1_price.text = Towers.end_of_path_cost
	else:
		upgrade1_price.text = str(tower.upgrade1_price)

	if not tower.upgrade1_name:
		upgrade1_button.text = Towers.end_of_path_name
	else:
		upgrade1_button.text = tower.upgrade1_name

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

	if not tower.upgrade3_image:
		upgrade3_image.texture = Towers.end_of_path_image
	else: 
		upgrade3_image.texture = tower.upgrade3_image

func _hide_upgrades() -> void:
	if GameState.selected_tower:
		GameState.selected_tower.deselect_tower()
	self.visible = false
	
	
