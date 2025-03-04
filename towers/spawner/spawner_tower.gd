extends Spawner

var spawn_amount = Towers.SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.SPAWNER_NAME
	description = Towers.SPAWNER_DESCRIPTION
	cost = Towers.SPAWNER_COST
	value = cost
	image = Towers.SPAWNER_IMAGE
	minion_scene = Towers.charger_minion_scene
	cooldown = Towers.SPAWNER_COOLDOWN
	scene_path = Towers.SPAWNER_SCENE_PATH
	spawn_limit = Towers.SPAWNER_SPAWN_LIMIT
	
	upgrade1_name = Towers.SHOOTER_SPAWNER_NAME
	upgrade1_description = Towers.SHOOTER_SPAWNER_DESCRIPTION
	upgrade1_price = Towers.SHOOTER_SPAWNER_COST
	upgrade1_image = Towers.SHOOTER_SPAWNER_IMAGE
	upgrade1_scene = Scenes.shooter_spawner_tower_scene
	
	upgrade2_name = Towers.PERSON_SPAWNER_NAME
	upgrade2_description = Towers.PERSON_SPAWNER_DESCRIPTION
	upgrade2_price = Towers.PERSON_SPAWNER_COST
	upgrade2_image = Towers.PERSON_SPAWNER_IMAGE
	upgrade2_scene = Scenes.person_spawner_tower_scene

	upgrade3_name = Towers.BUG_SPAWNER_NAME
	upgrade3_description = Towers.BUG_SPAWNER_DESCRIPTION
	upgrade3_price = Towers.BUG_SPAWNER_COST
	upgrade3_image = Towers.BUG_SPAWNER_IMAGE
	upgrade3_scene = Scenes.bug_spawner_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.CHARGER_MIN_WANDER)
		
