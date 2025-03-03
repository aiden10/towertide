extends Spawner

@onready var core_sprite: Sprite2D = $CoreSprite

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

func _ready() -> void:
	var pulse_tween = create_tween()
	pulse_tween.set_loops(-1)
	pulse_tween.set_trans(Tween.TRANS_SINE)
	pulse_tween.set_ease(Tween.EASE_IN_OUT)
	
	pulse_tween.tween_property(core_sprite, "scale", Vector2(0.13, 0.13), 5)
	pulse_tween.parallel().tween_property(core_sprite, "modulate", Color(2, 2, 0.5, 0.8), 5)
	
	pulse_tween.tween_property(core_sprite, "scale", Vector2(0.15, 0.15), 5)
	pulse_tween.parallel().tween_property(core_sprite, "modulate", Color(1, 1, 1, 0.5), 5)

func _process(delta: float) -> void:
	var effective_cooldown = cooldown

	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = effective_cooldown
		if (get_child_count() - 5) < spawn_limit:
			spawn_minions(spawn_amount, Towers.SHOOTER_MIN_WANDER)
		
