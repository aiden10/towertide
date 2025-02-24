extends Node

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
	
func spawn_hit_effect(color: Color, position: Vector2, damage: float) -> void:
	var hit_effect = Scenes.hit_effect_scene.instantiate()
	hit_effect.global_position = position
	hit_effect.set_properties(color, damage)
	EventBus.arena_spawn.emit(hit_effect)
	
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
	GameState.xp_count = GameConstants.DEFAULT_XP_COUNT
	GameState.gold_count = GameConstants.DEFAULT_GOLD_COUNT
	GameState.enemies_killed_this_stage = GameConstants.DEFAULT_ENEMIES_KILLED_THIS_STAGE
	GameState.allocate_menu_up = GameConstants.DEFAULT_ALLOCATE_MENU_UP
	GameState.enemies_spawning = GameConstants.DEFAULT_ENEMIES_SPAWNING
	GameState.level_cleared = GameConstants.DEFAULT_LEVEL_CLEARED
	GameState.player_projectiles.clear()
	GameState.selected_tower = null

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
	PlayerState.levels_available = PlayerConstants.DEFAULT_LEVELS_AVAILABLE
	PlayerState.player_items.clear()
	PlayerState.item_counts.clear()
	PlayerState.level_up_condition = PlayerConstants.DEFAULT_LEVEL_UP_CONDITION
	PlayerState.enemies_killed = PlayerConstants.DEFAULT_ENEMIES_KILLED
	
func wipe_saved_game() -> void:
	if FileAccess.file_exists("user://save/save.json"):
		DirAccess.remove_absolute("user://save/save.json")

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
		"level_cleared": GameState.level_cleared
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
	
	## Call reset_player_state and reset_game_state functions here so that 
	## pausing, exiting, and then clicking "new game" will actually start a new game
	
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
	
	# Load Player Progression
	PlayerState.levels_available = save_data["levels_available"]
	PlayerState.item_counts = save_data["item_counts"]
	PlayerState.level_up_condition = save_data["level_up_condition"]
	PlayerState.enemies_killed = save_data["enemies_killed"]

	for item_name in PlayerState.item_counts.keys():
		var quantity = PlayerState.item_counts[item_name]
		for i in range(quantity):
			PlayerState.player_items.append(Items.all_items[item_name].duplicate())

	# Load Game State
	GameState.stage = save_data["stage"]
	GameState.clear_condition = save_data["clear_condition"]
	GameState.door_position = Vector2(save_data["door_position"]["x"], save_data["door_position"]["y"])
	GameState.player_position = Vector2(save_data["player_position"]["x"], save_data["player_position"]["y"])
	GameState.enemies_killed_this_stage = save_data["enemies_killed_this_stage"]
	GameState.level_cleared = save_data["level_cleared"]
	GameState.enemies_spawning = save_data["enemies_spawning"]
	SceneManager.load_arena()
	
	
