extends Sentry

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var attack_radius: Area2D = $AttackRadius
var current_frame: int = 0

func _init() -> void:
	super()
	tower_name = Towers.MACHINE_GUN_NAME
	description = Towers.MACHINE_GUN_DESCRIPTION
	cost = Towers.MACHINE_GUN_COST
	cooldown = Towers.MACHINE_GUN_COOLDOWN
	shot_timer = cooldown
	image = Towers.MACHINE_GUN_IMAGE
	angle_offset = 90.0
	scene_path = Towers.MACHINE_GUN_SCENE_PATH

func enemy_detected(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		if can_shoot:
			shoot(parent.global_position, angle_offset)
			current_frame = (current_frame + 1) % sprite.sprite_frames.get_frame_count("default")
			sprite.frame = current_frame

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_shoot = true
	for area in attack_radius.get_overlapping_areas():
		enemy_detected(area)
