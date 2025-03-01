extends CharacterBody2D

class_name Entity

var health: float
var damage: float
var speed: float
var projectile_speed: float
var firerate_cooldown: float = 1.0
var distance_threshold: int
var knockback_velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(delta: float) -> void:
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)
	
	move_and_slide()
