extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius

func _init() -> void:
	super()
	tower_name = Towers.GRAPESHOT_NAME
	description = Towers.GRAPESHOT_DESCRIPTION
	cost = Towers.GRAPESHOT_COST
	cooldown = Towers.GRAPESHOT_COOLDOWN
	damage_scale = Towers.GRAPESHOT_DAMAGE_PERCENTAGE
	shot_count = Towers.GRAPESHOT_SHOT_COUNT
	bullet_speed = Towers.GRAPESHOT_SPEED_PERCENTAGE
	shot_timer = cooldown
	bullet_scale = Towers.GRAPESHOT_BULLET_SCALE
	image = Towers.GRAPESHOT_IMAGE
	angle_offset = 90.0
	scene_path = Towers.GRAPESHOT_SCENE_PATH

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)
