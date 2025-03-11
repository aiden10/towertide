extends Node

var damage_label_font: Font = load("res://resources/VastShadow-Regular.ttf")

func toggle_fullscreen() -> void:
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)
	get_window().content_scale_factor = 1.0 if is_window else 0.6
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

func get_random_position_in_radius(center: Vector2, radius: float, min_distance: float = 0) -> Vector2:
	var random_angle = randf() * 2 * PI	
	var random_radius = sqrt(randf()) * (radius - min_distance) + min_distance
	return center + Vector2(
		cos(random_angle) * random_radius,
		sin(random_angle) * random_radius
	)

func weighted_random_choice(weights: Array, choices: Array):
	assert(weights.size() == choices.size(), "Weights and choices arrays must be the same size")
	assert(weights.size() > 0, "Arrays cannot be empty")
	
	var sum_of_weight = 0.0
	for weight in weights:
		sum_of_weight += weight
	var rnd = randf() * sum_of_weight    
	for i in range(weights.size()):
		if rnd < weights[i]:
			return choices[i]
		rnd -= weights[i]
	
func spawn_hit_effect(color: Color, position: Vector2, damage: float) -> void:
	var adjusted_damage = min(3, damage)
	var hit_effect = Scenes.hit_effect_scene.instantiate()
	hit_effect.global_position = position
	hit_effect.set_properties(color, adjusted_damage)
	EventBus.arena_spawn.emit(hit_effect)

func spawn_damage_text(location: Vector2, damage_taken: int) -> void:
	var damage_label = Label.new()
	damage_label.text = str(int(damage_taken))
	damage_label.position = Vector2(randf_range(-20, 20), -30)
	damage_label.z_index = 100
	damage_label.add_theme_font_override("font", damage_label_font)
	damage_label.custom_minimum_size = Vector2(40, 20)
	
	if damage_taken < 5:
		damage_label.modulate = Color(1, 1, 1) # White for small damage
	elif damage_taken < 10:
		damage_label.modulate = Color(1, 0.3, 0.3) # Red for medium damage
	elif damage_taken < 16:
		damage_label.modulate = Color(1, 0.65, 0.2) # Orange for high damage
	else:
		damage_label.modulate = Color(1, 1, 0.3) # Yellow for very high damage
	
	var scale_factor = max(1.0, log(damage_taken) * 0.5)
	damage_label.scale = Vector2(scale_factor, scale_factor)

	EventBus.arena_spawn.emit(damage_label)
	damage_label.global_position = location
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(damage_label, "global_position:y", location.y - 40, 0.6)
	tween.tween_property(damage_label, "modulate:a", 0.0, 0.6)
	tween.tween_property(damage_label, "scale", damage_label.scale * 1.5, 0.2)
	tween.chain().tween_callback(damage_label.queue_free)

