extends Pylon

@onready var slowing_field: Area2D = $ConnectRadius

func _init() -> void:
	super()
	tower_name = Towers.SLOWING_PYLON_NAME
	description = Towers.SLOWING_PYLON_DESCRIPTION
	cost = Towers.SLOWING_PYLON_COST
	cooldown = Towers.SLOWING_PYLON_COOLDOWN
	shot_timer = cooldown
	damage_scale = Towers.SLOWING_PYLON_DAMAGE
	image = Towers.SLOWING_PYLON_IMAGE
	scene_path = Towers.SLOWING_PYLON_SCENE_PATH

func _ready() -> void:
	connect_radius.area_entered.connect(connect_radius_entered)
	connect_radius.area_entered.connect(_on_slow_radius_entered)
	connect_radius.area_exited.connect(_on_slow_radius_exited)

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_hit = true
	for connection in connections:
		var overlaps = connection["hitbox"].get_overlapping_areas()
		for area in overlaps:
			check_fence_collision(area, connection["line"])

func _on_slow_radius_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyProjectiles"):
		area.speed /= 2
		
func _on_slow_radius_exited(area: Area2D) -> void:
	if area.is_in_group("EnemyProjectiles"):
		Utils.spawn_hit_effect(Color8(0, 255, 510, 255), area.global_position, 3)
		area.speed *= 2
		
