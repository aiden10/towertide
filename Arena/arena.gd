extends Node

var spawn_cooldown = 0
var timer = 0
@onready var player = $Player

@export var enemy_scenes: Array[PackedScene]
@export var spawn_radius: float

func _ready() -> void:
	EventBus.arena_spawn.connect(add_to_arena)

func _process(delta: float) -> void:
	if timer <= 0:
		if GameState.level == 1:
			var enemy_scene = enemy_scenes.pick_random()
			var enemy_position = Utils.get_random_position_in_radius(player.position, spawn_radius)
			var enemy = enemy_scene.instantiate()
			enemy.position = enemy_position
			add_child(enemy)
			
			spawn_cooldown = randf_range(1, 3)
			timer = spawn_cooldown
		
	timer -= delta

func add_to_arena(child: Node) -> void:
	call_deferred("add_child", child)
