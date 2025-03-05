extends Pylon

@onready var slowing_field: Area2D = $ConnectRadius
var enemy_connections = []

func _init() -> void:
	super()
	tower_name = Towers.CHAIN_PYLON_NAME
	description = Towers.CHAIN_PYLON_DESCRIPTION
	cost = Towers.CHAIN_PYLON_COST
	value = cost
	cooldown = Towers.CHAIN_PYLON_COOLDOWN
	shot_timer = cooldown
	damage_scale = Towers.CHAIN_PYLON_DAMAGE
	image = Towers.CHAIN_PYLON_IMAGE
	scene_path = Towers.CHAIN_PYLON_SCENE_PATH

func _ready() -> void:
	connect_radius.area_entered.connect(connect_radius_entered)
	connect_radius.area_exited.connect(connect_radius_exited)

func _physics_process(delta: float) -> void:
	shot_timer -= delta
	if shot_timer <= 0:
		shot_timer = cooldown
		can_hit = true
	
	for connection in connections:
		var overlaps = connection["hitbox"].get_overlapping_areas()
		for area in overlaps:
			check_fence_collision(area, connection["line"])
	
	for i in range(enemy_connections.size() - 1, -1, -1):
		var connection = enemy_connections[i]
		var enemy1 = connection["enemy1"]
		var enemy2 = connection["enemy2"]
		var line = connection["line"]
		
		if is_instance_valid(enemy1) and is_instance_valid(enemy2):
			line.clear_points()
			line.add_point(enemy1.global_position - global_position)
			line.add_point(enemy2.global_position - global_position)
			
			var line_hitbox = connection.get("hitbox")
			if line_hitbox:
				var overlaps = line_hitbox.get_overlapping_areas()
				for area in overlaps:
					check_fence_collision(area, line)
		else:
			if line:
				line.queue_free()
			enemy_connections.remove_at(i)

func create_enemy_line(enemy1: Node2D, enemy2: Node2D) -> void:
	var attack_line = Line2D.new()
	attack_line.width = 1.5
	attack_line.default_color = Color(0.2, 0.5, 1, 0.6)
	
	attack_line.add_point(enemy1.global_position - global_position)
	attack_line.add_point(enemy2.global_position - global_position)
	add_child(attack_line)
	
	var line_hitbox = Area2D.new()
	line_hitbox.collision_layer = 1 
	line_hitbox.collision_mask = 1
	
	var shape = CapsuleShape2D.new()
	var distance = enemy1.global_position.distance_to(enemy2.global_position)
	shape.height = distance
	shape.radius = 5
	
	var collision = CollisionShape2D.new()
	collision.shape = shape
	collision.rotation = enemy1.global_position.angle_to_point(enemy2.global_position) + PI/2
	collision.position = (enemy2.global_position - enemy1.global_position) / 2
	
	line_hitbox.add_child(collision)
	call_deferred("add_child", line_hitbox)
	
	enemy_connections.append({
		"enemy1": enemy1,
		"enemy2": enemy2,
		"line": attack_line,
		"hitbox": line_hitbox
	})

func update_enemy_connections() -> void:
	var enemies_in_radius = []
	var overlapping_areas = connect_radius.get_overlapping_areas()
	for area in overlapping_areas:
		var enemy = area.get_parent()
		if enemy.is_in_group("Enemies"):
			enemies_in_radius.append(enemy)
	
	for i in range(enemy_connections.size() - 1, -1, -1):
		var connection = enemy_connections[i]
		var enemy1 = connection["enemy1"]
		var enemy2 = connection["enemy2"]
		
		if (!enemies_in_radius.has(enemy1) or !enemies_in_radius.has(enemy2) or 
			!is_instance_valid(enemy1) or !is_instance_valid(enemy2)):
			if connection["line"]:
				connection["line"].queue_free()
			if connection.get("hitbox"):
				connection["hitbox"].queue_free()
			enemy_connections.remove_at(i)
	
	if enemies_in_radius.size() > 1:
		for i in range(enemies_in_radius.size() - 1):
			for j in range(i + 1, enemies_in_radius.size()):
				var enemy1 = enemies_in_radius[i]
				var enemy2 = enemies_in_radius[j]
				
				var connection_exists = false
				for existing_connection in enemy_connections:
					if (existing_connection["enemy1"] == enemy1 and existing_connection["enemy2"] == enemy2) or \
					   (existing_connection["enemy1"] == enemy2 and existing_connection["enemy2"] == enemy1):
						connection_exists = true
						break
				
				if !connection_exists:
					create_enemy_line(enemy1, enemy2)

func connect_radius_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Pylons") and not is_connected_to(parent):
		create_line(parent.position, parent)

	update_enemy_connections()

func connect_radius_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Enemies"):
		update_enemy_connections()

func _exit_tree() -> void:
	for connection in enemy_connections:
		if connection["line"]:
			connection["line"].queue_free()
		if connection.get("hitbox"):
			connection["hitbox"].queue_free()
	
	for pylon_tower in get_tree().get_nodes_in_group("Pylons"):
		for i in range(pylon_tower.connections.size() - 1, -1, -1):
			var connection = pylon_tower.connections[i]
			if connection["parent"] == self:
				if connection["line"]:
					connection["line"].queue_free()
				if connection["hitbox"]:
					connection["hitbox"].queue_free()
				pylon_tower.connections.remove_at(i)
