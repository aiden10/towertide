extends Enemy

func _ready() -> void:
	health = 3
	damage = 1
	speed = 100
	projectile_speed = 300
	firerate_cooldown = 1.5
	distance_threshold = 200
	gold_drop_range = 15
	xp_drop_range = 50
	gold_drop_count = 1
	xp_drop_count = 5
	
