extends Tower

@onready var connect_radius: Area2D = $ConnectRadius
var can_hit: bool = true
var connections = []

func _ready() -> void:
	tower_name = Towers.PYLON_NAME
	cost = Towers.PYLON_COST
	cooldown = Towers.PYLON_COOLDOWN
	shot_timer = cooldown
	image = Towers.PYLON_IMAGE
	scene_path = Towers.PYLON_SCENE_PATH
	connect_radius.area_entered.connect(connect_radius_entered)

func connect_radius_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Pylons") and not is_connected_to(parent):
		var attack_line = Line2D.new()
		attack_line.width = 2.0
		attack_line.default_color = Color(0.5, 0.8, 1.0, 0.8)
		
		attack_line.add_point(Vector2.ZERO)
		attack_line.add_point(parent.position - position)
		add_child(attack_line)
				
		var fence_hitbox = Area2D.new()
		fence_hitbox.collision_layer = 1 
		fence_hitbox.collision_mask = 1
		
		var shape = CapsuleShape2D.new()
		var distance = position.distance_to(parent.position)
		shape.height = distance
		shape.radius = 5
		
		var collision = CollisionShape2D.new()
		collision.shape = shape
		collision.rotation = position.angle_to_point(parent.position) + PI/2
		collision.position = (parent.position - position) / 2
		
		fence_hitbox.add_child(collision)
		call_deferred("add_child", fence_hitbox)
				
		connections.append({
			"pylon": parent,
			"line": attack_line,
			"hitbox": fence_hitbox
		})

func is_connected_to(pylon) -> bool:
	for connection in connections:
		if connection.pylon == pylon:
			return true
	return false

func check_fence_collision(body: Area2D):
	if can_hit and body.get_parent().is_in_group("Enemies"):
		Utils.spawn_hit_effect(Color(0, 0.5, 2, 1), body.global_position, max(5, PlayerState.damage * Towers.PYLON_DAMAGE))
		body.get_parent().take_damage(Towers.PYLON_DAMAGE * PlayerState.damage, self)
		can_hit = false

func _process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown * PlayerState.firerate
		can_hit = true
	for connection in connections:
		var overlaps = connection["hitbox"].get_overlapping_areas()
		for area in overlaps:
			check_fence_collision(area)
