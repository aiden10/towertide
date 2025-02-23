extends Spawner

var spawn_amount = Towers.SPAWNER_SPAWN_AMOUNT

func _ready() -> void:
	minion_scene = null

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		spawn_minions(spawn_amount)
		
