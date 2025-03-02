extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius

func _init() -> void:
	super()
	tower_name = Towers.SENTRY_NAME
	description = Towers.SENTRY_DESCRIPTION
	cost = Towers.SENTRY_COST
	cooldown = Towers.SENTRY_COOLDOWN
	damage_scale = Towers.SENTRY_DAMAGE_PERCENTAGE
	bullet_speed = Towers.SENTRY_SPEED_PERCENTAGE
	shot_timer = cooldown
	image = Towers.SENTRY_IMAGE
	angle_offset = 90.0
	scene_path = Towers.SENTRY_SCENE_PATH
	
	upgrade1_name = Towers.MACHINE_GUN_NAME
	upgrade1_description = Towers.MACHINE_GUN_DESCRIPTION
	upgrade1_price = Towers.MACHINE_GUN_COST
	upgrade1_image = Towers.MACHINE_GUN_IMAGE
	upgrade1_scene = Scenes.machine_gun_tower_scene

	upgrade2_name = Towers.SNIPER_NAME
	upgrade2_description = Towers.SNIPER_DESCRIPTION
	upgrade2_price = Towers.SNIPER_COST
	upgrade2_image = Towers.SNIPER_IMAGE
	upgrade2_scene = Scenes.sniper_tower_scene

	upgrade3_name = Towers.SHOTGUN_NAME
	upgrade3_description = Towers.SHOTGUN_DESCRIPTION
	upgrade3_price = Towers.SHOTGUN_COST
	upgrade3_image = Towers.SHOTGUN_IMAGE
	upgrade3_scene = Scenes.shotgun_tower_scene

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)
