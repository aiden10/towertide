extends Spawner

var spawn_amount = Towers.SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.SPAWNER_NAME
	description = Towers.SPAWNER_DESCRIPTION
	cost = Towers.SPAWNER_COST
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

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.CHARGER_MIN_WANDER)
		
