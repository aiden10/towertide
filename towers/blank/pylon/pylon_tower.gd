extends Pylon

func _init() -> void:
	super()
	tower_name = Towers.PYLON_NAME
	description = Towers.PYLON_DESCRIPTION
	cost = Towers.PYLON_COST
	cooldown = Towers.PYLON_COOLDOWN
	shot_timer = cooldown
	damage_scale = Towers.PYLON_DAMAGE
	image = Towers.PYLON_IMAGE
	scene_path = Towers.PYLON_SCENE_PATH
	
	upgrade1_name = Towers.SLOWING_PYLON_NAME
	upgrade1_description = Towers.SLOWING_PYLON_DESCRIPTION
	upgrade1_price = Towers.SLOWING_PYLON_COST
	upgrade1_scene = Scenes.slowing_pylon_tower_scene

func _ready() -> void:
	connect_radius.area_entered.connect(connect_radius_entered)

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_hit = true
	for connection in connections:
		var overlaps = connection["hitbox"].get_overlapping_areas()
		for area in overlaps:
			check_fence_collision(area, connection["line"])
