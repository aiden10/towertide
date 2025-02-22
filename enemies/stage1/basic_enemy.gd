extends Enemy

func _ready() -> void:
	health = 30
	damage = 10
	speed = 100
	projectile_speed = 300
	firerate_cooldown = 1.5
	distance_threshold = randi_range(200, 500)
	gold_drop_range = 15
	xp_drop_range = 50
	gold_drop_count = 1
	xp_drop_count = 5
	
