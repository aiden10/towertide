extends Area2D
class_name Pickup

enum PickupType {
	GOLD,
	XP,
	ITEM,
	ABILITY
}

var type: PickupType
var pickup_range: float = 5  # Distance at which item is collected
var current_speed: float
var speed: int
var direction: Vector2
var velocity: Vector2
var pickup_distance: int
var player: CharacterBody2D = null
var in_attract_range: bool = false

func _ready() -> void:
	current_speed = speed

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		in_attract_range = true
		player = parent

func _pickup_range_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player = parent
		on_pickup()	

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		player = null
		direction = Vector2.ZERO
		in_attract_range = false
		velocity = Vector2.ZERO
		
func _physics_process(delta: float) -> void:
	if not in_attract_range:
		return
		
	if player:
		current_speed = speed
		direction = (player.position - position).normalized()

		velocity = direction * speed
		position += velocity * delta
	else:
		# Gradually slow down when no player is in range
		current_speed = move_toward(current_speed, 0, delta * 100)

func on_pickup() -> void:
	pass
