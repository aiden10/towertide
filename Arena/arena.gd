extends Node

@onready var player: CharacterBody2D = $Player

## Every x seconds after clearing the stage, an extra enemy will spawn each time
@export var extra_spawn_time_scale: float = 30

var spawn_radius: int = 800
var minimum_spawn_distance: int = 500
var minimum_door_spawn_distance: int = 100
var door_spawn_radius: int = 250
var min_spawn_time: float = 0.1
var door_spawned = false
var spawn_cooldown = 0
var timer = 0
var time_since_clear = 0

func _ready() -> void:
	EventBus.arena_spawn.connect(add_to_arena)
	EventBus.level_exited.connect(start_new_level)
	EventBus.pause_game.connect(func(): get_tree().paused = true)
	EventBus.unpause_game.connect(func(): get_tree().paused = false)
	EventBus.arena_initialized.emit()
	TowerManager.spawn_saved_towers(self)
	TowerManager.active_towers.clear()
	if GameState.door_position != Vector2.ZERO:
		player.global_position = GameState.door_position
	GameState.door_position = Vector2.ZERO
	
func _process(delta: float) -> void:
	check_clear_condition()
	if GameState.level_cleared:
		time_since_clear += delta
		EventBus.update_spawning_bar.emit(time_since_clear, GameState.enemies_spawning, extra_spawn_time_scale)
		if time_since_clear >= extra_spawn_time_scale:
			GameState.enemies_spawning += 1
			EventBus.extra_spawn.emit()
			time_since_clear = 0

	if timer <= 0:
		for i in range(GameState.enemies_spawning):
			spawn_enemy()
		spawn_cooldown = max(min_spawn_time, randf_range(3, 5) - GameState.stage / 10)
		timer = spawn_cooldown

	timer -= delta

func spawn_enemy() -> void:
	var enemy_scenes = []
	if GameState.stage >= 2:
		enemy_scenes.append_array(Scenes.stage_two_enemy_scenes)
	if GameState.stage >= 1:
		enemy_scenes.append_array(Scenes.stage_one_enemy_scenes)
	
	if enemy_scenes.is_empty():
		return
	
	var enemy_scene = enemy_scenes.pick_random()
	
	if enemy_scene == Scenes.weak_rusher_scene:
		spawn_enemy()
		return
	
	var enemy = enemy_scene.instantiate()
	
	if enemy.enemy_name in Enemies.ENEMY_LIMITS:
		var current_count = GameState.enemy_counts.get(enemy.enemy_name, 0)
		if current_count >= Enemies.ENEMY_LIMITS[enemy.enemy_name]:
			spawn_enemy()
			return
	
	GameState.enemy_counts[enemy.enemy_name] = GameState.enemy_counts.get(enemy.enemy_name, 0) + 1
	
	var enemy_position = Utils.get_random_position_in_radius(
		player.position, 
		spawn_radius, 
		minimum_spawn_distance
	)
	enemy.position = enemy_position
	add_child(enemy)

func check_clear_condition() -> void:
	if GameState.enemies_killed_this_stage >= GameState.clear_condition and not door_spawned:
		EventBus.level_cleared.emit()
		GameState.level_cleared = true
		door_spawned = true
		var door = Scenes.door_scene.instantiate()
		var door_position = Utils.get_random_position_in_radius(player.position, door_spawn_radius, minimum_door_spawn_distance)
		door.position = door_position
		add_child(door)

func add_to_arena(child: Node) -> void:
	call_deferred("add_child", child)

func start_new_level() -> void:
	var towers = get_tree().get_nodes_in_group("Towers")
	for tower in towers:
		TowerManager.save_tower(tower)
	GameState.stage += 1
	PlayerState.health = PlayerState.max_health
	GameState.enemies_killed_this_stage = 0
	GameState.clear_condition = GameState.stage * 100
	GameState.enemies_spawning = 1
	GameState.level_cleared = false
	get_tree().call_deferred("change_scene_to_packed", Scenes.shop_scene)
