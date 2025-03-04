extends Spawner

var spawn_amount = Towers.DRIFTER_SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.DRIFTER_SPAWNER_NAME
	description = Towers.DRIFTER_SPAWNER_DESCRIPTION
	cost = Towers.DRIFTER_SPAWNER_COST
	value = cost
	image = Towers.DRIFTER_SPAWNER_IMAGE
	minion_scene = Towers.drifter_minion_scene
	cooldown = Towers.DRIFTER_SPAWNER_COOLDOWN
	scene_path = Towers.DRIFTER_SPAWNER_SCENE_PATH
	spawn_limit = Towers.DRIFTER_SPAWNER_SPAWN_LIMIT

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.DRIFTER_MIN_WANDER)
		
