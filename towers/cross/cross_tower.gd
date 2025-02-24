extends Tower

@onready var sprite: AnimatedSprite2D = $Sprite

var is_cross_pattern: bool = true  
var current_frame: int = 0

func _ready() -> void:
	tower_name = Towers.CROSS_NAME
	cost = Towers.CROSS_COST
	cooldown = Towers.CROSS_COOLDOWN
	shot_timer = cooldown
	image = Towers.CROSS_IMAGE
	scene_path = Towers.CROSS_SCENE_PATH
	## Add upgrades here
	
func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		shoot_pattern()
		is_cross_pattern = !is_cross_pattern  # Toggle pattern for next shot
		current_frame = (current_frame + 1) % sprite.sprite_frames.get_frame_count("default")
	
	if current_frame != 0 and current_frame != 4:
		current_frame = (current_frame + 1) % sprite.sprite_frames.get_frame_count("default")
	
	sprite.frame = current_frame

func shoot_pattern() -> void:
	var angles: Array
	EventBus.tower_shot.emit()
	if is_cross_pattern:
		# Cross pattern: up, right, down, left (0°, 90°, 180°, 270°)
		angles = [0, PI/2, PI, 3*PI/2]
	else:
		# X pattern: 45°, 135°, 225°, 315°
		angles = [PI/4, 3*PI/4, 5*PI/4, 7*PI/4]

	for angle in angles:
		shoot_at_angle(angle)

func shoot_at_angle(angle: float) -> void:
	var bullet = Scenes.player_projectile_scene.instantiate()
	GameState.player_projectiles[bullet] = 1
	bullet.position = position
	
	# Calculate target position using angle
	var target_position = position + Vector2.RIGHT.rotated(angle) * 100
	bullet.start(target_position, PlayerState.projectile_speed * Towers.CROSS_SPEED_PERCENTAGE, PlayerState.damage * Towers.CROSS_DAMAGE_PERCENTAGE, self)
	EventBus.arena_spawn.emit(bullet)	
