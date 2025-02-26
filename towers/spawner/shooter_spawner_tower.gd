extends Spawner

var spawn_amount = Towers.SHOOTER_SPAWNER_SPAWN_AMOUNT

func _init() -> void:
	super()
	tower_name = Towers.SHOOTER_SPAWNER_NAME
	description = Towers.SHOOTER_SPAWNER_DESCRIPTION
	cost = Towers.SHOOTER_SPAWNER_COST
	image = Towers.SHOOTER_SPAWNER_IMAGE
	minion_scene = Towers.shooter_minion_scene
	cooldown = Towers.SHOOTER_SPAWNER_COOLDOWN
	scene_path = Towers.SHOOTER_SPAWNER_SCENE_PATH
	spawn_limit = Towers.SHOOTER_SPAWNER_SPAWN_LIMIT

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		if (get_child_count() - 4) < spawn_limit:
			spawn_minions(spawn_amount, Towers.SHOOTER_MIN_WANDER)
		
