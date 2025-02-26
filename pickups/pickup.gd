extends Area2D
class_name Pickup

enum PickupType {
	GOLD,
	XP,
	ITEM
}

var type: PickupType
var speed: float
var pickup_distance: int
var player: CharacterBody2D = null
var in_attract_range: bool = false

# Cache these to avoid repeated calculations
var player_detection_area: Area2D
var player_position: Vector2
var pickup_position: Vector2

signal return_to_pool(pickup)

func _ready() -> void:
	player_detection_area = $PickupArea if has_node("PickupArea") else self
	
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	pickup_position = position

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		in_attract_range = true
		player = parent

func _on_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("Player"):
		in_attract_range = false
		player = null
		
func _physics_process(delta: float) -> void:
	if not in_attract_range or not player:
		return
	
	player_position = player.position
	pickup_position = position
	
	var direction = (player_position - pickup_position).normalized()
	position += direction * speed * delta
	
	if position.distance_to(player_position) <= pickup_distance:
		on_pickup()

func on_pickup() -> void:
	pass
