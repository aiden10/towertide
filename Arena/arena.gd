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
	EventBus.level_exited.connect(start_new_level)

func _process(delta: float) -> void:
	check_clear_condition()
	if timer <= 0:
		if PlayerState.level >= 1:
			var enemy_scene = enemy_scenes.pick_random()
			var enemy_position = Utils.get_random_position_in_radius(player.position, spawn_radius)
			var enemy = enemy_scene.instantiate()
			enemy.position = enemy_position
			add_child(enemy)
			
			spawn_cooldown = randf_range(1, 3)
			timer = spawn_cooldown

	timer -= delta

func check_clear_condition() -> void:
	if PlayerState.enemies_killed >= PlayerState.clear_condition and not door_spawned:
		EventBus.level_cleared.emit()
		door_spawned = true
		var door = door_scene.instantiate()
		var door_position = Utils.get_random_position_in_radius(player.position, door_spawn_radius)
		door.position = door_position
		add_child(door)

func add_to_arena(child: Node) -> void:
	call_deferred("add_child", child)

func start_new_level() -> void:
	PlayerState.level += 1
	PlayerState.health = PlayerState.max_health
	PlayerState.enemies_killed = 0
	PlayerState.clear_condition = PlayerState.level * 100
	get_tree().call_deferred("change_scene_to_packed", Scenes.shop_scene)	
