extends Spawner

var spawn_amount = Towers.KIDNAPPER_SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.KIDNAPPER_SPAWNER_NAME
	description = Towers.KIDNAPPER_SPAWNER_DESCRIPTION
	cost = Towers.KIDNAPPER_SPAWNER_COST
	image = Towers.KIDNAPPER_SPAWNER_IMAGE
	minion_scene = Towers.kidnapper_minion_scene
	cooldown = Towers.KIDNAPPER_SPAWNER_COOLDOWN
	scene_path = Towers.KIDNAPPER_SPAWNER_SCENE_PATH
	spawn_limit = Towers.KIDNAPPER_SPAWNER_SPAWN_LIMIT

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.KIDNAPPER_MIN_WANDER)
		