func get_action_key_name(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	
	if events.size() > 0:
		var event = events[0]
		if event is InputEventKey:
			return OS.get_keycode_string(event.physical_keycode)

	return "None"

func reset_states() -> void:
	TowerManager.clear_towers()
	GameState.stage = GameConstants.DEFAULT_STAGE
	GameState.clear_condition = GameConstants.DEFAULT_CLEAR_CONDITION
	GameState.door_position = GameConstants.DEFAULT_DOOR_POSITION
	GameState.player_position = GameConstants.DEFAULT_PLAYER_POSITION
	GameState.enemies_killed_this_stage = GameConstants.DEFAULT_ENEMIES_KILLED_THIS_STAGE
	GameState.enemies_spawning = GameConstants.DEFAULT_ENEMIES_SPAWNING
	GameState.level_cleared = GameConstants.DEFAULT_LEVEL_CLEARED
	GameState.boss_stage_increment = GameConstants.DEFAULT_BOSS_STAGE_INCREMENT
	GameState.player_projectiles.clear()
	GameState.selected_tower = null
	GameState.enemy_counts = {}
	GameState.tower_type = 0
	GameState.allocate_menu_up = false
	GameState.wave_started = false
	GameState.is_boss_stage = false
	GameState.boss_dead = false

	PlayerState.level = PlayerConstants.DEFAULT_LEVEL
	PlayerState.gold = PlayerConstants.DEFAULT_GOLD
	PlayerState.xp = PlayerConstants.DEFAULT_XP
	PlayerState.damage = PlayerConstants.DEFAULT_DAMAGE
	PlayerState.speed = PlayerConstants.DEFAULT_SPEED
	PlayerState.health = PlayerConstants.DEFAULT_HEALTH
	PlayerState.max_health = PlayerConstants.DEFAULT_MAX_HEALTH
	PlayerState.firerate = PlayerConstants.DEFAULT_FIRERATE
	PlayerState.projectile_speed = PlayerConstants.DEFAULT_PROJECTILE_SPEED
	PlayerState.knockback = PlayerConstants.DEFAULT_KNOCKBACK
	PlayerState.pierce = PlayerConstants.DEFAULT_PIERCE
	PlayerState.bullet_size = PlayerConstants.DEFAULT_BULLET_SIZE
	PlayerState.regen = PlayerConstants.DEFAULT_REGEN
	PlayerState.regen_cooldown = PlayerConstants.DEFAULT_REGEN_COOLDOWN
	PlayerState.sprayer_limit = PlayerConstants.DEFAULT_SPRAYER_LIMIT
	PlayerState.sprayer_count = 0
	PlayerState.sentry_limit = PlayerConstants.DEFAULT_SENTRY_LIMIT
	PlayerState.sentry_count = 0
	PlayerState.blank_limit = PlayerConstants.DEFAULT_BLANK_LIMIT
	PlayerState.blank_count = 0
	PlayerState.spawner_limit = PlayerConstants.DEFAULT_SPAWNER_LIMIT
	PlayerState.spawner_count = 0
	
	PlayerState.levels_available = PlayerConstants.DEFAULT_LEVELS_AVAILABLE
	PlayerState.player_items.clear()
	PlayerState.item_counts.clear()
	PlayerState.level_up_condition = PlayerConstants.DEFAULT_LEVEL_UP_CONDITION
	PlayerState.enemies_killed = PlayerConstants.DEFAULT_ENEMIES_KILLED
	
	PickupManager.clear_pools()

func wipe_saved_game() -> void:
	if FileAccess.file_exists("res://save/save.json"):
		DirAccess.remove_absolute("res://save/save.json")

func save_game() -> void:
	DirAccess.make_dir_recursive_absolute("res://save")
	var towers = get_tree().get_nodes_in_group("Towers")
	for tower in towers:
		TowerManager.save_tower(tower)

	var save_dict = {
		# Player Stats
		"level": PlayerState.level,
		"gold": PlayerState.gold,
		"xp": PlayerState.xp,
		"damage": PlayerState.damage,
		"speed": PlayerState.speed,
		"health": PlayerState.health,
		"max_health": PlayerState.max_health,
		"firerate": PlayerState.firerate,
		"projectile_speed": PlayerState.projectile_speed,
		"knockback": PlayerState.knockback,
		"pierce": PlayerState.pierce,
		"bullet_size": PlayerState.bullet_size,
		"regen": PlayerState.regen,
		"regen_cooldown": PlayerState.regen_cooldown,
		"sprayer_limit": PlayerState.sprayer_limit,
		"sentry_limit": PlayerState.sentry_limit,
		"blank_limit": PlayerState.blank_limit,
		"spawner_limit": PlayerState.spawner_limit,
		"minimum_gold": PlayerState.minimum_gold,
		"sprayer_count": PlayerState.sprayer_count,
		"sentry_count": PlayerState.sentry_count,
		"blank_count": PlayerState.blank_count,
		"spawner_count": PlayerState.spawner_count,
		
		# Player Progression
		"levels_available": PlayerState.levels_available,
		"item_counts": PlayerState.item_counts,
		"level_up_condition": PlayerState.level_up_condition,
		"enemies_killed": PlayerState.enemies_killed,
		"towers": [],
		
		# Game State
		"stage": GameState.stage,
		"clear_condition": GameState.clear_condition,
		"door_position": {
			"x": GameState.door_position.x,
			"y": GameState.door_position.y
		},
		"player_position": {
			"x": GameState.player_position.x,
			"y": GameState.player_position.y
		},
		"enemies_killed_this_stage": GameState.enemies_killed_this_stage,
		"enemies_spawning": GameState.enemies_spawning,
		"level_cleared": GameState.level_cleared,
		"wave_started": GameState.wave_started,
		"is_boss_stage": GameState.is_boss_stage
	}
	for tower in TowerManager.active_towers:
		var tower_data = {
			"tower_scene": tower.scene_path, 
			"position": {
				"x": tower.position.x,
				"y": tower.position.y
			},
			"kills": tower.kills
		}
		save_dict["towers"].append(tower_data)
		
	var save_file := FileAccess.open("res://save/save.json", FileAccess.WRITE)
	var json_string = JSON.stringify(save_dict)
	save_file.store_string(json_string)
	save_file.close()
		
func load_game() -> void:
	if not FileAccess.file_exists("res://save/save.json"):
		push_error("No save file found!")
		return
		
	var save_file := FileAccess.open("res://save/save.json", FileAccess.READ)
	var save_data = JSON.parse_string(save_file.get_as_text())
	save_file.close()
		
	var towers_data = save_data["towers"]
	for tower_data in towers_data:
		var tower_scene = tower_data["tower_scene"]
		var tower_position = Vector2(tower_data["position"]["x"], tower_data["position"]["y"])
		var kills = tower_data["kills"]
		TowerManager.active_towers.append(TowerData.new(tower_scene, tower_position, kills))

	PlayerState.level = save_data["level"]
	PlayerState.gold = save_data["gold"]
	PlayerState.xp = save_data["xp"]
	PlayerState.damage = save_data["damage"]
	PlayerState.speed = save_data["speed"]
	PlayerState.health = save_data["health"]
	PlayerState.max_health = save_data["max_health"]
	PlayerState.firerate = save_data["firerate"]
	PlayerState.projectile_speed = save_data["projectile_speed"]
	PlayerState.knockback = save_data["knockback"]
	PlayerState.pierce = save_data["pierce"]
	PlayerState.bullet_size = save_data["bullet_size"]
	PlayerState.regen = save_data["regen"]
	PlayerState.regen_cooldown = save_data["regen_cooldown"]
	PlayerState.sprayer_limit = save_data["sprayer_limit"]
	PlayerState.sentry_limit = save_data["sentry_limit"]
	PlayerState.blank_limit = save_data["blank_limit"]
	PlayerState.spawner_limit = save_data["spawner_limit"]
	PlayerState.sprayer_count = save_data["sprayer_count"]
	PlayerState.sentry_count = save_data["sentry_count"]
	PlayerState.spawner_count = save_data["spawner_count"]
	PlayerState.blank_count = save_data["blank_count"]
	PlayerState.minimum_gold = save_data["minimum_gold"]
	
	# Load Player Progression
	PlayerState.levels_available = save_data["levels_available"]
	PlayerState.item_counts = save_data["item_counts"]
	PlayerState.level_up_condition = save_data["level_up_condition"]
	PlayerState.enemies_killed = save_data["enemies_killed"]

	for item_name in PlayerState.item_counts.keys():
		var quantity = PlayerState.item_counts[item_name]
		for i in range(quantity):
			PlayerState.player_items.append(Items.all_items[item_name].duplicate())
	
	## Set the unique item pool back to how it should be 
	for item in PlayerState.player_items:
		if item in Items.unique_items:
			Items.unique_items.erase(item.item_name)
	
	# Load Game State
	GameState.stage = save_data["stage"]
	GameState.clear_condition = save_data["clear_condition"]
	GameState.door_position = Vector2(save_data["door_position"]["x"], save_data["door_position"]["y"])
	GameState.player_position = Vector2(save_data["player_position"]["x"], save_data["player_position"]["y"])
	GameState.enemies_killed_this_stage = save_data["enemies_killed_this_stage"]
	GameState.level_cleared = save_data["level_cleared"]
	GameState.enemies_spawning = save_data["enemies_spawning"]
	GameState.wave_started = save_data["wave_started"]
	SceneManager.load_arena()
	
	
