extends Spawner

var spawn_amount = Towers.DRIFTER_SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.DRIFTER_SPAWNER_NAME
	description = Towers.DRIFTER_SPAWNER_DESCRIPTION
	cost = Towers.DRIFTER_SPAWNER_COST
	image = Towers.DRIFTER_SPAWNER_IMAGE
	minion_scene = Towers.drifter_minion_scene
	cooldown = Towers.DRIFTER_SPAWNER_COOLDOWN
	scene_path = Towers.DRIFTER_SPAWNER_SCENE_PATH
	spawn_limit = Towers.DRIFTER_SPAWNER_SPAWN_LIMIT
	
	upgrade1_name = Towers.KIDNAPPER_SPAWNER_NAME
	upgrade1_description = Towers.KIDNAPPER_SPAWNER_DESCRIPTION
	upgrade1_price = Towers.KIDNAPPER_SPAWNER_COST
	upgrade1_image = Towers.KIDNAPPER_SPAWNER_IMAGE
	upgrade1_scene = Scenes.kidnapper_spawner_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.DRIFTER_MIN_WANDER)
		
