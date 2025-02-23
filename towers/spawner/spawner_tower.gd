extends Spawner

var spawn_amount = Towers.SPAWNER_SPAWN_AMOUNT

func _ready() -> void:
	minion_scene = Towers.CHARGER_MINION_SCENE
	cooldown = Towers.SPAWNER_COOLDOWN

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		spawn_minions(spawn_amount, Towers.CHARGER_MIN_WANDER)
		
