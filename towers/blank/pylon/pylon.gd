extends Tower
class_name Pylon

@onready var connect_radius: Area2D = $ConnectRadius
var can_hit: bool = true
var connections = []

func _init() -> void:
	base_type = 4
	super()

func _ready() -> void:
	connect_radius.area_entered.connect(connect_radius_entered)

func is_connected_to(pylon) -> bool:
	for connection in connections:
		if connection.pylon == pylon:
			return true
	return false

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

func check_fence_collision(body: Area2D, attack_line: Line2D):
	if can_hit and body.get_parent().is_in_group("Enemies"):
		var flicker_tween = create_tween()
		flicker_tween.tween_property(attack_line, "modulate", Color(1, 1, 1.5, 0.3), 0.2)
		flicker_tween.tween_property(attack_line, "modulate", Color(1, 1, 1, 1), 0.4)
		Utils.spawn_hit_effect(Color(0, 0.5, 2, 1), body.global_position, max(5, PlayerState.damage * Towers.PYLON_DAMAGE))
		body.get_parent().take_damage(damage_scale * PlayerState.damage, self)
		can_hit = false

func _exit_tree() -> void:
	for pylon_tower in get_tree().get_nodes_in_group("Pylons"):
		for i in range(pylon_tower.connections.size() - 1, 0, -1):
			var connection = pylon_tower.connections[i]
			if connection["pylon"] == self:
				if connection["line"]:
					connection["line"].queue_free()
				if connection["hitbox"]:
					connection["hitbox"].queue_free()
				pylon_tower.connections.remove_at(i)
