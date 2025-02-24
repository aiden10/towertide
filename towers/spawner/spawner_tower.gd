extends Spawner

var spawn_amount = Towers.SPAWNER_SPAWN_AMOUNT

func _ready() -> void:
	tower_name = Towers.SPAWNER_NAME
	cost = Towers.SPAWNER_COST
	image = Towers.SPAWNER_IMAGE
	minion_scene = Towers.charger_minion_scene
	cooldown = Towers.SPAWNER_COOLDOWN
	scene_path = Towers.SPAWNER_SCENE_PATH

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		if (get_child_count() - 4) < Towers.SPAWNER_LIMIT:
			spawn_minions(spawn_amount, Towers.CHARGER_MIN_WANDER)
		
