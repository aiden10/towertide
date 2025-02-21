extends Node

var spawn_cooldown = 0
var timer = 0
@onready var player = $Player

@export var enemy_scenes: Array[PackedScene]
@export var door_scene: PackedScene
@export var spawn_radius: float
@export var door_spawn_radius: float
var door_spawned = false

func _ready() -> void:
	EventBus.arena_spawn.connect(add_to_arena)
	EventBus.level_clear.connect(start_new_level)

func _process(delta: float) -> void:
	check_clear_condition()
	if timer <= 0:
		if GameState.level >= 1:
			var enemy_scene = enemy_scenes.pick_random()
			var enemy_position = Utils.get_random_position_in_radius(player.position, spawn_radius)
			var enemy = enemy_scene.instantiate()
			enemy.position = enemy_position
			add_child(enemy)
			
			spawn_cooldown = randf_range(1, 3)
			timer = spawn_cooldown
		
	timer -= delta

func check_clear_condition() -> void:
	if GameState.enemies_killed >= GameState.clear_condition and not door_spawned:
		door_spawned = true
		var door = door_scene.instantiate()
		var door_position = Utils.get_random_position_in_radius(player.position, door_spawn_radius)
		door.position = door_position
		add_child(door)
		
func add_to_arena(child: Node) -> void:
	call_deferred("add_child", child)

func start_new_level() -> void:
	GameState.level += 1
	GameState.enemies_killed = 0
	GameState.clear_condition = GameState.level * 100
	get_tree().change_scene_to_packed(Scenes.shop_scene)
	
