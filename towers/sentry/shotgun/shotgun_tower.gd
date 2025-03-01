extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius

func _init() -> void:
	super()
	tower_name = Towers.SHOTGUN_NAME
	description = Towers.SHOTGUN_DESCRIPTION
	cost = Towers.SHOTGUN_COST
	cooldown = Towers.SHOTGUN_COOLDOWN
	damage_scale = Towers.SHOTGUN_DAMAGE_PERCENTAGE
	shot_count = Towers.SHOTGUN_SHOT_COUNT
	bullet_speed = Towers.SHOTGUN_SPEED_PERCENTAGE
	shot_timer = cooldown
	bullet_scale = Towers.SHOTGUN_BULLET_SCALE
	image = Towers.SHOTGUN_IMAGE
	angle_offset = 90.0
	scene_path = Towers.SHOTGUN_SCENE_PATH

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)
