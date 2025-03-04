extends Spawner

var spawn_amount = Towers.PERSON_SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.PERSON_SPAWNER_NAME
	description = Towers.PERSON_SPAWNER_DESCRIPTION
	cost = Towers.PERSON_SPAWNER_COST
	image = Towers.PERSON_SPAWNER_IMAGE
	minion_scene = Towers.person_minion_scene
	cooldown = Towers.PERSON_SPAWNER_COOLDOWN
	scene_path = Towers.PERSON_SPAWNER_SCENE_PATH
	spawn_limit = Towers.PERSON_SPAWNER_SPAWN_LIMIT
	
	upgrade1_name = Towers.DRIFTER_SPAWNER_NAME
	upgrade1_description = Towers.DRIFTER_SPAWNER_DESCRIPTION
	upgrade1_price = Towers.DRIFTER_SPAWNER_COST
	upgrade1_image = Towers.DRIFTER_SPAWNER_IMAGE
	upgrade1_scene = Scenes.drifter_spawner_tower_scene
	
	upgrade2_name = Towers.KIDNAPPER_SPAWNER_NAME
	upgrade2_description = Towers.KIDNAPPER_SPAWNER_DESCRIPTION
	upgrade2_price = Towers.KIDNAPPER_SPAWNER_COST
	upgrade2_image = Towers.KIDNAPPER_SPAWNER_IMAGE
	upgrade2_scene = Scenes.kidnapper_spawner_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.PERSON_MIN_WANDER)
		
