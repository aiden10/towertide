extends Node

## Every x seconds spawn a new enemy at a random position around the player
var spawn_cooldown = 0
var timer = 0
@onready var player = $Player

@export var enemy_scenes: Array[PackedScene]
@export var spawn_radius: float

func _process(delta: float) -> void:
	if timer <= 0:
		if GameState.level == 1:
			var enemy_scene = enemy_scenes.pick_random()
			var enemy_position = get_random_position_in_radius(player.position, spawn_radius)
			var enemy = enemy_scene.instantiate()
			enemy.position = enemy_position
			add_child(enemy)
			
			spawn_cooldown = randf_range(2, 5)
			timer = spawn_cooldown
		
	timer -= delta
	
func get_random_position_in_radius(center: Vector2, radius: float) -> Vector2:
	var random_angle = randf() * 2 * PI	
	var random_radius = sqrt(randf()) * radius

	return center + Vector2(
		cos(random_angle) * random_radius,
		sin(random_angle) * random_radius
	)
