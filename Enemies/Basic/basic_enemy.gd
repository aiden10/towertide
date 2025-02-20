extends Enemy

@export var drop_scenes: Array[PackedScene]

func _ready() -> void:
	health = 3
	damage = 1
	speed = 100
	projectile_speed = 300
	firerate_cooldown = 1.5
	distance_threshold = 200
	drops = drop_scenes
	drop_range = 15
	drop_count = 1
	
