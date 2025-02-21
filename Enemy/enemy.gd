extends CharacterBody2D
class_name Enemy

var health: float
var damage: float
var speed: float
var projectile_speed: float
var firerate_cooldown: float
var distance_threshold: int
var gold_drop_count: int
var xp_drop_count: int
var xp_drop_range: int
var gold_drop_range: float
var drop_count: int
var knockback_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if knockback_velocity != Vector2.ZERO:
		velocity = knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, delta * 1000)
	
	move_and_slide()

func take_damage(damage_taken: float, knockback_direction: Vector2 = Vector2.ZERO) -> void:
	health -= damage_taken
	if health <= 0:
		on_death()
	
	if knockback_direction != Vector2.ZERO:
		knockback_velocity = knockback_direction * PlayerState.knockback
		
func on_death() -> void:
	for i in range(gold_drop_count):
		var drop_position = Utils.get_random_position_in_radius(position, gold_drop_range)
		var gold = Scenes.gold_scene.instantiate()
		gold.position = drop_position
		EventBus.arena_spawn.emit(gold)

	for i in range(xp_drop_count):
		var drop_position = Utils.get_random_position_in_radius(position, xp_drop_range)
		var xp = Scenes.xp_scene.instantiate()
		xp.position = drop_position
		EventBus.arena_spawn.emit(xp)
	
	PlayerState.enemies_killed += 1
	queue_free()
	
