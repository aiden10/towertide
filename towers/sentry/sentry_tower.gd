extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius

func _ready() -> void:
	tower_name = Towers.SENTRY_NAME
	cost = Towers.SENTRY_COST
	cooldown = Towers.SENTRY_COOLDOWN
	shot_timer = cooldown
	image = Towers.SENTRY_IMAGE
	angle_offset = 90.0
	scene_path = Towers.SENTRY_SCENE_PATH
	## Add upgrades here

func enemy_detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		if can_shoot:
			shoot(parent.global_position, angle_offset)

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)
