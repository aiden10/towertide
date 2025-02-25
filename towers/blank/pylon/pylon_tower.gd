extends Pylon

func _init() -> void:
	super()
	tower_name = Towers.PYLON_NAME
	cost = Towers.PYLON_COST
	cooldown = Towers.PYLON_COOLDOWN
	shot_timer = cooldown
	image = Towers.PYLON_IMAGE
	scene_path = Towers.PYLON_SCENE_PATH

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
