extends Node

@onready var player: CharacterBody2D = $Player
@onready var transition_rect: Panel = $TransitionRect

## Every x seconds after clearing the stage, an extra enemy will spawn each time
@export var extra_spawn_time_scale: float = 20

var minimum_door_spawn_distance: int = 100
var door_spawn_radius: int = 250
var door_spawned = false
var spawn_cooldown = 0
var timer = 0
var time_since_clear = 0
var boss_spawned = false
 
func _ready() -> void:
	var transition_tween = create_tween()
	transition_tween.tween_property(transition_rect, "modulate:a", 0, 2.5)
	EventBus.arena_spawn.connect(add_to_arena)
	EventBus.level_exited.connect(start_new_level)
	EventBus.pause_game.connect(func(): get_tree().paused = true)
	EventBus.unpause_game.connect(func(): get_tree().paused = false)
	EventBus.arena_initialized.emit()
	TowerManager.spawn_saved_towers(self)
	if GameState.door_position != Vector2.ZERO:
		player.global_position = GameState.door_position
	GameState.door_position = Vector2.ZERO
	## Auto save on stage start
	Utils.save_game()
	TowerManager.active_towers.clear()
	Utils.spawn_hit_effect(Color(1, 1, 1, 1), Vector2.ZERO, 1)

func _process(delta: float) -> void:
	transition_rect.position = Vector2(GameState.player_position.x - transition_rect.size.x, GameState.player_position.y - transition_rect.size.y / 2) 
	if not GameState.wave_started:
		return

	check_clear_condition()
	if GameState.level_cleared:
		time_since_clear += delta
		EventBus.update_spawning_bar.emit(time_since_clear, GameState.enemies_spawning, extra_spawn_time_scale)
		if time_since_clear >= extra_spawn_time_scale:
			GameState.enemies_spawning += 1
			EventBus.extra_spawn.emit()
			time_since_clear = 0

	if timer <= 0:
		#for i in range(GameState.enemies_spawning):
		spawn_enemy()
		spawn_cooldown = max(Enemies.MIN_SPAWN_TIME, randf_range(4, 5) - (GameState.stage / 2) - (GameState.enemies_spawning / 1.25))
		timer = spawn_cooldown

	timer -= delta

func spawn_enemy(specific_enemy_scene: PackedScene = null) -> void:
	## Handle boss stage
	if GameState.is_boss_stage and not boss_spawned:
		var boss_scene = Scenes.boss_scenes.pick_random()
		var boss: Enemy = boss_scene.instantiate()
		GameState.enemy_counts[boss.enemy_name] = GameState.enemy_counts.get(boss.enemy_name, 0) + 1

		var boss_position = Utils.get_random_position_in_radius(
			player.position, 
			boss.spawn_radius, 
			boss.min_spawn_dist
		)
		boss.position = boss_position
		add_child(boss)
		boss_spawned = true
		return

	var enemy_scenes = []
	var enemy_scene
	if not specific_enemy_scene:
		if GameState.stage >= 6:
			enemy_scenes.append_array(Scenes.stage_six_enemy_scenes)
		if GameState.stage >= 5:
			enemy_scenes.append_array(Scenes.stage_five_enemy_scenes)
		if GameState.stage >= 4:
			enemy_scenes.append_array(Scenes.stage_four_enemy_scenes)
		if GameState.stage >= 3:
			enemy_scenes.append_array(Scenes.stage_three_enemy_scenes)
		if GameState.stage >= 2:
			enemy_scenes.append_array(Scenes.stage_two_enemy_scenes)
		if GameState.stage >= 1:
			enemy_scenes.append_array(Scenes.stage_one_enemy_scenes)

		enemy_scene = enemy_scenes.pick_random()

		if enemy_scene == Scenes.weak_rusher_scene:
			var weak_rusher_spawn_amount = randi_range(Enemies.WEAK_RUSHER_MIN_SPAWN_AMOUNT, Enemies.WEAK_RUSHER_MAX_SPAWN_AMOUNT) + GameState.stage
			for i in range(weak_rusher_spawn_amount):
				spawn_enemy(Scenes.weak_rusher_scene)
	else:
		enemy_scene = specific_enemy_scene

	var enemy: Enemy = enemy_scene.instantiate()

	if enemy.enemy_name in Enemies.ENEMY_LIMITS:
		var current_count = GameState.enemy_counts.get(enemy.enemy_name, 0)
		if current_count >= (Enemies.ENEMY_LIMITS[enemy.enemy_name] + GameState.stage + GameState.enemies_spawning):
			return
	
	GameState.enemy_counts[enemy.enemy_name] = GameState.enemy_counts.get(enemy.enemy_name, 0) + 1

	var enemy_position = Utils.get_random_position_in_radius(
		player.position, 
		enemy.spawn_radius, 
		enemy.min_spawn_dist
	)
	enemy.position = enemy_position
	enemy.health *= ((float(GameState.enemies_spawning - 1) / 10) + 1) 
	enemy.health += (GameState.stage * 2)
	add_child(enemy)

func check_clear_condition() -> void:
	if not door_spawned and (
	(GameState.is_boss_stage and GameState.boss_dead) or 
	(GameState.enemies_killed_this_stage >= GameState.clear_condition and 
	not GameState.is_boss_stage)
	):
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
	GameState.clear_condition = GameState.stage * GameConstants.DEFAULT_CLEAR_CONDITION
	GameState.enemies_spawning = 1
	GameState.level_cleared = false
	GameState.wave_started = false
	GameState.enemy_counts = {}
	GameState.boss_dead = false
	if GameState.stage % GameState.boss_stage_increment == 0:
		GameState.is_boss_stage = true
	else:
		GameState.is_boss_stage = false

	SceneManager.load_arena()
