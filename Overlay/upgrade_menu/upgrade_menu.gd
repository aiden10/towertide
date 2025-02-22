extends MarginContainer

var tower: Tower
@onready var tower_name: Label = $PanelContainer/VBoxContainer/TowerName
@onready var tower_image: TextureRect = $PanelContainer/VBoxContainer/TowerImage
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
	EventBus.tower_deselected.connect(_hide_upgrades)
	upgrade1_button.pressed.connect(_upgrade1)
	upgrade2_button.pressed.connect(_upgrade2)
	upgrade3_button.pressed.connect(_upgrade3)
	
func _upgrade1() -> void:
	if upgrade1_button.text == Towers.end_of_path_name:
		return
	## Replace GameState.selected_tower with tower.upgrade1_scene
	
func _upgrade2() -> void:
	if upgrade2_button.text == Towers.end_of_path_name:
		return
func _upgrade3() -> void:
	if upgrade3_button.text == Towers.end_of_path_name:
		return

func _show_upgrades() -> void:
	self.visible = true
	tower = GameState.selected_tower
	tower_name.text = tower.tower_name
	tower_image.texture = tower.image

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
	self.visible = false
	
	
