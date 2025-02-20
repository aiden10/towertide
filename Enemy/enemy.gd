extends CharacterBody2D
class_name Enemy

var health: float
var damage: float
var speed: float
var projectile_speed: float
var firerate_cooldown: float
var distance_threshold: int

func _physics_process(delta: float) -> void:
	move_and_slide()

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		queue_free()
