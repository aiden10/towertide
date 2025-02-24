extends Node

@onready var player = $Player
@export var enemy_scenes: Array[PackedScene]
@export var door_scene: PackedScene
@export var spawn_radius: float
@export var minimum_spawn_distance: float
@export var minimum_door_spawn_distance: float
@export var door_spawn_radius: float
@export var min_spawn_time: float = 0.1

## Every x seconds after clearing the stage, an extra enemy will spawn each time
@export var extra_spawn_time_scale: float = 30

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

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if GameState.selected_tower:
				GameState.selected_tower.deselect_tower()
				GameState.selected_tower = null

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
		spawn_cooldown = max(min_spawn_time, randf_range(1, 3) - GameState.stage / 10)
		timer = spawn_cooldown

	timer -= delta

func spawn_enemy() -> void:
	if GameState.stage >= 1:
		var enemy_scene = enemy_scenes.pick_random()
		var enemy_position = Utils.get_random_position_in_radius(player.position, spawn_radius, minimum_spawn_distance)
		var enemy = enemy_scene.instantiate()
		enemy.position = enemy_position
		add_child(enemy)

func check_clear_condition() -> void:
	if PlayerState.enemies_killed >= GameState.clear_condition and not door_spawned:
		EventBus.level_cleared.emit()
		GameState.level_cleared = true
		door_spawned = true
		var door = door_scene.instantiate()
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
