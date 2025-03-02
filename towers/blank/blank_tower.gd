extends Tower

func _ready() -> void:
	base_type = 4
	tower_name = Towers.BLANK_NAME
	description = Towers.BLANK_DESCRIPTION
	cost = Towers.BLANK_COST
	image = Towers.BLANK_IMAGE
	scene_path = Towers.BLANK_SCENE_PATH
	
	upgrade1_name = Towers.GOLD_DISPENSER_NAME
	upgrade1_description = Towers.GOLD_DISPENSER_DESCRIPTION
	upgrade1_price = Towers.GOLD_DISPENSER_COST
	upgrade1_image = Towers.GOLD_DISPENSER_IMAGE
	upgrade1_scene = Scenes.gold_dispenser_tower_scene
	
	upgrade2_name = Towers.PYLON_NAME
	upgrade2_description = Towers.PYLON_DESCRIPTION
	upgrade2_price = Towers.PYLON_COST
	upgrade2_image = Towers.PYLON_IMAGE
	upgrade2_scene = Scenes.pylon_tower_scene
	
	upgrade3_name = Towers.SUPPORTER_NAME
	upgrade3_description = Towers.SUPPORTER_DESCRIPTION
	upgrade3_price = Towers.SUPPORTER_COST
	upgrade3_image = Towers.SUPPORTER_IMAGE
	upgrade3_scene = Scenes.supporter_tower_scene
	
