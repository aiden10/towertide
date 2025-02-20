extends Enemy

func _ready() -> void:
	health = 3
	damage = 1
	speed = 100
	projectile_speed = 300
	firerate_cooldown = 1.5
	distance_threshold = 200
