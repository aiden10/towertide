extends CharacterBody2D
class_name Enemy

var health: float
var damage: float
var speed: float
var projectile_speed: float
var firerate_cooldown: float
var distance_threshold: int
var drops: Array[PackedScene]
var drop_range: float
var drop_count: int

func _physics_process(_delta: float) -> void:
	move_and_slide()

func take_damage(damage_taken: float) -> void:
	health -= damage_taken
	if health <= 0:
		on_death()

func on_death() -> void:
	for i in range(drop_count):
		var drop_position = Utils.get_random_position_in_radius(position, drop_range)
		var drop = drops.pick_random().instantiate()
		drop.position = drop_position
		EventBus.arena_spawn.emit(drop)
		
	queue_free()
	
