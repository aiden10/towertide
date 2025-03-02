extends Sentry

@onready var sprite: Sprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius
@onready var aim_laser: Line2D = $AimLaser
@onready var barrel: Marker2D = $Marker2D

func _init() -> void:
	super()
	tower_name = Towers.SNIPER_NAME
	description = Towers.SNIPER_DESCRIPTION
	cost = Towers.SNIPER_COST
	cooldown = Towers.SNIPER_COOLDOWN
	damage_scale = Towers.SNIPER_DAMAGE_PERCENTAGE
	shot_timer = cooldown
	bullet_scale = Towers.SNIPER_BULLET_SCALE
	bullet_speed = Towers.SNIPER_SPEED_PERCENTAGE
	image = Towers.SNIPER_IMAGE
	angle_offset = 90.0
	scene_path = Towers.SNIPER_SCENE_PATH

func _physics_process(delta: float) -> void:
	var effective_cooldown = cooldown * PlayerState.firerate
	var progress = 1.0 - (shot_timer / effective_cooldown)
	var alpha = int(progress * 255)
	aim_laser.modulate = Color8(255, 255, 255, alpha)

	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = effective_cooldown
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)

	aim_laser.clear_points()
	
	if target_enemy_position == Vector2.ZERO:
		aim_laser.visible = false
	else:
		look_at(target_enemy_position)
		rotation_degrees += angle_offset
		aim_laser.visible = true
		aim_laser.add_point(barrel.position)
		aim_laser.add_point(to_local(target_enemy_position))
		target_enemy_position = Vector2.ZERO
